require 'yaml'

PACKAGE_TYPES = %w[brew cask tap cpan cpanm system apt pyenv rbenv rvm sdkman asdf asdf_plugin choco choco_cyg choco_local feature gem pacman path cyg cmd pipx powershell_package_provider powershell_module powershell_cmd noop].freeze

# VERSION_OPS - the only version-constraint operators any downstream
#  generator actually implements (see parse_version_constraint) - a
#  floor (>=) or an exact pin (= or no operator at all). Deliberately not
#  the full pip/gem/npm vocabulary (~>/^/~=/<=/<...): nothing in this
#  pipeline targets a tool that can express more than a floor or a pin
#  yet (Install-PackageProvider only has -MinimumVersion; choco_local's
#  own `choco install --version=` is always exact), so parsing anything
#  richer would just be guessing at semantics no generator can act on.
VERSION_OPS = ['=', '>='].freeze

# IMPLICIT_NEEDS - a package type's own unconditional prerequisite,
#  regardless of what any individual step declares - every cpan/cpanm
#  step needs perl's own bootstrap (system: perl's attached
#  ubuntu22_cpan_local_setup script, meets: perl) to have already run,
#  or the first-ever cpan invocation hits a real CPAN FirstTime.pm
#  reentrancy bug (confirmed directly against a fresh Ubuntu 22.04 box).
#  A manifest-level needs: perl on every current and future cpan/cpanm
#  step would say the same thing over and over for no reason - the type
#  itself already implies it.
IMPLICIT_NEEDS = { 'cpan' => 'perl', 'cpanm' => 'perl' }.freeze

# RESERVED_KEYS - top-level manifest keys that aren't a platform's own
#  root key - shared by generate_install_script.rb's and generate_chef_
#  databag.rb's own root_key, and gen_installer.rb's own --platform
#  validation, so all three never drift out of sync on what counts as
#  "not a platform" as new top-level blocks (files:, appends:) get
#  added. Ruby constants aren't file-scoped, so defining this more than
#  once across files that require each other silently shadows one
#  definition with the other instead of erroring - one shared source
#  here avoids that entirely. `variables:` (see substitute_variables)
#  is deliberately NOT one of these - unlike scripts:/appends:/files:,
#  it isn't a cross-platform shared namespace looked up by name from
#  inside any platform's own tree; it lives *nested inside* each
#  platform's own root key instead (a sibling of that platform's own
#  shell:/global: - see dialect_for's own node['shell']), the same way
#  a version pin means something different per platform and has no
#  business being visible to, or colliding with, a same-named variable
#  under some other platform's own key.
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
#  system/... - see PACKAGE_TYPES) or something from ATTACHABLE_KEYS
#  attached to a package via a sibling key, which becomes its own step
#  (tagged with attached_to) immediately following the package they
#  belong to, so a package and its own follow-ups can be moved together
#  as a unit (see unit_span). `noop` is a package type like any other
#  here (so it gets its own step, not silently dropped the way an
#  entry with no recognized type at all is - see the `next unless type`
#  just below) but installs nothing of its own - see generate_install_
#  script.rb's own noop_comment. It exists purely to give a meets:/
#  needs: pair somewhere real to attach to when neither side of that
#  association is an actual package install on its own - e.g.
#  windows.yml's own gen_scripts.go, which needs: make but has no
#  package of its own that isn't already fully described by `choco:
#  go` - `- noop: go_needs_make\n  needs: make` documents that
#  dependency (and lets resolve!/relocate_cross_cutting actually see
#  and act on it) without pretending it's a second install of go.
def flatten(node, path = [])
  steps = []
  return steps unless node.is_a?(Hash)

  if node['packages'].is_a?(Array)
    node['packages'].each do |entry|
      type = PACKAGE_TYPES.find { |t| entry.key?(t) } || (ATTACHABLE_KEYS.find { |k| entry.key?(k) })
      next unless type

      # Merged, not just defaulted - an explicit needs: on a cpan/cpanm
      #  step (e.g. a real, additional prerequisite) still applies on
      #  top of the implicit one, never silently replaced by it. nil,
      #  not [], when there's genuinely nothing - several call sites
      #  downstream do a plain `if step[:needs]` truthiness check, and
      #  [] is truthy in Ruby.
      needs = (Array(entry['needs']) + Array(IMPLICIT_NEEDS[type])).uniq
      needs = nil if needs.empty?

      steps << {
        type: type,
        name: entry[type],
        meets: entry['meets'],
        needs: needs,
        cmd: entry['cmd'],
        reboot: entry['reboot'],
        apt_repository: entry['apt_repository'],
        add_apt_repo: entry['add_apt_repo'],
        version: entry['version'],
        args: entry['args'],
        condition: entry['condition'],
        tags: Array(entry['tags']),
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
        #  tags: inherited from the entry itself, not re-declared per
        #  attachment - an append:/file: attached to a tagged package
        #  (e.g. ubuntu22_asdf's own bootstrap script + its append:
        #  entries) has to rise or fall with that same package under
        #  tag-based selection (see select_by_tags), not run
        #  unconditionally as an untagged step would - appending asdf's
        #  own PATH lines to .bashrc regardless of whether asdf was
        #  actually installed would be a real bug, not a harmless extra.
        Array(entry[key]).each do |name|
          steps << { type: key, name: name, attached_to: entry[type], tags: Array(entry['tags']), path: path.join('.') }
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

# compute_default_wins(steps, select_tags) - path -> true/false, one
#  entry per distinct containing packages: array (step[:path]) - the
#  natural "alternatives for the same thing" scope (rbenv/asdf/rvm all
#  under gen_scripts.ruby.packages; sdkman_groovy/asdf_groovy both under
#  gen_scripts.groovy.packages). True means nothing in that *same*
#  group's own tags overlaps the raw select_tags at all, so whichever
#  member(s) carry the literal tag 'default' win it. Scoped per group,
#  not globally - an unrelated --select naming a tag in a *different*
#  group must never suppress it. Confirmed directly this matters:
#  `--select rvm` (ruby's own group) was silently shutting off groovy's
#  entirely unrelated sdkman default, under the old design where any
#  --select at all disabled every 'default' tag in the whole manifest,
#  not just the ones actually competing with what was selected.
def compute_default_wins(steps, select_tags)
  steps.group_by { |s| s[:path] }.transform_values do |group|
    tags_in_group = group.flat_map { |s| s[:tags] }.uniq
    (tags_in_group & select_tags).empty?
  end
end

# compute_enabled_tags(steps, select_tags, default_wins) - select_tags,
#  expanded to include every *other* tag (never the literal string
#  'default' itself) belonging to a step whose own group's default won
#  (see compute_default_wins). 'default' is a marker meaningful only
#  within one group's own resolution, never a real capability name -
#  propagating the bare word itself would let it leak across completely
#  unrelated groups the instant *any* group's default won (confirmed
#  directly: ruby's own rvm winning promoted the bare word 'default'
#  into the enabled set, which then also matched groovy's unrelated
#  sdkman path, since it too carries a literal 'default' tag - the exact
#  cross-category leak compute_default_wins' own per-group scoping was
#  supposed to prevent, just reintroduced one level down). tag_eligible?
#  checks every step in the whole tree against this set for its *other*
#  tags, regardless of position - but still checks 'default' itself
#  only via default_wins, per group, never via this flat set (see
#  tag_eligible?'s own comment on why a step whose only tag is
#  'default' - nothing else to propagate - still needs to remain
#  eligible in its own group).
def compute_enabled_tags(steps, select_tags, default_wins)
  propagated = steps.select { |s| s[:tags].include?('default') && default_wins[s[:path]] }
                     .flat_map { |s| s[:tags] - ['default'] }
  (select_tags + propagated).uniq
end

# tag_eligible?(step, enabled_tags, default_wins, exclude_tags) - whether
#  `step` passes its own tags: gate on its own, before any needs:/meets:
#  pull-in is even considered (see select_by_tags) - issue #16's source-
#  of-truth design for letting a manifest express more than one
#  legitimate path to the same tool (rbenv/pyenv/asdf vs. Ubuntu's own
#  system ruby/python packages) without installing all of them at once.
#  - An untagged step is always eligible - today's behavior, unchanged.
#  - A tagged step is eligible if any of its own tags is in
#    `enabled_tags` (see compute_enabled_tags - select_tags itself, plus
#    every *other* tag propagated from a step whose own group's default
#    won). Tree position plays no part in this at all - an ancestor-
#    level bootstrap (e.g. a sdkman install script tagged the same
#    sdkman_groovy/sdkman_java a descendant leaf uses) is eligible the
#    instant one of its own tags is enabled, the same as any other step
#    - no needs:/meets: link required, and no special-casing for "this
#    step happens to sit above the one that actually chose the tag."
#    Execution ORDER is a completely separate concern (see resolve!/
#    select_sections), unaffected by any of this.
#  - Otherwise, still eligible if it carries 'default' and its own
#    group's default won (see compute_default_wins) - checked
#    separately from enabled_tags, not via flat tag-string membership,
#    since a step whose *only* tag is 'default' (nothing else to
#    propagate to compute_enabled_tags at all) still needs to remain
#    eligible within its own group.
#  - exclude_tags overrides all of the above unconditionally - even an
#    enabled entry is dropped if any of its own tags is excluded.
def tag_eligible?(step, enabled_tags, default_wins, exclude_tags)
  tags = step[:tags]
  return true if tags.empty?
  return false if tags.any? { |t| exclude_tags.include?(t) }
  return true if tags.any? { |t| enabled_tags.include?(t) }

  tags.include?('default') && default_wins[step[:path]]
end

# select_by_tags(steps, select_tags, exclude_tags) - the subset of
#  `steps` this generation run actually wants, given --select/--exclude
#  (see tag_eligible?/issue #16). Three passes, each running to a
#  fixpoint before the next starts:
#   1. tag_eligible? alone picks the initial set - including any step
#      reached purely through tag propagation (compute_enabled_tags),
#      with no needs:/meets: link at all (e.g. an ancestor-level
#      bootstrap carrying the same tag a descendant leaf's own winning
#      default uses).
#   2. Transitive needs:/meets: pull-in, the same shape select_sections
#      already uses for --SECTION - a step this run already wants might
#      need: something whose own tags *still* don't make it eligible
#      even after tag propagation (a genuine cross-branch dependency,
#      not an alternative-selection relationship at all - e.g. groovy's
#      own needs: java, met by a completely different lesson area) -
#      "any dependency required to implement it will be installed"
#      is the whole point of this pass, not an afterthought. A provider
#      exclude_tags itself vetoes is skipped here on purpose - an
#      explicit --exclude has to actually remove that alternative, not
#      have some other step's needs: silently reinstate it.
#   3. Omission - after the pull-in settles, a step whose own needs:
#      still resolves to no provider *at all* in the final set (not
#      "wasn't selected this run" but genuinely unsatisfiable - nothing
#      in the whole file meets: it, or the one that did was vetoed by
#      exclude_tags) can't actually run correctly, so it - and,
#      transitively, anything that itself needs: *that* step - is
#      dropped rather than emitted as a command guaranteed to fail on
#      the box (see generate_install_script.rb's own omission
#      comments). Repeats to a fixpoint since dropping one step can
#      cascade into dropping whatever depended on it.
#  Returns [included, omitted] - included preserves steps' own original
#  relative order (same reasoning as select_sections' own final pass);
#  omitted is [[step, missing_need], ...] for write_install_script to
#  surface as header comments.
def select_by_tags(steps, select_tags, exclude_tags)
  default_wins = compute_default_wins(steps, select_tags)
  enabled_tags = compute_enabled_tags(steps, select_tags, default_wins)
  included = steps.select { |s| tag_eligible?(s, enabled_tags, default_wins, exclude_tags) }

  # One provider per unmet need, not every step that happens to share
  #  the same meets: value - confirmed directly this matters: with
  #  both rbenv and asdf tagged entries declaring `meets: ruby` (real
  #  alternatives for the very same thing), a naive "pull in every
  #  match" pass here installed *both* of them even with no --select
  #  at all, exactly the double-install issue #16 exists to prevent.
  #  `steps.find` (not `.select`) mirrors resolve!'s own "first listed
  #  provider wins" convention - same rule, same tie-break. Matches on
  #  need_name(need), never the raw needs: entry - a versioned entry
  #  like "ruby >= 3.2" (see parse_need) names the exact same
  #  capability as a plain "ruby" would, just with an added floor
  #  check_version_needs! verifies separately, later, against whichever
  #  provider this same by-name matching already picked. Letting a
  #  version floor change *which* provider gets pulled in here would
  #  make a manifest's actual installed set depend on floors, not on
  #  --select/tags/defaults the way every other resolution in this
  #  file already promises.
  loop do
    met = included.map { |s| meets_name(s) }.compact
    unmet = included.flat_map { |s| Array(s[:needs]).map { |n| need_name(n) } }.uniq - met
    break if unmet.empty?

    added = false
    unmet.each do |need|
      provider = steps.find do |s|
        meets_name(s) == need && !included.include?(s) && (s[:tags] & exclude_tags).empty?
      end
      next unless provider

      included << provider
      added = true
    end
    break unless added
  end

  omitted = []
  loop do
    met = included.map { |s| meets_name(s) }.compact
    unmet = included.find { |s| Array(s[:needs]).any? { |need| !met.include?(need_name(need)) } }
    break unless unmet

    missing = Array(unmet[:needs]).find { |need| !met.include?(need_name(need)) }
    omitted << [unmet, missing]
    included.delete(unmet)
  end

  [steps.select { |s| included.include?(s) }, omitted]
end

# parse_version_constraint(step) - step[:version] (e.g. ">= 2.8.5.201",
#  "1.16.7", or absent) split into [op, number] - op defaults to '=' when
#  none is written, matching how a bare version already reads ("install
#  exactly this"). Raises rather than silently misreading anything
#  outside VERSION_OPS - a manifest author writing `~>`/`^`/`<=` deserves
#  a loud failure at generation time, not a generator quietly treating it
#  as an exact pin or a floor it never actually asked for.
def parse_version_constraint(step)
  spec = step[:version]
  return [nil, nil] if spec.nil?

  # [~^<>=!]+ - any leading run of comparison-ish symbols, not just the
  #  two this actually supports - a stray '~>'/'^'/'<=' has to be
  #  captured as *some* op string so the VERSION_OPS check below can see
  #  and reject it, rather than falling through unmatched and silently
  #  becoming part of the version number itself with op defaulted to '='.
  m = spec.strip.match(/\A([~^<>=!]+)?\s*(.+)\z/)
  op = m[1] || '='
  unless VERSION_OPS.include?(op)
    raise "#{step[:type]} '#{step[:name]}': unsupported version operator '#{op}' in '#{spec}' (only #{VERSION_OPS.join('/')} implemented)"
  end

  [op, m[2]]
end

# parse_need(need) - a single needs: entry (e.g. "ruby >= 3.2" or a
#  bare "ruby") split into [capability_name, op, required_version] -
#  op/required nil when the entry carries no version constraint at
#  all, the overwhelmingly common case: "needs *a* provider of this,
#  whichever one resolution already picked, no floor on which one".
#  Every place a needs: entry gets matched against a meets: value
#  (select_by_tags, resolve!, select_sections) has to compare against
#  need_name(need), never the raw entry - a versioned entry like
#  "ruby >= 3.2" and a plain provider's own `meets: ruby` name the
#  same capability, and the whole point of keeping this separate from
#  that matching is that adding a floor never changes *which* provider
#  gets selected (see select_by_tags's own comment) - only whether
#  check_version_needs! later accepts the one that was.
def parse_need(need)
  m = need.strip.match(/\A(\S+)\s+([~^<>=!]+)\s*(.+)\z/)
  return [need.strip, nil, nil] unless m

  name, op, version = m[1], m[2], m[3]
  unless VERSION_OPS.include?(op)
    raise "needs '#{need}': unsupported version operator '#{op}' (only #{VERSION_OPS.join('/')} implemented)"
  end

  [name, op, version]
end

def need_name(need)
  parse_need(need)[0]
end

# parse_meets(step) - step[:meets] (e.g. "ruby 3.0", or a bare "java")
#  split into [capability_name, version] - version nil when the value
#  carries none, still the common case for anything nobody has ever
#  put a version floor on. Every place a meets: value is matched
#  against a capability name (select_by_tags, resolve!, select_sections,
#  relocate_cross_cutting, pull_in_cross_area_deps) has to compare
#  against meets_name(step), never the raw value - "ruby 3.0" and a
#  plain `needs: ruby` name the same capability; the version half only
#  matters to check_version_needs!'s own floor check. Space-split, not
#  parse_need's operator syntax - a provider only ever states what it
#  concretely *is* ("ruby 3.0"), never a floor/pin of its own.
def parse_meets(step)
  spec = step[:meets]
  return [nil, nil] if spec.nil?

  name, version = spec.split(' ', 2)
  [name, version]
end

def meets_name(step)
  parse_meets(step)[0]
end

# check_version_needs!(steps) - for every constrained needs: entry
#  (e.g. "ruby >= 3.2" - see parse_need) in the final, fully-resolved
#  `steps`, checks whether some step that meets the bare capability
#  name declares its own version (see parse_meets) satisfying the
#  constraint. Never raises - a manifest that can't satisfy one gem's
#  version floor is a real, expected outcome (e.g. a bare/default build
#  with no modern-ruby tag selected), not a bug in the generator, and a
#  hard crash mid-generation is worse than a script that installs
#  everything it *can* and clearly says what it skipped. Confirmed
#  directly this matters: gem: ratatui_ruby (needs a real Ruby >= 3.2)
#  silently passed every earlier resolution stage against the default
#  system: ruby (3.0.2) provider and only failed live, mid-VM-
#  provision, at the actual `gem install` - raising here instead just
#  moved *where* it crashed, not whether it did. Instead, an
#  unsatisfied consumer is converted in place into an 'omitted_version_
#  need' step (see generate_install_script.rb's own bash_install/
#  powershell_install case) - same position, same relative order, but
#  rendering as a runtime warning instead of a command guaranteed to
#  fail. Never a second selection mechanism either way - this only
#  ever removes a consumer that can't be satisfied, never swaps in a
#  *different* provider than the one tags/defaults already chose (see
#  the no-silent-environment-changes rule). Every step that meets
#  `name`, not just the first, is checked - an untagged, always-on
#  provider (e.g. system: ruby) and a tag-selected addition (rbenv/
#  asdf/rvm) can both legitimately be present in the same resolved
#  output at once (see tag_eligible?'s own 'issue #16' comment - these
#  are deliberately additive, not alternatives), so a version floor
#  only needs *one* of them to satisfy it. Call once, after select_
#  sections/dedup! have produced the actual final step list a generator
#  is about to emit - checking against an intermediate list could pass
#  or fail on a provider that won't even be in the output. Returns the
#  steps that got converted, for a caller to also report at generation
#  time (see warn_omissions-style reporting elsewhere).
def check_version_needs!(steps)
  converted = []

  steps.each do |consumer|
    Array(consumer[:needs]).each do |need|
      name, op, required = parse_need(need)
      next unless op

      providers = steps.select { |s| meets_name(s) == name }
      versioned = providers.select { |p| parse_meets(p)[1] }
      satisfied = versioned.any? do |p|
        _, actual = parse_meets(p)
        case op
        when '=' then Gem::Version.new(actual) == Gem::Version.new(required)
        when '>=' then Gem::Version.new(actual) >= Gem::Version.new(required)
        end
      end
      next if satisfied

      reason = if providers.empty?
                 "no step in the final resolved output meets '#{name}' at all"
               elsif versioned.empty?
                 found = providers.map { |p| "#{p[:type]} '#{p[:name]}'" }.join(', ')
                 "none of its providers (#{found}) declare a version of their own (e.g. `meets: #{name} 3.2`) to check against"
               else
                 found = versioned.map { |p| "#{p[:type]} '#{p[:name]}' (meets '#{p[:meets]}')" }.join(', ')
                 "none of its providers satisfy it - found: #{found}"
               end

      consumer[:omitted_reason] = "#{consumer[:type]} '#{consumer[:name]}': needs '#{need}', but #{reason}"
      consumer[:cmd] = nil
      consumer[:type] = 'omitted_version_need'
      converted << consumer
      break
    end
  end

  converted
end

# parse_condition(condition) - step[:condition] (e.g. "is_vm_guest ==
#  false") split into [fn_name, expected] - expected a real boolean, not
#  the string "false", so callers (render_step's own guard-wrapping)
#  never have to worry about Ruby's "false".nil? == false trap silently
#  treating an inverted condition as truthy. `fn_name` is the name of a
#  test *function*, not a variable - defined once (bash: exit-status
#  convention, 0/success == true; PowerShell: `return`s a real
#  [bool]) the same "define once, call at point of use" way append_line
#  is (see helpers/common.yml and emit_helper_functions's own `needed`
#  detection). Raises on anything that isn't exactly `name == true` or
#  `name == false` - same fail-loud reasoning as parse_version_
#  constraint's own unsupported-operator check: a manifest author
#  writing `is_vm_guest != true` or `is_vm_guest` alone (no comparison)
#  deserves a loud failure at generation time, not a generator quietly
#  guessing what they meant.
def parse_condition(condition)
  m = condition.strip.match(/\A(\w+)\s*==\s*(true|false)\z/)
  raise "unsupported condition '#{condition}' (expected '<function> == true' or '<function> == false')" unless m

  [m[1], m[2] == 'true']
end

# VARIABLE_REF - a `<%= $name %>` reference to the manifest's own
#  top-level variables: block (see RESERVED_KEYS) - substitute_
#  variables replaces every one of these, anywhere in the tree, with
#  that name's real value. `<%= %>` (not e.g. `{{ }}`) specifically
#  because it's a plain YAML scalar with no quoting required: `{` opens
#  a flow mapping in YAML, so an unquoted `{{ ruby_ver }}` parses as
#  nested hashes instead of the literal string a manifest author
#  actually meant - confirmed directly (`YAML.load("v: {{ ruby_ver
#  }}")` => `{"v"=>{{"ruby_ver"=>nil}=>nil}}`, not the string anyone
#  writing that line actually intended), which is exactly the state
#  windows.yml's own ruby version pin was silently sitting in before
#  this was implemented. `<%= $ruby_ver %>` needs no such quoting
#  (confirmed directly the same way - parses straight to a plain
#  String), and this repo's manifests don't otherwise contain a literal
#  `<%` that this would need to avoid colliding with. The `$` sigil
#  inside is purely conventional (echoing shell variable syntax for a
#  human reader) - substitution itself only cares about the `<%= ...
#  %>` wrapper.
VARIABLE_REF = /<%=\s*\$(\w+)\s*%>/.freeze

# substitute_variables(value, vars) - `value` (any YAML-parsed node:
#  String/Hash/Array/scalar) with every VARIABLE_REF in every String it
#  contains, at any depth, replaced by vars[name] - returns a new
#  structure rather than mutating in place (simplest given Hash/Array
#  don't share one uniform in-place update method across both types).
#  Called on the *whole* parsed tree, not just one platform's own
#  subtree (`tree[name]`) - even though `vars` itself always comes from
#  just that one platform's own `variables:` block (see RESERVED_KEYS'
#  own comment on why variables: is scoped per-platform). Confirmed
#  directly this has to be the whole tree, not tree[name] alone:
#  scripts:/files:/appends: are themselves top-level RESERVED_KEYS
#  blocks, siblings of tree[name] rather than nested inside it, so a
#  <%= $name %> reference in a script body (e.g. ubuntu22_asdf's own
#  `ASDF_VERSION="<%= $asdf_ver %>"`) sat there completely unsubstituted
#  - verbatim template text, in every generated output - for as long as
#  every entry point here only ever substituted tree[name]. Every field
#  flatten reads out of that platform's tree (name:, version:, cmd:, an
#  appends:/files: block's own lines:/content:, ...) has its real value
#  by the time flatten sees it either way, without flatten or any
#  downstream consumer needing to know templating exists at all.
#  Raises on a name vars doesn't have, rather than leaving the literal
#  `<%= $name %>` text in the generated script - same fail-loud
#  reasoning as parse_version_constraint's own unsupported-operator
#  check: a typo'd variable name deserves a loud failure at generation
#  time, not a generator that silently writes literal template syntax
#  into someone's .bashrc. vars[name].to_s - a variable can be authored
#  as a bare YAML scalar (`ruby_ver: 3.4.10.1`, itself already a String
#  since it has more than one dot; but `retries: 3` would parse as an
#  Integer) - always coerced to a String on substitution since it's
#  being spliced into one.
def substitute_variables(value, vars)
  case value
  when String
    value.gsub(VARIABLE_REF) do
      name = Regexp.last_match(1)
      raise "unknown variable '#{name}' referenced as '<%= $#{name} %>' - not defined in this manifest's own variables: block" unless vars.key?(name)

      vars[name].to_s
    end
  when Hash
    value.transform_values { |v| substitute_variables(v, vars) }
  when Array
    value.map { |v| substitute_variables(v, vars) }
  else
    value
  end
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

# resolve! - for every step with `needs: X` (X may be a single name or
#  a list - e.g. groovy's own `needs: [java, sdkman]`, needing both the
#  JDK *and* the SDKMAN bootstrap before it can run), finds the first
#  step with `meets: X` for each one (first listed provider wins) and,
#  if that provider currently sits after the consumer, moves its whole
#  unit to just before it. Leaves order untouched when the provider
#  already comes first. Handles multiple needs the same one-move-then-
#  restart-the-whole-scan way it already handled a single one - moving
#  any one provider can shift indices out from under the rest of this
#  pass, so the outer loop simply runs again from scratch until nothing
#  moves, converging on every need for every consumer regardless of how
#  many there are.
def resolve!(steps)
  loop do
    moved = false

    steps.each_with_index do |consumer, c_index|
      next unless consumer[:needs]

      Array(consumer[:needs]).each do |need|
        p_index = steps.index { |s| meets_name(s) == need_name(need) }
        next unless p_index
        next if p_index < c_index

        start, finish = unit_span(steps, p_index)
        unit = steps.slice!(start, finish - start + 1)
        insert_at = steps.index(consumer)
        steps.insert(insert_at, *unit)
        moved = true
        break
      end
      break if moved
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
FUNCTION_SECTIONS = %w[global lessons cibox scriptbox testbox pkgbox gen_scripts shell_scripts compiled_lang win_scripts].freeze

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

# natural_prefix(provider, natural_steps) - provider's own direct local
#  siblings that precede it in the *original*, pre-resolve! document
#  order (see natural_function_order), up to the previous owning-
#  function boundary - a provider's real implicit local prerequisites
#  even when they carry no needs:/meets: of their own at all (e.g.
#  compiled_lang's own `apt: curl`, sitting before `apt: build-essential
#  meets: make` with nothing connecting the two). Only f's own direct
#  packages (path ends exactly at f) count - a sibling subsection that
#  merely inlines into the same function (e.g. compiled_lang.cs,
#  sitting between compiled_lang's own curl/build-essential and
#  compiled_lang.java in document order) is not one, and pulling it in
#  anyway would relocate/select an unrelated install (here, .NET SDK)
#  for no reason. Returned in natural order (furthest-back first) -
#  shared by relocate_cross_cutting (call-tree restructuring) and
#  select_sections (SECTION-filtered generation), which both need the
#  same answer to "what does this provider's own natural position
#  already imply comes before it, unstated."
def natural_prefix(provider, natural_steps)
  f = owning_function(provider)
  n_idx = natural_steps.index(provider)
  prefix = []
  i = n_idx - 1
  while i >= 0 && owning_function(natural_steps[i]) == f
    sibling = natural_steps[i]
    i -= 1
    next unless sibling[:path].split('.').last == f

    prefix.unshift(sibling)
  end
  prefix
end

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

    # natural_prefix's own candidates, walked closest-to-provider first
    #  (reverse_each) so an already-claimed one stops the walk right
    #  there - nothing further back is unclaimed either, once something
    #  nearer the provider has already been pulled in by an earlier
    #  relocation.
    prefix = []
    natural_prefix(provider, natural_steps).reverse_each do |sibling|
      r_idx = steps.index(sibling)
      # A section-filtered `steps` (see generate_install_script.rb's own
      #  select_sections) may not include this natural-order sibling at
      #  all - skip it and keep looking further back rather than
      #  stopping the whole walk on a step that isn't even part of this
      #  run.
      next if r_idx.nil?
      break if claimed[r_idx]

      prefix.unshift(sibling)
      claimed[r_idx] = true
    end

    group_steps = prefix + unit
    name = "provider_#{meets_name(provider)}"
    group_for[provider.object_id] = name
    groups << { name: name, steps: group_steps }

    # A step within this pulled-along group might itself `need:`
    #  something that also requires relocation - resolve recursively,
    #  inserting immediately before *that* step wherever it lands.
    #  Array(...) - a need: can be a list (see resolve!'s own comment);
    #  each one is resolved independently, so a step needing two things
    #  that both require relocation gets both inserted before it.
    group_steps.each do |s|
      next unless s[:needs]

      Array(s[:needs]).each do |need|
        dep = steps.find { |x| meets_name(x) == need_name(need) }
        next unless dep && needs_relocation?(dep, s, natural_order)

        dep_name = relocate.call(dep)
        insert_before[s.object_id] << dep_name unless insert_before[s.object_id].include?(dep_name)
      end
    end

    name
  end

  steps.each do |consumer|
    next unless consumer[:needs]

    Array(consumer[:needs]).each do |need|
      provider = steps.find { |s| meets_name(s) == need_name(need) }
      next unless provider && needs_relocation?(provider, consumer, natural_order)

      group_name = relocate.call(provider)
      insert_before[consumer.object_id] << group_name unless insert_before[consumer.object_id].include?(group_name)
    end
  end

  [groups, claimed, insert_before]
end

if __FILE__ == $PROGRAM_NAME
  tree = YAML.load_file(File.join(__dir__, '..', 'config', 'macos.yml'))
  # Whole tree, not just tree['macos'] - see generate_chef_databag.rb's
  #  own comment on why (scripts:/files:/appends: are top-level
  #  RESERVED_KEYS blocks, not nested inside tree['macos']).
  tree = substitute_variables(tree, tree['macos']['variables'] || {})
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
