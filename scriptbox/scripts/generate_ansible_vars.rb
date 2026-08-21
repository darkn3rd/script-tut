#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require_relative 'resolve_order'
require_relative 'generate_chef_databag' # for strip_comments/step_to_entry/consolidate_apt/root_key/LESSON_AREAS/COMMON_AREA

# generate_ansible_vars.rb - the Ansible equivalent of generate_chef_
#  databag.rb + generate_scriptbox_databag.rb combined: same source of
#  truth (scriptbox/config/*.yml), same flattened/resolved step list, same
#  step_to_entry/consolidate_apt shape - just written out as the two
#  roles' own vars/<platform>.yml instead of the two Chef cookbooks' own
#  data_bags/*/​<platform>.json (Ansible has no data bag equivalent - these
#  are plain role vars files, loaded via include_vars). One invocation
#  produces both files (rather than mirroring the Chef side's two
#  separate scripts) since both need the exact same flatten/resolve! pass
#  over the whole tree anyway - no reason to parse the manifest twice for
#  two YAML files that come from the same run.
#
#  Loaded via each role's own tasks/main.yml (`include_vars:
#  "{{ role_path }}/vars/{{ ... }}.yml"`), keyed by a role variable
#  (lessons_platform/scriptbox_platform - see defaults/main.yml), the
#  Ansible analogue of Chef's own `data_bag_item('lessons',
#  node['lessons']['platform'])` explicit-lookup-by-key - group_vars
#  would be the wrong tool here, since that's Ansible's own automatic
#  inventory-group merge, not an arbitrary keyed document lookup.

# deep_stringify_keys(obj) - step_to_entry/consolidate_apt (shared from
#  generate_chef_databag.rb) build each entry with symbol keys (:type,
#  :name, ...), which JSON.pretty_generate happily renders as plain
#  "type"/"name" strings but Psych's own to_yaml does not - left alone,
#  every entry would come out as YAML's own `:type: apt` symbol syntax,
#  which Ansible has no use for (item['type'] would need to be
#  item[:type], and Ansible's Jinja templating has no symbol literal at
#  all). Recurses through both Hash and Array so nested step data (e.g.
#  an add_apt_repo entry's own sub-hash) comes out consistently too.
def deep_stringify_keys(obj)
  case obj
  when Hash
    obj.each_with_object({}) { |(k, v), h| h[k.to_s] = deep_stringify_keys(v) }
  when Array
    obj.map { |v| deep_stringify_keys(v) }
  else
    obj
  end
end

if __FILE__ == $PROGRAM_NAME
  config_path = ARGV[0]
  lessons_out = ARGV[1]
  scriptbox_out = ARGV[2]
  if config_path.nil? || config_path.empty? || lessons_out.nil? || lessons_out.empty? || scriptbox_out.nil? || scriptbox_out.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> <lessons_out.yml> <scriptbox_out.yml>"
    exit 1
  end

  tree = YAML.load_file(config_path)
  name = root_key(tree)

  # resolve! runs once on the *full* flattened tree (a needs:/meets:
  #  pair spanning areas still needs the whole tree to resolve), but
  #  the owning_function select has to happen *before* dedup! and stay
  #  scoped separately per target, exactly like each of the two Chef
  #  generators does on its own - not one dedup! over the combined
  #  list. dedup! drops a later (type, name) repeat in favor of
  #  whichever occurrence comes first; global.packages' own top-level
  #  `apt: zsh` / `file: ubuntu_default_zshrc` (unrelated to lessons,
  #  filtered out either way) sits earlier in document order than
  #  lessons.shell_scripts.zsh's identical pair - deduping across both
  #  areas at once silently discarded the *lessons* copy in favor of
  #  the soon-to-be-filtered-out global one, confirmed directly: zsh
  #  and its file step vanished from the generated lessons vars file
  #  entirely until this was split back out per target.
  all_steps = flatten(tree[name])
  resolve!(all_steps)

  lessons_steps = all_steps.select { |s| (['lessons'] + LESSON_AREAS).include?(owning_function(s)) }
  lessons_steps = lessons_steps.reject { |s| s[:type] == 'system' }
  dedup!(lessons_steps)
  lessons_data = { 'id' => name }
  lessons_data[COMMON_AREA] = consolidate_apt(lessons_steps.select { |s| owning_function(s) == 'lessons' }.map { |s| step_to_entry(s, tree) })
  LESSON_AREAS.each do |area|
    entries = lessons_steps.select { |s| owning_function(s) == area }.map { |s| step_to_entry(s, tree) }
    lessons_data[area] = consolidate_apt(entries)
  end

  scriptbox_steps = all_steps.select { |s| owning_function(s) == 'scriptbox' }
  scriptbox_steps = scriptbox_steps.reject { |s| s[:type] == 'system' }
  dedup!(scriptbox_steps)
  scriptbox_data = { 'id' => name, 'packages' => consolidate_apt(scriptbox_steps.map { |s| step_to_entry(s, tree) }) }

  FileUtils.mkdir_p(File.dirname(lessons_out))
  File.write(lessons_out, deep_stringify_keys(lessons_data).to_yaml)
  puts "wrote #{lessons_out}"

  FileUtils.mkdir_p(File.dirname(scriptbox_out))
  File.write(scriptbox_out, deep_stringify_keys(scriptbox_data).to_yaml)
  puts "wrote #{scriptbox_out}"
end
