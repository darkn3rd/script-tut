#!/usr/bin/env ruby
require 'yaml'
require 'json'
require 'fileutils'
require 'optparse'
require_relative 'resolve_order'
require_relative 'generate_chef_databag' # for step_to_entry/consolidate_apt/root_key/LESSON_AREAS/COMMON_AREA
require_relative 'generate_ansible_vars' # for deep_stringify_keys
require_relative 'cmpaths' # for cmpath - out_path's own default when omitted

# generate_cfengine.rb - same source of truth (scriptbox/config/*.yml),
#  same resolved lessons step list as generate_chef_databag.rb and
#  generate_ansible_vars.rb, just serialized as a CFEngine **augments**
#  file - a def.json sitting next to a promises.cf, auto-merged by
#  cf-agent into a data variable (def.<key>) with no bundle-side lookup
#  code required at all. --tree names exactly one output path per
#  invocation, but the augments shape itself never differs between the
#  two - the difference between ../../configbox/cfengine/standalone and
#  ../../configbox/cfengine/hub is entirely about how the resulting
#  def.json *reaches* cf-agent (read directly vs. distributed through a
#  self-hosted policy hub), never the data itself.
TREES = %w[standalone hub].freeze

# lessons_shape(lessons_data) - the one nested shape both writers use, so
#  the two trees never drift into two different data shapes for what is
#  otherwise the same tree. gates.<area> is a plain on/off switch (all
#  default true here - a real per-node override would set one to false);
#  areas.<area>.steps is that area's own step list. appends is a flat
#  {dest => [lines...]} map, built by extract_appends! below - install_
#  step.cf's own shared dispatcher bundle only gets called once per real
#  destination file this way (see extract_appends!'s own comment for why
#  that's load-bearing, not just tidier).
def lessons_shape(lessons_data)
  {
    'user' => 'vagrant',
    'common_steps' => lessons_data[COMMON_AREA],
    'gates' => LESSON_AREAS.to_h { |area| [area, true] },
    'areas' => LESSON_AREAS.to_h { |area| [area, { 'steps' => lessons_data[area] }] },
    'appends' => extract_appends!(lessons_data),
  }
end

# extract_appends!(lessons_data) - pulls every 'append'-typed step out of
#  every area (and common_steps) in place, merging its lines into a flat
#  {dest => [lines...]} map keyed by destination path (deduped/merged
#  across areas - e.g. a dest two different steps both target ends up
#  with both steps' own lines, in encounter order). Confirmed directly
#  this has to happen here, not per-step inside install_step.cf: CFEngine
#  treats a promise's identity as (bundle, source line, expanded
#  promiser) - calling the *same* shared dispatcher bundle once per
#  append step, each time promising the *same* destination path (e.g.
#  two different steps both appending to .bashrc), only actually applies
#  the *first* call's own edit_line content; every later call against
#  that same already-resolved path is silently skipped, no error. One
#  promise per real destination file - each with the *complete* merged
#  line list - sidesteps that entirely.
def extract_appends!(lessons_data)
  appends = {}
  lessons_data.each_value do |steps|
    steps.reject! do |step|
      next false unless step['type'] == 'append'

      # $HOME resolved here, eagerly, rather than deferred to a runtime
      #  string_replace the way is_file/is_append used to - lessons_
      #  shape's own 'user' is already hardcoded 'vagrant' above, so the
      #  real path is already known now; this also keeps the map's own
      #  keys plain absolute paths, not something CFEngine would need to
      #  re-parse a literal '$HOME' out of when using them as a lookup
      #  key.
      Array(step['dest']).each do |d|
        real_dest = d.sub('$HOME', '/home/vagrant')
        (appends[real_dest] ||= []).concat(Array(step['lines']))
      end
      true
    end
  end
  appends
end

# normalize_for_cfengine!(lessons_data) - forces `name` (apt/sysctl) to
#  always be an array, even a single-element one - every other
#  generator's own step_to_entry/consolidate_apt leaves a single-name
#  apt entry (one with its own apt_repository/add_apt_repo, specifically
#  excluded from consolidate_apt's own multi-name merge) as a bare
#  string, since Puppet/Salt/Chef/Ansible each already handle the
#  scalar-or-list distinction in their own step dispatcher. CFEngine's
#  own dispatcher (install_step.cf) iterates with getindices() either
#  way, so guaranteeing a list here - once, for this generator's own
#  output only - means it never needs a separate scalar branch at all.
def normalize_for_cfengine!(lessons_data)
  lessons_data.values.flatten.each do |step|
    step['name'] = Array(step['name']) if %w[apt sysctl].include?(step['type'])
  end
end

# write_augments(lessons_data, out_path) - the augments document shape
#  cf-agent actually expects: {"vars": {"<name>": <value>}} - a flat map,
#  where <name> becomes a variable in the *implicit* `def` bundle in the
#  `default` namespace (confirmed directly against CFEngine's own
#  Augments reference doc - an earlier version of this nested a "def"
#  key of its own one level too deep, producing an actual variable
#  literally *named* "def" instead of populating the def bundle at all,
#  which cf-promises accepted silently and cf-agent then had nothing
#  under def.lessons to read at run time). Written as vars.lessons so
#  every bundle in shared_policy/lessons reads it back as the data
#  container def.lessons, regardless of which tree's promises.cf
#  actually invoked cf-agent.
def write_augments(lessons_data, out_path)
  doc = { 'vars' => { 'lessons' => lessons_shape(lessons_data) } }
  FileUtils.mkdir_p(File.dirname(out_path))
  # mode: 'wb' - see ./generate_puppet.rb's own comment: on a native-
  #  Windows Ruby (RUBY_PLATFORM x64-mingw-ucrt), text-mode File.write
  #  silently corrupts multi-line step 'cmd'/'content' bodies with \r\n.
  #  Binary mode keeps \n literal regardless of host OS.
  File.write(out_path, "#{JSON.pretty_generate(doc)}\n", mode: 'wb')
end

# parse_cfengine_args(argv) - <config.yml> [out_path] --tree
#  standalone|hub [--select TAG,TAG] [--exclude TAG,TAG]. --select/
#  --exclude match generate_databag_args's own semantics exactly (see its
#  own comment) - only --tree is new here. out_path is optional - see
#  cmpaths.rb's own comment for what it defaults to.
def parse_cfengine_args(argv)
  options = { select: [], exclude: [], tree: nil }
  OptionParser.new do |opts|
    opts.on('--select TAGS') { |v| options[:select] = v.split(',').map(&:strip) }
    opts.on('--exclude TAGS') { |v| options[:exclude] = v.split(',').map(&:strip) }
    opts.on('--tree TREE') { |v| options[:tree] = v }
  end.parse!(argv)
  [argv[0], argv[1], options]
end

if __FILE__ == $PROGRAM_NAME
  config_path, out_path, options = parse_cfengine_args(ARGV)
  if config_path.nil? || config_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> [out_path] --tree standalone|hub [--select TAG,TAG] [--exclude TAG,TAG]"
    exit 1
  end
  unless TREES.include?(options[:tree])
    warn "#{$PROGRAM_NAME}: --tree must be one of #{TREES.join('/')}, got '#{options[:tree]}'"
    exit 1
  end

  tree = YAML.load_file(config_path)
  name = root_key(tree)
  out_path ||= cmpath('cfengine', options[:tree], name)
  tree = substitute_variables(tree, tree[name]['variables'] || {})

  all_steps = flatten(tree[name])
  all_steps, omitted = resolve_included(all_steps, options[:select], options[:exclude])
  warn_omissions(omitted)
  topological_order(all_steps)
  version_omitted = check_version_needs!(all_steps)
  version_omitted.each { |s| warn "#{$PROGRAM_NAME}: #{s[:omitted_reason]}" }

  lessons_steps = all_steps.select { |s| (['lessons'] + LESSON_AREAS).include?(owning_function(s)) }
  lessons_steps = pull_in_cross_area_deps(lessons_steps, all_steps)
  lessons_steps = lessons_steps.reject { |s| %w[system omitted_version_need].include?(s[:type]) }
  dedup!(lessons_steps)

  lessons_data = {}
  lessons_data[COMMON_AREA] = consolidate_apt(lessons_steps.reject { |s| LESSON_AREAS.include?(owning_function(s)) }.map { |s| step_to_entry(s, tree) })
  LESSON_AREAS.each do |area|
    entries = lessons_steps.select { |s| owning_function(s) == area }.map { |s| step_to_entry(s, tree) }
    lessons_data[area] = consolidate_apt(entries)
  end
  lessons_data = deep_stringify_keys(lessons_data)
  normalize_for_cfengine!(lessons_data)

  write_augments(lessons_data, out_path)
  puts "wrote #{out_path} (--tree #{options[:tree]})"
end
