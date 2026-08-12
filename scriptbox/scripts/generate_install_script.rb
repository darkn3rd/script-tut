#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require_relative 'resolve_order'

# bash_install/powershell_install - the *dialect-specific* half of a
#  step's install command - just the package-manager invocation for
#  step[:type], nil for a type that dialect doesn't know about ('script'
#  is deliberately absent from both: it's dialect-agnostic, handled once
#  in command_for instead of duplicated in each).
def bash_install(step)
  case step[:type]
  when 'brew'   then "brew install #{step[:name]}"
  when 'cask'   then "brew install --cask #{step[:name]}"
  when 'tap'    then "brew tap #{step[:name]}"
  when 'cpan'   then "cpan -i #{step[:name]}"
  when 'cpanm'  then "cpanm #{step[:name]}"
  when 'system' then "# #{step[:name]}: expected to already be provided by the OS"
  # Array.() - step[:name] is a plain string for most apt entries, but
  #  the config also uses a YAML list for a whole group of packages in
  #  one entry (e.g. the compiled-toolchain dev-header list) - Array()
  #  handles both without the caller needing to know which shape it got.
  # DEBIAN_FRONTEND=noninteractive - confirmed directly needed: without
  #  it, debconf's dpkg-preconfigure hook tries to open a real terminal
  #  to ask package-configuration questions (timezone, etc.), which fails
  #  under Vagrant's shell provisioner (no real tty) with "unable to
  #  re-open stdin: No such file or directory" - once per apt-get call,
  #  harmless (falls back to defaults either way) but noisy across a
  #  whole install script. `sudo env VAR=value cmd`, not `sudo VAR=value
  #  cmd` - the latter depends on the box's sudoers env_reset/env_keep
  #  policy actually letting VAR through, which isn't guaranteed across
  #  every Ubuntu image; `env` is the actual command sudo grants root to
  #  run here, so it sets the variable for its own child (apt-get)
  #  regardless of sudo's own environment filtering. Scoped to just this
  #  command rather than exported for the whole script, same reasoning
  #  as -y being local to this one line rather than a global apt config
  #  change.
  # The one-time `apt-get update` this needs before the *first* apt
  #  step isn't here either - same as pacman's own -Syu refresh below,
  #  it's a property of the whole script, not any one step, so
  #  write_install_script injects it directly.
  when 'apt'    then "sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y #{Array(step[:name]).join(' ')}"
  # -s/--skip-existing - safe to run again if this exact version is
  #  already installed (a repeat/unattended run shouldn't fail or
  #  rebuild from source unnecessarily).
  when 'pyenv'  then "pyenv install -s #{step[:name]}"
  when 'rbenv'  then "rbenv install -s #{step[:name]}"
  # sdk itself is a shell function, not a real executable - only
  #  defined once sdkman's own init script has been sourced (see the
  #  ubuntu22_sdkman script step, which must run - and its own `source
  #  ~/.bashrc` take effect - before any sdkman step, same as
  #  pyenv/rbenv's own init).
  # No --yes here (confirmed directly: `sdk install` doesn't recognize
  #  it as a flag at all - it gets parsed as the *version* positional
  #  argument instead, failing with "Stop! <candidate> --yes is not
  #  available"). The "make this the default?" prompt this was meant to
  #  answer is controlled by sdkman_auto_answer=true in
  #  ~/.sdkman/etc/config instead (see the ubuntu22_sdkman script step,
  #  which already sets it) - that's the real, documented
  #  non-interactive mechanism, not a per-command flag.
  when 'sdkman' then "sdk install #{step[:name]}"
  when 'gem'    then "gem install #{step[:name]}"
  # --noconfirm - same non-interactive reasoning as apt's own -y. The
  #  one-time `pacman -Syu` refresh this needs before the *first* pacman
  #  step isn't here - it's a property of the whole script, not any one
  #  step, so write_install_script injects it directly.
  when 'pacman' then "pacman -S --noconfirm #{Array(step[:name]).join(' ')}"
  # apt-cyg - the Cygwin apt-get equivalent already used throughout this
  #  project's own README (see cygwin_ratatui_ruby_gem's own apt-cyg
  #  install lines) - not choco_cyg, which is a completely different
  #  thing (choco_cyg installs Cygwin packages *from PowerShell/Windows*,
  #  for windows.yml's own shell_scripts entry; this is Cygwin installing
  #  its own packages from *inside* a Cygwin bash session).
  when 'cyg' then "apt-cyg install #{Array(step[:name]).join(' ')}"
  # Tested, then appended to whichever startup files actually exist,
  #  rather than assumed present/blindly appended to both - confirmed
  #  directly this matters: .zshrc in particular is often just absent
  #  (zsh not installed/never run), and appending to a file that isn't
  #  actually anyone's shell startup file yet accomplishes nothing.
  #  `export PATH=...` prepends (not appends) the path within the line
  #  itself, same convention msys2_cpan_local_setup's own PATH line
  #  already uses - a later line in the same startup file should still
  #  be able to win.
  when 'path'
    path = step[:name]
    <<~BASH.strip
      if [ -d "#{path}" ]; then
        [ -f ~/.bashrc ] && echo 'export PATH="#{path}:$PATH"' >> ~/.bashrc
        [ -f ~/.zshrc ] && echo 'export PATH="#{path}:$PATH"' >> ~/.zshrc
      else
        echo "WARNING: expected path not found: #{path}" >&2
      fi
    BASH
  end
end

def powershell_install(step)
  case step[:type]
  when 'choco' then "choco install #{step[:name]} -y"
  when 'gem'   then "gem install #{step[:name]}"
  # cyg-get (itself a `choco: cyg-get` package elsewhere in the same
  #  file) installs *Cygwin's own* packages from PowerShell - a
  #  genuinely different install path than plain `choco:`, not just a
  #  naming preference, so it gets its own type rather than folding into
  #  'choco'.
  when 'choco_cyg' then "cyg-get #{step[:name]}"
  # -NoRestart - never reboot mid-script; a feature step's own
  #  `reboot: yes` (see resolve_order.rb's step[:reboot]) surfaces as a
  #  summary at the end of the generated script instead (see
  #  write_install_script) - an unattended mid-script reboot would just
  #  kill the rest of the run.
  when 'feature' then "Enable-WindowsOptionalFeature -Online -FeatureName #{step[:name]} -All -NoRestart"
  end
end

# command_for - the full install command for one resolved step, in the
#  given dialect ('bash' or 'powershell' - see write_install_script).
#  `script` steps pull their multi-line cmd straight from the YAML's
#  scripts: block, already written in whatever dialect its own platform
#  needs (windows.yml's own windows_chocolatey script is PowerShell) -
#  handled once here rather than duplicated in bash_install/
#  powershell_install, since the lookup itself doesn't differ by
#  dialect, only the script *body* someone else already wrote does.
#  `cmd:` used *alone* (no other package type alongside it) is the
#  same idea as `script:` for a one-liner that doesn't need its own
#  named entry in the scripts: block - e.g. `- cmd: gem update
#  --system`. Dialect-agnostic like `script:`, not routed through
#  bash_install/powershell_install: the author writes one command
#  that works verbatim in both shells (same reasoning `gem update
#  --system` itself relies on - identical spelling either way), rather
#  than this generator trying to translate it per dialect.
#  A `cmd:` *sibling* key alongside some other type (e.g. "pyenv
#  global 3.14.6" right after installing a pyenv version) is a
#  different thing - runs immediately after that other install, in
#  the same generated script - see resolve_order.rb's own step[:cmd].
def command_for(step, scripts, dialect)
  install =
    case step[:type]
    when 'script' then scripts.dig(step[:name], 'cmd')&.rstrip
    when 'cmd' then step[:name]
    else dialect == 'powershell' ? powershell_install(step) : bash_install(step)
    end
  # Confirmed directly this matters, not just belt-and-suspenders: before
  #  this fallback existed, an unhandled type (e.g. 'choco'/'feature'
  #  when only bash_install existed) silently produced a blank line in
  #  the generated script instead of an error anywhere - a step that
  #  looked present in the output but installed nothing at all.
  install ||= "# TODO: unsupported package type '#{step[:type]}' for '#{step[:name]}' (dialect: #{dialect})"
  # Not for type 'cmd' - step[:name] and step[:cmd] are the same string
  # there (both read from the same YAML key), so appending it again
  # would just duplicate the one line.
  step[:cmd] && step[:type] != 'cmd' ? "#{install}\n#{step[:cmd]}" : install
end

# write_install_script(name, steps, scripts, dialect, generated_dir,
#  header_lines) - writes generated/<name>_install.<ext> in the given
#  dialect, shared by generate_install_script.rb's and gen_installer.rb's
#  own entry points so the two never drift into writing the file header/
#  footer two different ways. PowerShell gets a real self-elevation
#  check up front rather than a comment reminding the user to run it as
#  Administrator - confirmed directly every choco/feature step in
#  practice needs it, and Start-Process -Verb RunAs relaunching itself
#  once at the top is simpler and more reliable than trying to elevate
#  per step. Returns the path written.
def write_install_script(name, steps, scripts, dialect, generated_dir, header_lines)
  ext = dialect == 'powershell' ? 'ps1' : 'sh'
  out_path = File.join(generated_dir, "#{name}_install.#{ext}")
  reboot_steps = steps.select { |s| s[:reboot] }

  # 'wb', not 'w' - confirmed directly against a real, serious failure:
  # Ruby's text-mode file writing on Windows auto-translates \n to \r\n
  # on write, which silently corrupts every bash script this generates
  # whenever it's run from Windows (this project explicitly generates
  # scripts *from* Windows *for* other platforms - see #7 - so this
  # isn't a hypothetical). CRLF breaks heredoc terminator matching
  # (`EOF\r` != `EOF`, so bash reads to end-of-file looking for a match
  # that never comes, silently swallowing the rest of the script as
  # heredoc body) and corrupts `set -e` itself (`$'\r': command not
  # found`). Binary mode disables the translation outright, regardless
  # of host OS - safe for the powershell dialect too, since modern
  # PowerShell tolerates LF-only scripts fine.
  File.open(out_path, 'wb') do |f|
    if dialect == 'powershell'
      f.puts '#Requires -Version 5.1'
      f.puts "$ErrorActionPreference = 'Stop'"
      f.puts ''
      header_lines.each { |line| f.puts "# #{line}" }
      f.puts ''
      f.puts '# Most steps below (choco install, Enable-WindowsOptionalFeature) need'
      f.puts '# Administrator rights - relaunch elevated once, up front, rather than per step.'
      f.puts '$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())'
      f.puts 'if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {'
      f.puts '    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""'
      f.puts '    exit'
      f.puts '}'
      f.puts ''
      steps.each do |step|
        f.puts "Write-Host '==> [#{step[:path]}] #{step[:type]}: #{step[:name]}'"
        f.puts command_for(step, scripts, dialect)
        f.puts ''
      end
      unless reboot_steps.empty?
        f.puts "Write-Host ''"
        f.puts "Write-Host 'The following require a restart to take effect:'"
        reboot_steps.each { |s| f.puts "Write-Host '  - #{s[:name]}'" }
      end
    else
      f.puts '#!/bin/bash'
      f.puts 'set -e'
      f.puts ''
      header_lines.each { |line| f.puts "# #{line}" }
      f.puts ''
      # Sync/refresh the package database exactly once, right before the
      #  *first* apt/pacman step of each kind - not per step, which
      #  would just re-sync needlessly before every single package - and
      #  not unconditionally up front either, on a platform with no
      #  apt/pacman steps at all (ubuntu22/macos share this same bash
      #  branch). Confirmed directly apt needed this too, the same as
      #  pacman already got: generating ubuntu2204.yml's full install
      #  script, the very first `apt-get install -y zsh` had nothing
      #  before it at all - on a fresh system (a minimal cloud image,
      #  a fresh container) with a stale/empty local package index,
      #  that install can fail outright. The two existing `apt-get
      #  update` lines already in this config (ahead of the dotnet-sdk
      #  and PowerShell steps) are a different thing entirely - each is
      #  a repo-specific refresh baked into that one script step's own
      #  body, right after *that* step adds a new APT source, not a
      #  general safeguard for every plain `apt:` step.
      apt_updated = false
      pacman_synced = false
      steps.each do |step|
        if step[:type] == 'apt' && !apt_updated
          f.puts "echo '==> apt-get update (refresh package index)'"
          f.puts 'sudo apt-get update'
          f.puts ''
          apt_updated = true
        end
        if step[:type] == 'pacman' && !pacman_synced
          f.puts "echo '==> pacman -Syu (refresh package database)'"
          f.puts 'pacman -Syu --noconfirm'
          f.puts ''
          pacman_synced = true
        end
        f.puts "echo '==> [#{step[:path]}] #{step[:type]}: #{step[:name]}'"
        f.puts command_for(step, scripts, dialect)
        f.puts ''
      end
    end
  end
  File.chmod(0o755, out_path) if dialect != 'powershell'
  out_path
end

# dialect_for(tree, name) - 'powershell' or 'bash' (default) - a
#  platform declares 'shell: powershell' as a sibling of its own
#  'global:'/'lessons:' keys (see windows.yml) when its packages/scripts
#  aren't bash. flatten (resolve_order.rb) already ignores any sibling
#  key whose value isn't a Hash, so 'shell:' needs no special-casing
#  there - only here, where it's actually read.
def dialect_for(tree, name)
  node = tree[name]
  node.is_a?(Hash) ? (node['shell'] || 'bash') : 'bash'
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
  dialect = dialect_for(tree, name)
  out_path = write_install_script(name, steps, scripts, dialect, generated_dir, [
    "Generated from #{config_path} by #{$PROGRAM_NAME} - do not edit by hand.",
    'Installs everything in the file, in dependency-resolved order.'
  ])
  puts "wrote #{out_path}"
end
