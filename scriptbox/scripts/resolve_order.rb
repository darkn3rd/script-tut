require 'yaml'

PACKAGE_TYPES = %w[brew cask tap cpan cpanm system apt pyenv rbenv sdkman choco choco_cyg feature gem pacman path cyg cmd].freeze

# flatten - walks the macos.yml tree in document order and produces one
#  array of "steps". A step is either a package (brew/cask/tap/cpan/cpanm/
#  system) or a script - including scripts attached to a package via a
#  sibling `script:` key, which become their own step (tagged with
#  attached_to) immediately following the package they belong to, so a
#  package and its post-install script can be moved together as a unit.
def flatten(node, path = [])
  steps = []
  return steps unless node.is_a?(Hash)

  if node['packages'].is_a?(Array)
    node['packages'].each do |entry|
      type = PACKAGE_TYPES.find { |t| entry.key?(t) } || (entry.key?('script') ? 'script' : nil)
      next unless type

      steps << {
        type: type,
        name: entry[type],
        meets: entry['meets'],
        needs: entry['needs'],
        cmd: entry['cmd'],
        reboot: entry['reboot'],
        path: path.join('.')
      }
      if type != 'script' && entry['script']
        steps << { type: 'script', name: entry['script'], attached_to: entry[type], path: path.join('.') }
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
#  it), plus a directly-following script step attached to this provider.
def unit_span(steps, index)
  start = index
  while start > 0 &&
        steps[start - 1][:type] == 'tap' &&
        steps[start - 1][:path] == steps[index][:path]
    start -= 1
  end

  finish = index
  nxt = steps[index + 1]
  finish += 1 if nxt && nxt[:type] == 'script' && nxt[:attached_to] == steps[index][:name]

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

# shared_providers(steps) - every step whose `meets:` must run before
#  more than one generated function, so no single section function can
#  locally guarantee it already ran by the time it's needed. Walked from
#  the `needs:` side and resolved to `steps.find { meets == needs }` -
#  the exact same first-match tie-break resolve! itself uses - rather
#  than from the `meets:` side, because more than one step can carry the
#  same `meets:` value (confirmed directly in ubuntu2204.yml: both
#  global's own `apt: [...] meets: make` and compiled_lang's `apt:
#  build-essential meets: make` exist, but only the first is ever the
#  real provider any `needs: make` consumer actually resolves to) -
#  walking from `meets:` independently would wrongly flag *both* as
#  shared and emit the same provider_make twice.
#  Caught two ways: directly, a consumer's resolved provider lives in a
#  *different* owning_function than the consumer itself; or
#  transitively, the consumer is itself already shared, so whatever it
#  needs must now also run before any section function, regardless of
#  where that provider's own owning_function happens to be. The
#  transitive case is a real one, not hypothetical - confirmed directly
#  in ubuntu2204.yml: testbox's own `meets: ruby` step also `needs:
#  rbenv`, whose provider lives in gen_scripts. Both must run before any
#  section function, not just the ruby one, since testbox's step no
#  longer runs adjacent to its normal neighbors once it's hoisted out.
#  Return order is arbitrary (Hash iteration order) - see split_shared,
#  which walks `steps` itself (already resolve!-ordered, so already
#  dependency-correct) to decide what order to actually emit these in.
def shared_providers(steps)
  shared = {}
  loop do
    added = false
    steps.each do |consumer|
      next unless consumer[:needs]

      provider = steps.find { |s| s[:meets] == consumer[:needs] }
      next unless provider
      next if shared[provider]

      crosses = shared[consumer] || owning_function(consumer) != owning_function(provider)
      next unless crosses

      shared[provider] = true
      added = true
    end
    break unless added
  end
  steps.select { |s| shared[s] }
end

# split_shared(steps) - partitions steps (already flatten + resolve! +
#  dedup'd) into [shared_groups, local]. shared_groups is one entry per
#  shared_providers step, each carrying its own unit (see unit_span - a
#  preceding tap, or an attached follow-up script) since a provider's
#  unit must move as one block or its post-install script would run in
#  the wrong place - named "provider_<meets>" for generate_install_
#  script.rb to define as its own function, called before any section
#  function. local is everything left, still in original relative
#  order, destined for whichever function owning_function says it
#  belongs in. shared_groups is already in dependency-correct call order
#  - a subsequence of resolve!'s own already-correct full ordering stays
#  correct on its own, without needing a second resolve pass just over
#  the subset.
def split_shared(steps)
  primary = shared_providers(steps)
  claimed = Array.new(steps.length, false)

  groups = primary.map do |provider_step|
    idx = steps.index(provider_step)
    start, finish = unit_span(steps, idx)
    (start..finish).each { |i| claimed[i] = true }
    { name: "provider_#{provider_step[:meets]}", steps: steps[start..finish] }
  end

  local = steps.each_index.reject { |i| claimed[i] }.map { |i| steps[i] }
  [groups, local]
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
