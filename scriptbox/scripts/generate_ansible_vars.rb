#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require_relative 'resolve_order'
require_relative 'generate_chef_databag' # for strip_comments/step_to_entry/consolidate_apt/root_key/LESSON_AREAS/COMMON_AREA

# generate_ansible_vars.rb - the Ansible equivalent of generate_chef_
#  databag.rb + generate_scriptbox_databag.rb combined: same source of
#  truth (scriptbox/config/*.yml), same flattened/resolved step list, same
#  step_to_entry/consolidate_apt shape - just written out as one
#  group_vars/all/ file instead of the two Chef cookbooks' own
#  data_bags/*/<platform>.json. One invocation produces the combined file
#  (rather than mirroring the Chef side's two separate scripts) since
#  both halves need the exact same flatten/resolve! pass over the whole
#  tree anyway - no reason to parse the manifest twice for one YAML file.
#
#  Written as {'lessons' => {platform => {...}}, 'scriptbox' => {platform
#  => {...}}} under group_vars/all/, which Ansible auto-loads for every
#  host before any role runs - both roles read straight out of the
#  top-level `lessons`/`scriptbox` vars it defines
#  (lessons[lessons_platform], see ../../configbox/ansible/provision/
#  roles/lessons/tasks/main.yml), no per-role include_vars task needed.
#  The platform key is still an explicit lookup, same as Chef's own
#  data_bag_item('lessons', node['lessons']['platform']) - group_vars'
#  own automatic inventory-group merge plays no part in selecting it.

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
  out_path = ARGV[1]
  if config_path.nil? || config_path.empty? || out_path.nil? || out_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> <out.yml>"
    exit 1
  end

  tree = YAML.load_file(config_path)
  name = root_key(tree)
  tree[name] = substitute_variables(tree[name], tree[name]['variables'] || {})

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

  # Merged into any existing out_path rather than overwritten outright -
  #  one manifest run only has this platform's data, but out_path is
  #  shared across every platform (see scriptbox/config/windows.yml),
  #  so a later platform's run must not clobber an earlier one's entry.
  existing = File.exist?(out_path) ? (YAML.load_file(out_path) || {}) : {}
  combined = {
    'lessons' => (existing['lessons'] || {}).merge(name => lessons_data),
    'scriptbox' => (existing['scriptbox'] || {}).merge(name => scriptbox_data),
  }

  FileUtils.mkdir_p(File.dirname(out_path))
  File.write(out_path, deep_stringify_keys(combined).to_yaml)
  puts "wrote #{out_path}"
end
