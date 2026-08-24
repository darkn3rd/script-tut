#!/usr/bin/env ruby
require 'yaml'
require 'json'
require 'fileutils'
require 'optparse'
require_relative 'resolve_order'

# LESSON_AREAS - the four owning_function values this data bag actually
#  covers (see resolve_order.rb's FUNCTION_SECTIONS) - deliberately a
#  subset, not the whole tree: the `lessons` Chef cookbook only consumes
#  lessons' own four children, not global/cibox/scriptbox/testbox.
LESSON_AREAS = %w[gen_scripts shell_scripts compiled_lang win_scripts].freeze

# COMMON_AREA - JSON key for steps whose owning_function is 'lessons'
#  itself (see resolve_order.rb's FUNCTION_SECTIONS) rather than one of
#  LESSON_AREAS's own four children - e.g. the sdkman bootstrap, which
#  lives directly on lessons.packages as shared setup a specific area
#  (gen_scripts's own `sdkman: groovy`) depends on, not nested under any
#  one area. Confirmed via a real `vagrant provision` run: without this,
#  such steps were silently dropped from the data bag entirely - the
#  original select filter only ever kept the four named areas.
COMMON_AREA = 'common'

# strip_comments(cmd) - `cmd`'s own whole-line bash comments and blank
#  lines removed, heredoc-aware: a line inside a heredoc body (e.g.
#  ubuntu_default_zshrc's own `cat <<'EOF' > $HOME/.zshrc` payload) is
#  literal file content, not bash - a '#' there is a real zsh comment
#  *in the file being written*, not something to strip, so it and every
#  other line up to the terminator pass through completely untouched.
#  Same heredoc-tracking approach as generate_install_script.rb's own
#  indent_body, for the same underlying reason: naive line-by-line
#  text transforms are only safe once you know whether a given line is
#  actually bash or just data a heredoc is writing out.
def strip_comments(cmd)
  heredoc_terminator = nil
  cmd.each_line.filter_map do |line|
    if heredoc_terminator
      heredoc_terminator = nil if line.chomp == heredoc_terminator
      line
    elsif (m = line.match(/<<-?\s*(['"]?)(\w+)\1/))
      heredoc_terminator = m[2]
      line
    elsif line.strip.empty? || line.strip.start_with?('#')
      nil
    else
      line
    end
  end.join
end

# step_to_entry(step, tree) - one step as a plain JSON-ready hash.
#  `cmd` is only ever present for a 'script' step, and it's the *actual
#  script body* pulled from the manifest's own scripts: block - not just
#  the name - so the data bag is fully self-contained: a Chef recipe
#  consuming it never has to also read the YAML manifest to know what a
#  script step actually runs. Comments are stripped - they're for a
#  human reading the manifest source, not for JSON meant to be consumed
#  by a recipe. Same idea for 'file'/'append' steps - their dest/
#  content/lines come straight from the manifest's own files:/appends:
#  blocks (see resolve_order.rb's ATTACHABLE_KEYS), not reverse-engineered
#  from a script body the way an earlier version of this generator tried
#  and the user rejected as unmaintainable. 'apt_repository' passes
#  through as-is when the manifest's own apt entry declared one.
#  'add_apt_repo' - like 'file'/'append', a *name* into the manifest's
#  own add_apt_repos: block - resolved here to the full entry (name/
#  key_url/repo_uri/distro_string), same self-contained-data-bag
#  reasoning as everything else in this function.
def step_to_entry(step, tree)
  entry = { type: step[:type], name: step[:name] }
  entry[:cmd] = strip_comments(step[:cmd]) if step[:cmd]
  entry[:apt_repository] = step[:apt_repository] if step[:apt_repository]
  entry[:add_apt_repo] = (tree['add_apt_repos'] || {})[step[:add_apt_repo]] if step[:add_apt_repo]
  # parse_version_constraint validates, but its own [op, number] split is
  #  discarded here - the raw string is what's stored, since a data bag
  #  consumer (Chef's own helpers.rb, Ansible's own install_step.yml)
  #  does its own lightweight strip, the same way generate_install_
  #  script.rb's bash_install/powershell_install do. Validating here too
  #  (not just there) matters because those two data-bag consumers never
  #  go through generate_install_script.rb's own dispatch at all - this
  #  is the one place a bad operator would otherwise reach them silently.
  parse_version_constraint(step) if step[:version]
  entry[:version] = step[:version] if step[:version]
  entry[:args] = step[:args] if step[:args]

  case step[:type]
  when 'script'
    entry[:cmd] = strip_comments((tree['scripts'] || {}).dig(step[:name], 'cmd'))
  when 'file'
    file = (tree['files'] || {})[step[:name]]
    entry[:dest] = file['dest']
    entry[:content] = file['content']
  when 'append'
    append = (tree['appends'] || {})[step[:name]]
    entry[:dest] = append['dest']
    entry[:lines] = append['lines']
  end

  entry
end

# consolidate_apt(entries) - every 'apt' entry in this one area merged
#  into a single entry up front, name: a flat array of every package
#  (some individual entries are already an array - e.g. gen_scripts' own
#  dev-toolchain list - others a single string; Array() normalizes both
#  before flattening). Safe regardless of where in the area's original
#  order these came from: plain apt packages have no install-order
#  dependency on each other. An apt entry that carries its own
#  apt_repository (e.g. dotnet-sdk-10.0/golang-go, each needing its own
#  PPA added first) is left out of the merge entirely - the lessons
#  cookbook's own generic 'apt' case needs that entry's apt_repository
#  attached to *that* package, not lost inside an anonymous merged list.
#  Same reasoning for add_apt_repo (the non-PPA, raw-key way to add a
#  repo - see step_to_entry) - also excluded from the merge.
#  One apt_package resource per area instead of one per plain package.
def consolidate_apt(entries)
  plain, rest = entries.partition { |e| e[:type] == 'apt' && !e[:apt_repository] && !e[:add_apt_repo] }
  apt_names = plain.flat_map { |e| Array(e[:name]) }
  return rest if apt_names.empty?

  [{ type: 'apt', name: apt_names }] + rest
end

# root_key - same as generate_install_script.rb's own (not shared via
#  require, to avoid pulling in that file's unrelated bash/PowerShell
#  generation code for the sake of one small helper).
def root_key(tree)
  candidates = tree.keys - RESERVED_KEYS
  if candidates.size != 1
    warn "#{$PROGRAM_NAME}: expected exactly one top-level key besides #{RESERVED_KEYS.join('/')}, found: #{candidates.join(', ')}"
    exit 1
  end
  candidates.first
end

# parse_databag_args(argv) - <config.yml> <out.json/yml> [--select
#  TAG,TAG] [--exclude TAG,TAG], shared by all three data-bag/vars
#  generators (this file's own lessons bag, generate_scriptbox_
#  databag.rb, generate_ansible_vars.rb) so their --select/--exclude
#  semantics can never drift from generate_install_script.rb's own (see
#  resolve_order.rb's own tag_eligible?/select_by_tags, issue #16) -
#  without this, a manifest using rbenv/pyenv/asdf-style alternatives
#  would have every alternative installed by the generated shell
#  script (which does filter) while the Chef/Ansible side still saw -
#  and emitted resources for - all of them at once.
def parse_databag_args(argv)
  options = { select: [], exclude: [] }
  OptionParser.new do |opts|
    opts.on('--select TAGS') { |v| options[:select] = v.split(',').map(&:strip) }
    opts.on('--exclude TAGS') { |v| options[:exclude] = v.split(',').map(&:strip) }
  end.parse!(argv)
  [argv[0], argv[1], options[:select], options[:exclude]]
end

# warn_omissions(omitted) - one stderr line per step select_by_tags
#  dropped for lacking any eligible provider (see its own comment) -
#  these generators have no header-comment mechanism the way a
#  generated shell script does (see generate_install_script.rb's own
#  write_install_script), so a warning is the only way this wouldn't
#  otherwise be silently invisible in the JSON/YAML output.
def warn_omissions(omitted)
  omitted.each do |step, missing|
    warn "#{$PROGRAM_NAME}: omitted [#{step[:path]}] #{step[:type]}: #{step[:name]} - needs '#{missing}', no eligible provider (check --select/--exclude, or the manifest's own default tags)"
  end
end

# pull_in_cross_area_deps(area_steps, all_steps) - `area_steps` (already
#  filtered down to whichever areas this generator's own JSON covers -
#  lessons's four, or scriptbox's one) plus (transitively) any step
#  elsewhere in the *whole* manifest that a step already in `area_steps`
#  needs: - the exact same shape select_sections (generate_install_
#  script.rb) already uses for --SECTION, just seeded by area instead of
#  by path selector. Exists because a bootstrap tool isn't necessarily
#  scoped to any one area at all - e.g. asdf, whose own bootstrap step
#  sits directly on `global.packages` (not nested under `lessons:`)
#  specifically *because* its plugins span every area a manifest might
#  ever have (ruby/python/groovy today under lessons, hashicorp tools
#  like vagrant/packer under some future buildbox) - so an area filter
#  that only ever keeps steps whose *own* path already lives inside
#  that area would silently drop the bootstrap the moment anything in
#  the area needs: it, exactly the way lessons's own asdf_plugin/asdf
#  steps did before this existed (confirmed directly: `ubuntu22_asdf`
#  never appeared anywhere in a real generated lessons data bag,
#  despite gen_scripts.ruby/python3/groovy's own asdf steps needing it).
#  Also pulls in each newly-added provider's own attached file:/append:
#  siblings (matched by attached_to, the same grouping resolve_order.rb's
#  own unit_span uses for the bash generator) - a provider without them
#  would run its bootstrap but never get its PATH/completions written.
def pull_in_cross_area_deps(area_steps, all_steps)
  loop do
    names = area_steps.map { |s| s[:name] }
    needed = area_steps.flat_map { |s| Array(s[:needs]).map { |n| need_name(n) } }.uniq
    additions = all_steps.reject { |s| area_steps.include?(s) }
                          .select { |s| needed.include?(meets_name(s)) || names.include?(s[:attached_to]) }
    break if additions.empty?

    area_steps += additions
  end
  area_steps
end

if __FILE__ == $PROGRAM_NAME
  config_path, out_path, select_tags, exclude_tags = parse_databag_args(ARGV)
  if config_path.nil? || config_path.empty? || out_path.nil? || out_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> <out.json> [--select TAG,TAG] [--exclude TAG,TAG]"
    exit 1
  end

  tree = YAML.load_file(config_path)
  name = root_key(tree)
  # Whole tree, not just tree[name] - scripts:/files:/appends: are
  #  themselves top-level RESERVED_KEYS blocks, siblings of tree[name],
  #  not nested inside it, so a <%= $name %> reference in a script body
  #  (e.g. ubuntu22_asdf's own ASDF_VERSION) would otherwise sit there
  #  unsubstituted (confirmed directly - see generate_install_script.rb's
  #  own comment on this same fix). Values still come from just this
  #  platform's own variables: block.
  tree = substitute_variables(tree, tree[name]['variables'] || {})

  steps = flatten(tree[name])
  steps, omitted = select_by_tags(steps, select_tags, exclude_tags)
  warn_omissions(omitted)
  resolve!(steps)
  all_steps = steps
  # Validated against the whole resolved tree before any area/type
  #  filtering below - a provider later stripped out as type == 'system'
  #  (or scoped out of lessons: entirely) is still the real, resolved
  #  install decision; checking after either filter would see "no
  #  provider" and raise a false positive.
  version_omitted = check_version_needs!(all_steps)
  version_omitted.each { |s| warn "#{$PROGRAM_NAME}: #{s[:omitted_reason]}" }
  steps = steps.select { |s| (['lessons'] + LESSON_AREAS).include?(owning_function(s)) }
  # A step lessons's own areas need: isn't necessarily scoped to
  #  lessons at all - see pull_in_cross_area_deps's own comment (asdf's
  #  bootstrap sits on global.packages, not lessons:, on purpose).
  steps = pull_in_cross_area_deps(steps, all_steps)
  # 'system' means "expected to already be provided by the OS" - no
  #  resource, no command, nothing for a recipe to actually consume, so
  #  it's dead weight in the data bag rather than useful documentation.
  #  'omitted_version_need' (see check_version_needs!) is the same idea -
  #  nothing a recipe could actually run, already warned about above.
  steps = steps.reject { |s| %w[system omitted_version_need].include?(s[:type]) }
  dedup!(steps)

  data = { 'id' => name }
  # Not just owning_function(s) == 'lessons' - a step pulled in from
  #  outside lessons: entirely (see pull_in_cross_area_deps) isn't
  #  'lessons' either, but still belongs in the shared, ungated common
  #  area alongside sdkman's own bootstrap, not nowhere.
  data[COMMON_AREA] = consolidate_apt(steps.reject { |s| LESSON_AREAS.include?(owning_function(s)) }.map { |s| step_to_entry(s, tree) })
  LESSON_AREAS.each do |area|
    entries = steps.select { |s| owning_function(s) == area }.map { |s| step_to_entry(s, tree) }
    data[area] = consolidate_apt(entries)
  end

  FileUtils.mkdir_p(File.dirname(out_path))
  File.write(out_path, JSON.pretty_generate(data))
  puts "wrote #{out_path}"
end
