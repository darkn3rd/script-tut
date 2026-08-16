#!/usr/bin/env ruby
require 'yaml'
require 'json'
require 'fileutils'
require_relative 'resolve_order'
require_relative 'generate_chef_databag' # for strip_comments/step_to_entry/consolidate_apt/root_key

# generate_scriptbox_databag.rb - the scriptbox: section's own data bag,
#  same self-contained-JSON approach as generate_chef_databag.rb's own
#  lessons data bag, but far simpler: scriptbox: has no sub-areas (no
#  gen_scripts/shell_scripts/... the way lessons: does), just one flat
#  packages: list directly under it - so this produces one flat
#  {'id' => ..., 'packages' => [...]} instead of one key per area.
#  Shares step_to_entry/consolidate_apt/strip_comments/root_key with
#  generate_chef_databag.rb rather than reimplementing them - same step
#  shape, same JSON-readiness rules, only the *area selection* and
#  *output shape* actually differ between the two.

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

  # resolve! runs on the *full* flattened tree, not just scriptbox's own
  #  steps, same as generate_chef_databag.rb's own lessons extraction -
  #  a needs:/meets: pair *within* scriptbox stays correctly ordered
  #  either way. A cross-cookbook one (scriptbox's own `needs: ruby`,
  #  met by lessons.gen_scripts.ruby's own rbenv install) is NOT
  #  resolved here at all - that dependency is satisfied by run-list
  #  ordering instead (lessons converges before scriptbox - see the
  #  Vagrantfile), the same way two genuinely separate cookbooks always
  #  have to coordinate. Confirmed directly: filtering to just
  #  owning_function(s) == 'scriptbox' below never pulls in the rbenv/
  #  ruby provider step itself, only scriptbox's own three steps.
  steps = flatten(tree[name])
  resolve!(steps)
  steps = steps.select { |s| owning_function(s) == 'scriptbox' }
  steps = steps.reject { |s| s[:type] == 'system' }
  dedup!(steps)

  entries = steps.map { |s| step_to_entry(s, tree) }
  data = { 'id' => name, 'packages' => consolidate_apt(entries) }

  FileUtils.mkdir_p(File.dirname(out_path))
  File.write(out_path, JSON.pretty_generate(data))
  puts "wrote #{out_path}"
end
