#!/usr/bin/env ruby
require 'yaml'
require 'json'
require 'fileutils'
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

if __FILE__ == $PROGRAM_NAME
  config_path = ARGV[0]
  if config_path.nil? || config_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> <out.json>"
    exit 1
  end
  out_path = ARGV[1]
  if out_path.nil? || out_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> <out.json>"
    exit 1
  end

  tree = YAML.load_file(config_path)
  name = root_key(tree)

  steps = flatten(tree[name])
  resolve!(steps)
  steps = steps.select { |s| (['lessons'] + LESSON_AREAS).include?(owning_function(s)) }
  # 'system' means "expected to already be provided by the OS" - no
  #  resource, no command, nothing for a recipe to actually consume, so
  #  it's dead weight in the data bag rather than useful documentation.
  steps = steps.reject { |s| s[:type] == 'system' }
  dedup!(steps)

  data = { 'id' => name }
  data[COMMON_AREA] = consolidate_apt(steps.select { |s| owning_function(s) == 'lessons' }.map { |s| step_to_entry(s, tree) })
  LESSON_AREAS.each do |area|
    entries = steps.select { |s| owning_function(s) == area }.map { |s| step_to_entry(s, tree) }
    data[area] = consolidate_apt(entries)
  end

  FileUtils.mkdir_p(File.dirname(out_path))
  File.write(out_path, JSON.pretty_generate(data))
  puts "wrote #{out_path}"
end
