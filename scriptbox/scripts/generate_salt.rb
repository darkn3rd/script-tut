#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require 'optparse'
require 'base64'
require_relative 'resolve_order'
require_relative 'generate_chef_databag' # for step_to_entry/consolidate_apt/root_key/LESSON_AREAS/COMMON_AREA
require_relative 'generate_ansible_vars' # for deep_stringify_keys
require_relative 'cmpaths' # for cmpath - out_path's own default when omitted

# generate_salt.rb - same source of truth (scriptbox/config/*.yml), same
#  resolved lessons step list as generate_chef_databag.rb and
#  generate_ansible_vars.rb, just serialized for whichever of two ways
#  the shared_states/lessons tree can receive its data - --tree names
#  exactly one output shape per invocation:
#
#  - masterless: a pillar SLS file (../../configbox/salt/masterless/
#    roots/pillar/lessons/<platform>.sls) - looked up the ordinary way
#    by a minion applying against its own local file_roots/pillar_roots.
#    Data and states stay separate the whole way through.
#  - roster: a roster file (../../configbox/salt/roster/roster.yaml)
#    with every value embedded directly under one host entry's own
#    minion_opts.grains - everything a run needs sitting in one
#    generated file, no external lookup at apply time.
TREES = %w[masterless roster].freeze

# lessons_shape(lessons_data) - the one nested shape both writers use,
#  so the two trees never drift into two different data shapes for
#  what is otherwise the same tree. gates.<area> is a plain on/off
#  switch (all default true here - a real per-node override would set
#  one to false); areas.<area>.steps is that area's own step list.
def lessons_shape(lessons_data)
  {
    'user' => 'vagrant',
    'common_steps' => lessons_data[COMMON_AREA],
    'gates' => LESSON_AREAS.to_h { |area| [area, true] },
    'areas' => LESSON_AREAS.to_h { |area| [area, { 'steps' => lessons_data[area] }] },
  }
end

# extract_formula_pillars(lessons_data) - every salt_formula step's own
#  formula_pillar hash, hoisted to the top level (a sibling of
#  `lessons:`, not nested under it) - a vendored formula's own map.jinja
#  looks up its pillar/grain key at that top level (e.g. `golang:`),
#  not `lessons:golang:`, since it has no idea this tree's own lessons:
#  key exists at all. Deletes formula_pillar off each step in the
#  process (mutates in place - lessons_shape's own step entries are the
#  same objects, not copies, so this cleans those up too) - once
#  hoisted, it's dead weight nothing ever reads back out of the step
#  list itself.
def extract_formula_pillars(lessons_data)
  lessons_data.values.flatten.each_with_object({}) do |step, merged|
    next unless step['type'] == 'salt_formula'

    pillar = step.delete('formula_pillar')
    merged.merge!(pillar) if pillar
  end
end

# write_masterless(lessons_data, out_path) - see TREES's own
#  'masterless' entry.
def write_masterless(lessons_data, out_path)
  doc = { 'lessons' => lessons_shape(lessons_data) }.merge(extract_formula_pillars(lessons_data))
  FileUtils.mkdir_p(File.dirname(out_path))
  # mode: 'wb' - see ./generate_puppet.rb's own comment: on a native-
  #  Windows Ruby (RUBY_PLATFORM x64-mingw-ucrt), text-mode File.write
  #  silently corrupts multi-line step 'cmd'/'content' bodies with
  #  \r\n. Binary mode keeps \n literal regardless of host OS.
  File.write(out_path, "---\n#{doc.to_yaml.sub(/\A---\n/, '')}", mode: 'wb')
end

# write_roster(name, lessons_data, out_path) - see TREES's own 'roster'
#  entry. Connection info is fixed, not looked up per run: this tree's
#  own apply step runs salt-ssh from *inside* the guest, targeting
#  itself over a keypair it generates for its own use (see
#  ../../configbox/salt/scripts/ubuntu22_salt_ssh_bootstrap.sh) - so
#  127.0.0.1/22/vagrant/that key's own conventional path are always
#  correct, never something this generator needs to discover.
def write_roster(name, lessons_data, out_path)
  doc = {
    name => {
      'host' => '127.0.0.1',
      'port' => 22,
      'user' => 'vagrant',
      'priv' => '/home/vagrant/.ssh/salt_ssh_id',
      # sudo: true - confirmed directly this is load-bearing, not
      #  belt-and-suspenders: even in --local mode, the thin salt-call
      #  this connects to still writes fileserver/pillar cache under
      #  /var/cache/salt/minion/, which is root-owned - connecting as
      #  a plain unprivileged user fails there with a bare
      #  PermissionError, no matter how correct everything else is.
      'sudo' => true,
      'minion_opts' => {
        # lessons_b64, not a plain lessons: grain - confirmed directly:
        #  salt-ssh re-serializes minion_opts into a flow-style YAML
        #  literal it embeds straight into the shim script it deploys,
        #  and that re-serialization doesn't escape embedded double
        #  quotes correctly inside a flow-style string - several step
        #  cmd/content bodies (real bash scripts) have exactly that
        #  shape, which broke the shim's own config parsing outright.
        #  Base64 has no characters that class of bug can ever choke
        #  on; shared_states/lessons/map.jinja decodes this back into
        #  a real mapping before anything else ever touches it. Formula
        #  pillar keys (golang: etc.) are deliberately NOT wrapped the
        #  same way - a vendored formula's own map.jinja has no idea
        #  this encoding scheme exists and looks its own key up as a
        #  plain grain/pillar value.
        'grains' => { 'lessons_b64' => Base64.strict_encode64(lessons_shape(lessons_data).to_yaml) }.merge(extract_formula_pillars(lessons_data)),
      },
    },
  }
  FileUtils.mkdir_p(File.dirname(out_path))
  File.write(out_path, "---\n#{doc.to_yaml.sub(/\A---\n/, '')}", mode: 'wb')
end

# parse_salt_args(argv) - <config.yml> [out_path] --tree masterless|
#  roster [--select TAG,TAG] [--exclude TAG,TAG]. --select/--exclude
#  match generate_databag_args's own semantics exactly (see its own
#  comment) - only --tree is new here. out_path is optional - see
#  cmpaths.rb's own comment for what it defaults to.
def parse_salt_args(argv)
  options = { select: [], exclude: [], tree: nil }
  OptionParser.new do |opts|
    opts.on('--select TAGS') { |v| options[:select] = v.split(',').map(&:strip) }
    opts.on('--exclude TAGS') { |v| options[:exclude] = v.split(',').map(&:strip) }
    opts.on('--tree TREE') { |v| options[:tree] = v }
  end.parse!(argv)
  [argv[0], argv[1], options]
end

if __FILE__ == $PROGRAM_NAME
  config_path, out_path, options = parse_salt_args(ARGV)
  if config_path.nil? || config_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> [out_path] --tree masterless|roster [--select TAG,TAG] [--exclude TAG,TAG]"
    exit 1
  end
  unless TREES.include?(options[:tree])
    warn "#{$PROGRAM_NAME}: --tree must be one of #{TREES.join('/')}, got '#{options[:tree]}'"
    exit 1
  end

  tree = YAML.load_file(config_path)
  name = root_key(tree)
  out_path ||= cmpath('salt', options[:tree], name)
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

  case options[:tree]
  when 'masterless' then write_masterless(lessons_data, out_path)
  when 'roster' then write_roster(name, lessons_data, out_path)
  end

  puts "wrote #{out_path} (--tree #{options[:tree]})"
end
