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
  config_path, out_path, select_tags, exclude_tags = parse_databag_args(ARGV)
  if config_path.nil? || config_path.empty? || out_path.nil? || out_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml> <out.json> [--select TAG,TAG] [--exclude TAG,TAG]"
    exit 1
  end

  tree = YAML.load_file(config_path)
  name = root_key(tree)
  # Whole tree, not just tree[name] - see generate_chef_databag.rb's
  #  own comment on this same fix (scripts:/files:/appends: are top-
  #  level RESERVED_KEYS blocks, not nested inside tree[name], so a
  #  <%= $name %> reference in a script body sat unsubstituted before
  #  this widened past tree[name] alone).
  tree = substitute_variables(tree, tree[name]['variables'] || {})

  # topological_order runs on the *full* flattened tree, not just
  #  scriptbox's own steps, same as generate_chef_databag.rb's own
  #  lessons extraction -
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
  steps, omitted = resolve_included(steps, select_tags, exclude_tags)
  warn_omissions(omitted)
  topological_order(steps)
  # Validated against the *whole* resolved tree, not the scriptbox-only
  #  subset below - a cross-cookbook need: (scriptbox's own `needs:
  #  ruby`, met by lessons.gen_scripts.ruby's own provider) never
  #  survives the owning_function filter at all, so checking after it
  #  would always see "no provider" and raise a false positive.
  version_omitted = check_version_needs!(steps)
  version_omitted.each { |s| warn "#{$PROGRAM_NAME}: #{s[:omitted_reason]}" }
  steps = steps.select { |s| owning_function(s) == 'scriptbox' }
  steps = steps.reject { |s| %w[system omitted_version_need].include?(s[:type]) }
  dedup!(steps)

  entries = steps.map { |s| step_to_entry(s, tree) }
  data = { 'id' => name, 'packages' => consolidate_apt(entries) }

  FileUtils.mkdir_p(File.dirname(out_path))
  File.write(out_path, JSON.pretty_generate(data))
  puts "wrote #{out_path}"
end
