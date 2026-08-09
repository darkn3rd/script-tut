#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require_relative 'resolve_order'

# bash_for - the shell command for one resolved step. `script` steps pull
#  their multi-line cmd straight from the YAML's scripts: block; `system`
#  steps are a no-op (already provided by the OS) documented as a comment.
#  A `cmd:` sibling key (e.g. "pyenv global 3.14.6" right after installing
#  a pyenv version) runs immediately after the install itself, in the
#  same generated script - see resolve_order.rb's own step[:cmd].
def bash_for(step, scripts)
  install = case step[:type]
            when 'brew'   then "brew install #{step[:name]}"
            when 'cask'   then "brew install --cask #{step[:name]}"
            when 'tap'    then "brew tap #{step[:name]}"
            when 'cpan'   then "cpan -i #{step[:name]}"
            when 'cpanm'  then "cpanm #{step[:name]}"
            when 'system' then "# #{step[:name]}: expected to already be provided by the OS"
            # Array.() - step[:name] is a plain string for most apt
            #  entries, but the config also uses a YAML list for a
            #  whole group of packages in one entry (e.g. the compiled-
            #  toolchain dev-header list) - Array() handles both without
            #  the caller needing to know which shape it got.
            when 'apt'    then "sudo apt-get install -y #{Array(step[:name]).join(' ')}"
            # -s/--skip-existing - safe to run again if this exact
            #  version is already installed (a repeat/unattended run
            #  shouldn't fail or rebuild from source unnecessarily).
            when 'pyenv'  then "pyenv install -s #{step[:name]}"
            when 'rbenv'  then "rbenv install -s #{step[:name]}"
            # sdk itself is a shell function, not a real executable -
            #  only defined once sdkman's own init script has been
            #  sourced (see the ubuntu22_sdkman script step, which must
            #  run - and its own `source ~/.bashrc` take effect - before
            #  any sdkman step, same as pyenv/rbenv's own init).
            # No --yes here (confirmed directly: `sdk install` doesn't
            #  recognize it as a flag at all - it gets parsed as the
            #  *version* positional argument instead, failing with
            #  "Stop! <candidate> --yes is not available"). The "make
            #  this the default?" prompt this was meant to answer is
            #  controlled by sdkman_auto_answer=true in
            #  ~/.sdkman/etc/config instead (see the ubuntu22_sdkman
            #  script step, which already sets it) - that's the real,
            #  documented non-interactive mechanism, not a per-command
            #  flag.
            when 'sdkman' then "sdk install #{step[:name]}"
            when 'script'
              scripts.dig(step[:name], 'cmd')&.rstrip || "# missing scripts.#{step[:name]} definition"
            end
  step[:cmd] ? "#{install}\n#{step[:cmd]}" : install
end

# root_key - the platform key a config file is about (e.g. "macos",
#  "windows"). Every config file has exactly one of these alongside its
#  "scripts" block; anything else is a malformed file, so fail fast
#  rather than silently guessing which key to use.
def root_key(tree)
  candidates = tree.keys - ['scripts']
  if candidates.size != 1
    warn "#{$PROGRAM_NAME}: expected exactly one top-level key besides 'scripts', found: #{candidates.join(', ')}"
    exit 1
  end
  candidates.first
end

# path_matches?(step_path, selector) - true if selector's dot-segments
#  appear as a *consecutive* run within step_path's own segments -
#  e.g. selector "lessons.compiled_lang" matches step path
#  "global.lessons.compiled_lang" and "global.lessons.compiled_lang.rust"
#  alike, without needing the caller to know or type the "global."
#  prefix every step's own path actually starts with. Segment-exact
#  comparison, not a raw substring match - otherwise a short selector
#  like "lessons.sh" would wrongly match "lessons.shell_scripts" the
#  same way a bare .include? already proved unsafe elsewhere in this
#  project (see verify_commands.rb's own word-boundary fixes).
def path_matches?(step_path, selector)
  path_segments = step_path.split('.')
  selector_segments = selector.split('.')
  return false if selector_segments.length > path_segments.length

  (0..path_segments.length - selector_segments.length).any? do |i|
    path_segments[i, selector_segments.length] == selector_segments
  end
end

# expand_selectors(argv) - "testbox", "lessons.compiled_lang", or
#  "lessons.{compiled_lang,shell_scripts}" into a flat list of plain
#  dotted-path selectors - same {a,b,c} brace syntax run_all_tests.rb's
#  own expand_selection already uses, for the same reason: the invoking
#  shell (bash, PowerShell, cmd.exe) can't be relied on to expand this
#  itself consistently across platforms.
def expand_selectors(argv)
  argv.flat_map do |token|
    if token =~ /\A(.*)\{(.+)\}\z/
      prefix = Regexp.last_match(1)
      names = Regexp.last_match(2).split(',').map(&:strip)
      names.map { |n| "#{prefix}#{n}" }
    else
      [token]
    end
  end
end

# select_sections(steps, selectors) - the subset of steps whose own
#  path matches at least one selector, plus (transitively) any step
#  elsewhere in the file that a selected step `needs:` - confirmed
#  directly this matters: selecting a single narrow leaf (e.g. just
#  "lessons.compiled_lang.go") must not silently drop a prerequisite
#  declared at a *sibling* path (compiled_lang's own shared
#  `apt: build-essential meets: make`) that a broader selection would
#  otherwise have brought along automatically - a generated script
#  missing its own dependency is worse than one with a few extra,
#  already-idempotent steps in it.
def select_sections(steps, selectors)
  return steps if selectors.empty?

  selected = steps.select { |step| selectors.any? { |sel| path_matches?(step[:path], sel) } }
  loop do
    needed = selected.map { |s| s[:needs] }.compact.uniq
    providers = steps.select { |s| needed.include?(s[:meets]) && !selected.include?(s) }
    break if providers.empty?

    selected.concat(providers)
  end
  # Preserve steps' own relative order rather than selected's
  #  append-during-pull-in order.
  steps.select { |step| selected.include?(step) }
end

# print_usage(stream) - shared between --help (stdout, exit 0) and a
#  missing config_path (stderr, exit 1) - same message either way, just
#  a different destination/exit status depending on whether the user
#  actually asked for it or just forgot an argument.
def print_usage(stream)
  stream.puts "usage: #{$PROGRAM_NAME} <config.yml> [SECTION ...]"
  stream.puts ''
  stream.puts 'Reads one config/*.yml provisioning file, resolves every step into'
  stream.puts 'dependency-correct order (a `needs:` consumer always ends up after'
  stream.puts 'whichever step `meets:` it), drops exact duplicate steps, and writes'
  stream.puts 'an executable generated/<platform>_install.sh that runs them in that'
  stream.puts 'order - "<platform>" is the config file\'s own top-level key (e.g.'
  stream.puts '"ubuntu22"), read from the file itself, not the filename.'
  stream.puts ''
  stream.puts '  SECTION - a dotted path (or suffix of one) into the config tree,'
  stream.puts '    e.g. "testbox", "lessons.compiled_lang", or'
  stream.puts '    "lessons.{compiled_lang,shell_scripts}" - matches any step whose'
  stream.puts '    own path contains it as a consecutive segment run. No SECTION'
  stream.puts '    args installs everything in the file.'
end

if __FILE__ == $PROGRAM_NAME
  if %w[-h --help].include?(ARGV.first)
    print_usage($stdout)
    exit 0
  end

  config_path = ARGV[0]
  if config_path.nil? || config_path.empty?
    print_usage($stderr)
    exit 1
  end
  unless File.exist?(config_path)
    warn "#{$PROGRAM_NAME}: no such file: #{config_path}"
    exit 1
  end

  tree = YAML.load_file(config_path)
  scripts = tree['scripts'] || {}
  name = root_key(tree)

  # Order matters here: resolve! runs on the *full* list first, so
  #  dependency ordering is correct globally regardless of what gets
  #  selected afterward; select_sections then filters down to the
  #  requested sections (+ anything they need); dedup! runs *last*,
  #  within just that filtered set - confirmed directly running dedup!
  #  before selection is wrong, not just reordered differently:
  #  selecting a single section (e.g. just "testbox") could lose a step
  #  entirely if dedup! had already kept some *other*, unselected
  #  section's identical step as the "first" occurrence instead.
  steps = flatten(tree[name])
  resolve!(steps)
  steps = select_sections(steps, expand_selectors(ARGV[1..]))
  dedup!(steps)

  generated_dir = File.join(__dir__, '..', 'generated')
  FileUtils.mkdir_p(generated_dir)
  out_path = File.join(generated_dir, "#{name}_install.sh")
  File.open(out_path, 'w') do |f|
    f.puts '#!/bin/bash'
    f.puts 'set -e'
    f.puts ''
    f.puts "# Generated from #{config_path} by #{$PROGRAM_NAME} - do not edit by hand."
    f.puts '# Installs everything in the file, in dependency-resolved order.'
    f.puts ''
    steps.each do |step|
      f.puts "echo '==> [#{step[:path]}] #{step[:type]}: #{step[:name]}'"
      f.puts bash_for(step, scripts)
      f.puts ''
    end
  end
  File.chmod(0o755, out_path)
  puts "wrote #{out_path}"
end
