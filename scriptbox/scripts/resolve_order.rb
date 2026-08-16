require 'yaml'

PACKAGE_TYPES = %w[brew cask tap cpan cpanm system apt pyenv rbenv sdkman choco choco_cyg feature gem pacman path cyg cmd].freeze

# RESERVED_KEYS - top-level manifest keys that aren't a platform's own
#  root key - shared by generate_install_script.rb's and generate_chef_
#  databag.rb's own root_key, and gen_installer.rb's own --platform
#  validation, so all three never drift out of sync on what counts as
#  "not a platform" as new top-level blocks (files:, appends:) get
#  added. Ruby constants aren't file-scoped, so defining this more than
#  once across files that require each other silently shadows one
#  definition with the other instead of erroring - one shared source
#  here avoids that entirely.
RESERVED_KEYS = %w[scripts files appends add_apt_repos environments].freeze

# ATTACHABLE_KEYS - sibling keys that each add one more step immediately
#  following the package they're declared on (see flatten's own
#  attached_to handling below) - `script:` (a follow-up command, from
#  the manifest's own scripts: block), `file:` (a static file to write,
#  from files:), and `append:` (idempotent line-appends to one or more
#  dest files, from appends:). An entry can carry more than one of these
#  at once (e.g. a package needing both a post-install script and a
#  profile append), each becoming its own attached step in the order
#  listed here.
ATTACHABLE_KEYS = %w[script file append].freeze

# flatten - walks the macos.yml tree in document order and produces one
#  array of "steps". A step is either a package (brew/cask/tap/cpan/cpanm/
#  system) or something from ATTACHABLE_KEYS attached to a package via a
#  sibling key, which becomes its own step (tagged with attached_to)
#  immediately following the package they belong to, so a package and
#  its own follow-ups can be moved together as a unit (see unit_span).
def flatten(node, path = [])
  steps = []
  return steps unless node.is_a?(Hash)

  if node['packages'].is_a?(Array)
    node['packages'].each do |entry|
      type = PACKAGE_TYPES.find { |t| entry.key?(t) } || (ATTACHABLE_KEYS.find { |k| entry.key?(k) })
      next unless type

      steps << {
        type: type,
        name: entry[type],
        meets: entry['meets'],
        needs: entry['needs'],
        cmd: entry['cmd'],
        reboot: entry['reboot'],
        apt_repository: entry['apt_repository'],
        add_apt_repo: entry['add_apt_repo'],
        path: path.join('.')
      }

      # `key == type` is skipped, not the whole loop - `type` can itself
      #  be an ATTACHABLE_KEYS entry (a bare `script:` with no real
      #  package type alongside it, e.g. the sdkman bootstrap's own
      #  `- script: ubuntu22_sdkman\n  append: ubuntu22_sdkman`), in
      #  which case it was already emitted as the primary step above -
      #  only that one key would double up; a *different* attachable key
      #  on the same entry (append: here) still needs its own step.
      #  Confirmed via a real `vagrant provision` run: the old `next if
      #  ATTACHABLE_KEYS.include?(type)` bailed out of this entire loop
      #  whenever the primary type itself was attachable, silently
      #  dropping that sibling append: step from *every* generator, not
      #  just the Chef one.
      ATTACHABLE_KEYS.each do |key|
        next if key == type
        next unless entry[key]

        # Array(entry[key]) - an attachable key's own value can be a
        #  single name (ubuntu22_go's own `append: ubuntu22_go`) or a
        #  list of names (rbenv/pyenv's own `append: [ubuntu22_rbenv_
        #  bash, ubuntu22_rbenv_zsh]`, one appends: block per shell) -
        #  one step per name either way, never one step holding an array
        #  as its own :name (every consumer - append_lines, step_to_
        #  entry - looks up tree['appends'] by a single string key).
        Array(entry[key]).each do |name|
          steps << { type: key, name: name, attached_to: entry[type], path: path.join('.') }
        end
      end
    end
  end

  node.each do |key, value|
    next if key == 'packages'
    steps.concat(flatten(value, path + [key])) if value.is_a?(Hash)
  end

  steps
end

# dedup! - drops a later step whose (type, name) already appeared
#  earlier in the list, keeping the *first* occurrence and its position -
#  confirmed directly this is needed: testbox's own `- rbenv: 4.0.6` and
#  `- script: ubuntu22_powershell` each duplicate a step gen_scripts/win_scripts
#  already installs elsewhere in the same file, running the same apt/curl
#  work twice for no reason (each one individually is idempotent - rbenv
#  install -s, apt-get install -y - just wasteful, not harmful, to run
#  twice). A `script` step attached to a package (see attached_to) is
#  keyed on its *own* name, not the package's, so an identical script
#  reused by two different packages is still only ever run once too.
def dedup!(steps)
  seen = {}
  steps.reject! do |step|
    key = [step[:type], step[:name]]
    if seen[key]
      true
    else
      seen[key] = true
      false
    end
  end
  steps
end

# unit_span - the contiguous [start, end] index range that must move
#  together with the provider at `index`: any directly-preceding `tap`
#  steps in the *same* package list (a cask's tap must stay right before
#  it), plus every directly-following ATTACHABLE_KEYS step attached to
#  this provider (an entry can carry more than one - e.g. both a
#  `script:` and an `append:` - flatten emits them consecutively, so
#  this walks forward through all of them, not just one).
def unit_span(steps, index)
  start = index
  while start > 0 &&
        steps[start - 1][:type] == 'tap' &&
        steps[start - 1][:path] == steps[index][:path]
    start -= 1
  end

  finish = index
  while (nxt = steps[finish + 1]) && ATTACHABLE_KEYS.include?(nxt[:type]) && nxt[:attached_to] == steps[index][:name]
    finish += 1
  end

  [start, finish]
end

# resolve! - for every step with `needs: X`, finds the first step with
#  `meets: X` (first listed provider wins) and, if that provider currently
#  sits after the consumer, moves its whole unit to just before it.
#  Leaves order untouched when the provider already comes first.
def resolve!(steps)
  loop do
    moved = false

    steps.each_with_index do |consumer, c_index|
      next unless consumer[:needs]

      p_index = steps.index { |s| s[:meets] == consumer[:needs] }
      next unless p_index
      next if p_index < c_index

      start, finish = unit_span(steps, p_index)
      unit = steps.slice!(start, finish - start + 1)
      insert_at = steps.index(consumer)
      steps.insert(insert_at, *unit)
      moved = true
      break
    end

    break unless moved
  end
  steps
end

# FUNCTION_SECTIONS - the tree keys that become their own generated
#  function (see generate_install_script.rb's own section-function
#  emission). Everything else - an individual lesson topic like "groovy"
#  or "posix" - inlines into its nearest ancestor from this list instead
#  of getting a function of its own, matching what was actually asked
#  for: "lessons would call gen_scripts(), shell_scripts()... at this
#  level they'll just call what is necessary to install the packages" -
#  one function per organizational section, not one per topic.
FUNCTION_SECTIONS = %w[global lessons cibox scriptbox testbox gen_scripts shell_scripts compiled_lang win_scripts].freeze

# owning_function(step) - the name of the generated function step's own
#  install command ends up inside: the last of step's own path segments
#  that names a real function boundary (see FUNCTION_SECTIONS). A step
#  several levels deeper than any boundary (e.g. "global.lessons.
#  gen_scripts.groovy") still resolves to its nearest ancestor
#  ("gen_scripts"), not itself - "groovy" isn't a function.
def owning_function(step)
  step[:path].split('.').reverse.find { |seg| FUNCTION_SECTIONS.include?(seg) }
end

# natural_function_order(raw_steps) - the order function boundaries are
#  first encountered in the *original*, pre-resolve! document order -
#  i.e. the order the underlying tree's own hash keys were actually
#  written in, which is what the generated call tree (see
#  generate_install_script.rb's section_tree/emit_section_functions)
#  actually calls its own children in. Deliberately computed from
#  flatten()'s own raw output, not the post-resolve! steps list -
#  resolve! moves *individual* steps earlier (e.g. compiled_lang's own
#  `meets: java` step gets moved to sit right before gen_scripts's own
#  `needs: java` consumer), which would make compiled_lang look like it
#  starts early even though the rest of its own content still runs much
#  later - only the raw, undisturbed document order reflects where a
#  whole function's content actually lives in the call tree.
def natural_function_order(raw_steps)
  order = []
  raw_steps.each do |step|
    step[:path].split('.').each do |seg|
      order << seg if FUNCTION_SECTIONS.include?(seg) && !order.include?(seg)
    end
  end
  order
end

# needs_relocation?(provider, consumer, natural_order) - true if the
#  generated call tree can't be trusted to already run `provider` before
#  `consumer` on its own, so generate_install_script.rb has to actually
#  move it. Same owning_function: false - resolve! already puts them in
#  the right relative order within that one function's own local body
#  (see relocate_cross_cutting). Different owning_function, but
#  provider's whole function is a strictly earlier sibling/ancestor in
#  the natural call tree: also false - it's already guaranteed to have
#  completely finished by the time the consumer's function is even
#  entered (confirmed directly: ubuntu2204.yml's own `rbenv`/`ruby`/
#  `make`/`perl` steps all fall in this case - gen_scripts is lessons'
#  *first* child, so nothing about scriptbox or shell_scripts needing
#  them ever required moving anything). True only for a genuine
#  cross-cutting case, like the same file's own `groovy` (in
#  gen_scripts, lessons' first child) needing `java` (in compiled_lang,
#  lessons' *third* child) - the natural call order runs gen_scripts
#  before compiled_lang even starts, so nothing short of actually moving
#  java's own install earlier fixes it.
def needs_relocation?(provider, consumer, natural_order)
  fp = owning_function(provider)
  fc = owning_function(consumer)
  return false if fp == fc

  fp_index = natural_order.index(fp)
  fc_index = natural_order.index(fc)
  fp_index.nil? || fc_index.nil? || fp_index > fc_index
end

# relocate_cross_cutting(steps, natural_steps, natural_order) - handles
#  the genuine cross-cutting needs:/meets: pairs (see needs_relocation?)
#  the way the ordinary call tree can't fix on its own: pulls each such
#  provider - along with its own unit (see unit_span) *and* whatever of
#  its own owning function's local steps naturally precede it - out of
#  its natural position, and arranges for a call to it to run
#  immediately before the consumer, inside the consumer's *own*
#  function. The precedes-it prefix matters because those steps aren't
#  necessarily tagged with their own meets: at all - e.g. compiled_lang's
#  own `apt: curl` isn't declared as anything java needs, but it does
#  sit before java in compiled_lang's own local sequence, so it has to
#  go along too or java's relocated call would run without it. Found by
#  walking backward through `natural_steps` - the *pre-resolve!* snapshot
#  (see natural_function_order) - specifically because `steps` itself
#  can't answer this anymore: resolve! has already physically moved
#  `provider` away from those very neighbors (that's the whole reason it
#  needs relocating at all), so looking at what's immediately before it
#  in `steps` would find whatever resolve! happened to splice in next to
#  it instead, not its real local siblings.
#  Placing the call inside the *consumer's* function, rather than some
#  separate pre-phase, is what keeps this correct without having to
#  separately re-derive the provider's own ancestor chain: the
#  consumer's own function is already guaranteed (by the ordinary call
#  tree) to run after everything *its* ancestors do, so a relocated
#  provider inserted right there inherits that guarantee for free.
#  Transitive case (a relocated provider that itself `needs:` something
#  also needing relocation) is handled the same way, recursively - its
#  own relocated prerequisite gets inserted right before *it*, wherever
#  it itself ends up.
#  Returns [groups, claimed, insert_before]: groups is the ordered list
#  of {name:, steps:} provider bundles to define as their own function
#  (see generate_install_script.rb's emit_provider_functions) - defined,
#  but not called from anywhere but the insertion points below. claimed
#  flags every original steps[] index pulled out of its natural local
#  position, for section_tree to exclude. insert_before maps a step's
#  object_id to the ordered array of group names that must be called
#  immediately before it, wherever *it* ends up.
def relocate_cross_cutting(steps, natural_steps, natural_order)
  claimed = Array.new(steps.length, false)
  insert_before = Hash.new { |h, k| h[k] = [] }
  groups = []
  group_for = {} # provider step's object_id => group name, once relocated

  relocate = lambda do |provider|
    next group_for[provider.object_id] if group_for[provider.object_id]

    idx = steps.index(provider)
    start, finish = unit_span(steps, idx)
    unit = steps[start..finish]
    unit.each { |s| claimed[steps.index(s)] = true }

    f = owning_function(provider)
    n_idx = natural_steps.index(provider)
    prefix = []
    i = n_idx - 1
    while i >= 0 && owning_function(natural_steps[i]) == f
      sibling = natural_steps[i]
      i -= 1

      # Only f's *own* direct packages (path ends exactly at f) count as
      #  an implicit prerequisite - a *sibling* subsection that merely
      #  inlines into the same function (e.g. compiled_lang.cs, sitting
      #  between compiled_lang's own curl/build-essential and
      #  compiled_lang.java in document order) is not one, and pulling
      #  it in anyway would just relocate an unrelated install (here,
      #  .NET SDK) for no reason.
      next unless sibling[:path].split('.').last == f

      r_idx = steps.index(sibling)
      # A section-filtered `steps` (see generate_install_script.rb's own
      #  select_sections) may not include this natural-order sibling at
      #  all - skip it and keep looking further back rather than
      #  stopping the whole walk on a step that isn't even part of this
      #  run.
      next if r_idx.nil?
      break if claimed[r_idx] # already pulled in by an earlier relocation - nothing further back is unclaimed either

      prefix.unshift(sibling)
      claimed[r_idx] = true
    end

    group_steps = prefix + unit
    name = "provider_#{provider[:meets]}"
    group_for[provider.object_id] = name
    groups << { name: name, steps: group_steps }

    # A step within this pulled-along group might itself `need:`
    #  something that also requires relocation - resolve recursively,
    #  inserting immediately before *that* step wherever it lands.
    group_steps.each do |s|
      next unless s[:needs]

      dep = steps.find { |x| x[:meets] == s[:needs] }
      next unless dep && needs_relocation?(dep, s, natural_order)

      dep_name = relocate.call(dep)
      insert_before[s.object_id] << dep_name unless insert_before[s.object_id].include?(dep_name)
    end

    name
  end

  steps.each do |consumer|
    next unless consumer[:needs]

    provider = steps.find { |s| s[:meets] == consumer[:needs] }
    next unless provider && needs_relocation?(provider, consumer, natural_order)

    group_name = relocate.call(provider)
    insert_before[consumer.object_id] << group_name unless insert_before[consumer.object_id].include?(group_name)
  end

  [groups, claimed, insert_before]
end

if __FILE__ == $PROGRAM_NAME
  tree = YAML.load_file(File.join(__dir__, '..', 'config', 'macos.yml'))
  steps = flatten(tree['macos'])
  resolve!(steps)
  steps.each do |s|
    extra = []
    extra << "meets:#{s[:meets]}" if s[:meets]
    extra << "needs:#{s[:needs]}" if s[:needs]
    extra << "attached_to:#{s[:attached_to]}" if s[:attached_to]
    puts "[#{s[:path]}] #{s[:type]}: #{s[:name]}" + (extra.empty? ? '' : "  (#{extra.join(', ')})")
  end
end
