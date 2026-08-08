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
            # --yes - accepts the "do you want to make this the
            #  default" prompt sdk install asks non-interactively.
            when 'sdkman' then "sdk install #{step[:name]} --yes"
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

if __FILE__ == $PROGRAM_NAME
  config_path = ARGV[0]
  if config_path.nil? || config_path.empty?
    warn "usage: #{$PROGRAM_NAME} <config.yml>"
    exit 1
  end
  unless File.exist?(config_path)
    warn "#{$PROGRAM_NAME}: no such file: #{config_path}"
    exit 1
  end

  tree = YAML.load_file(config_path)
  scripts = tree['scripts'] || {}
  name = root_key(tree)

  steps = flatten(tree[name])
  resolve!(steps)

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
