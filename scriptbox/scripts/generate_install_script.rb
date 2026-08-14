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
    # A bare function *call*, not the body - write_install_script's own
    #  emit_script_functions already defined it, once, up front. Still
    #  gated on the body actually existing (not just `step[:name]`
    #  unconditionally), so a typo'd/missing scripts: entry still falls
    #  through to the "unsupported" TODO below instead of generating a
    #  call to a function that was never defined.
    when 'script' then (scripts.dig(step[:name], 'cmd') ? step[:name] : nil)
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

# emit_script_functions(f, steps, scripts, dialect) - defines every
#  unique `script`-type step referenced anywhere in `steps` as a real,
#  named function up front (bash: `name() { ... }`, PowerShell:
#  `function name { ... }`), instead of splicing its body inline at
#  every call site the way this used to work - command_for's own
#  'script' case now just emits a call to the name defined here. First-
#  appearance order, deduped by name (a script referenced from more
#  than one place in the manifest - e.g. attached to two different
#  packages via a sibling `script:` key - only needs defining once;
#  dedup! already collapses repeat *steps*, but two distinct packages
#  each attaching the same script produces two distinct steps that
#  legitimately both call it).
#
#  A bare `cmd:` package type (see command_for) deliberately isn't
#  included here - it has no name of its own to define a function
#  under (step[:name] and step[:cmd] are the same string - see
#  command_for's own comment), so there's nothing to name it.
def emit_script_functions(f, steps, scripts, dialect)
  steps.select { |s| s[:type] == 'script' }.map { |s| s[:name] }.uniq.each do |sname|
    body = scripts.dig(sname, 'cmd')&.rstrip
    next unless body

    if dialect == 'powershell'
      f.puts "function #{sname} {"
    else
      f.puts "#{sname}() {"
    end
    f.puts indent_body(body, '  ')
    f.puts '}'
    f.puts ''
  end
end

# indent_body(body, indent) - `body`'s own lines each prefixed with
#  `indent`, except heredoc payload lines (and the heredoc's own
#  terminator line), which are left exactly as they are. Two different
#  reasons that's not optional: bash requires a heredoc terminator
#  unindented at column 0 unless the opener used `<<-` (none of these
#  do - confirmed directly, every heredoc across config/*.yml is a
#  plain `<<EOF`/`<<'EOF'`), so an indented terminator would just never
#  match and the heredoc would run away to EOF; and the payload lines
#  themselves aren't script logic at all, they're literal file content
#  (e.g. cygwin_purge_windows_path's heredoc *is* the real text written
#  into ~/.bashrc) - indenting them would inject extra leading
#  whitespace directly into that file, not just the generated script.
#  Only recognizes bash's own `<<`/`<<-` heredoc syntax - PowerShell's
#  here-strings (`@"..."@`/`@'...'@`) have the identical column-0-
#  terminator hazard but aren't detected here, since none of the
#  windows.yml scripts currently use one (confirmed directly - no `@"`/
#  `@'` anywhere in config/*.yml). Extend this the same way if one ever
#  gets added.
def indent_body(body, indent)
  heredoc_terminator = nil
  body.each_line.map do |line|
    if heredoc_terminator
      heredoc_terminator = nil if line.chomp == heredoc_terminator
      line
    elsif (m = line.match(/<<-?\s*(['"]?)(\w+)\1/))
      heredoc_terminator = m[2]
      "#{indent}#{line}"
    elsif line.strip.empty?
      line
    else
      "#{indent}#{line}"
    end
  end.join
end

# render_step(step, scripts, dialect, state) - one step's full output
#  block (status line + install command + any dialect-specific follow-
#  up), as a single un-indented string ending in a blank line - the same
#  shape write_install_script used to emit directly into the file
#  before steps were grouped into functions, now built once here so
#  provider/section function bodies (see emit_provider_functions/
#  emit_section_functions) and the file-header case all use exactly one
#  implementation. `state` is a shared, mutable {apt_updated:,
#  pacman_synced:} - the one-time package-index refresh has to happen
#  before the very first apt/pacman step *anywhere in the whole script*,
#  which can now end up inside any of several different functions, not
#  just the top of one flat loop - a plain local boolean wouldn't see
#  across those calls the way this shared hash does.
def render_step(step, scripts, dialect, state)
  lines = []
  if dialect == 'powershell'
    lines << "Write-Host '==> [#{step[:path]}] #{step[:type]}: #{step[:name]}'"
    lines << command_for(step, scripts, dialect)
    if step[:type] == 'choco'
      lines << 'Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"'
      lines << 'Update-SessionEnvironment'
    end
  else
    if step[:type] == 'apt' && !state[:apt_updated]
      lines << "echo '==> apt-get update (refresh package index)'"
      lines << 'sudo apt-get update'
      lines << ''
      state[:apt_updated] = true
    end
    if step[:type] == 'pacman' && !state[:pacman_synced]
      lines << "echo '==> pacman -Syu (refresh package database)'"
      lines << 'pacman -Syu --noconfirm'
      lines << ''
      state[:pacman_synced] = true
    end
    lines << "echo '==> [#{step[:path]}] #{step[:type]}: #{step[:name]}'"
    lines << command_for(step, scripts, dialect)
  end
  "#{lines.join("\n")}\n\n"
end

# emit_provider_functions(f, shared_groups, scripts, dialect, state) -
#  defines each shared_groups entry (see resolve_order.rb's split_shared)
#  as its own function, up front - the whole reason these exist: a step
#  whose `meets:` crosses a section-function boundary can't just live
#  inside whichever section happens to declare it, because a *different*
#  section may need it to have already run first. Called from
#  write_install_script before any section function is even defined.
def emit_provider_functions(f, shared_groups, scripts, dialect, state)
  shared_groups.each do |group|
    f.puts(dialect == 'powershell' ? "function #{group[:name]} {" : "#{group[:name]}() {")
    body = group[:steps].map { |s| render_step(s, scripts, dialect, state) }.join
    f.puts indent_body(body, '  ')
    f.puts '}'
    f.puts ''
  end
end

# section_tree(local_steps) - groups local_steps (the leftover half of
#  split_shared, after shared providers are pulled out) by
#  owning_function, and records which function calls which. A step's own
#  path, e.g. "global.lessons.gen_scripts.groovy", filtered down to just
#  its FUNCTION_SECTIONS segments ("global", "lessons", "gen_scripts")
#  and taken pairwise, says lessons is gen_scripts' own parent - derived
#  from each file's actual tree shape, not hardcoded, so this comes out
#  right even for windows.yml's own quirk of nesting cibox/scriptbox/
#  testbox under lessons instead of directly under global like every
#  other platform's config (reflects the manifest as actually written,
#  rather than silently reshaping it to match the others).
def section_tree(local_steps)
  children = Hash.new { |h, k| h[k] = [] }
  own_steps = Hash.new { |h, k| h[k] = [] }

  local_steps.each do |step|
    boundaries = step[:path].split('.').select { |seg| FUNCTION_SECTIONS.include?(seg) }
    boundaries.each_cons(2) { |parent, child| children[parent] << child unless children[parent].include?(child) }
    own_steps[boundaries.last] << step if boundaries.last
  end

  [children, own_steps]
end

# emit_section_functions(f, node, children, own_steps, ...) - depth-first
#  defines `node`'s own function (its own local steps, in original
#  relative order, then a call to each child that actually ended up with
#  something to do), recursing into children first so a would-be-empty
#  node - every one of its children turned out empty too, and it has no
#  local steps of its own - is detected and skipped rather than emitted
#  as a no-op function or, worse, called by its own parent as a dangling
#  reference to a function that was never defined. Returns whether it
#  emitted itself, which is exactly what the caller (its parent, or
#  write_install_script for the root) needs to decide that.
def emit_section_functions(f, node, children, own_steps, scripts, dialect, state, visited = {})
  return visited[node] if visited.key?(node)

  emitted_children = children[node].select do |child|
    emit_section_functions(f, child, children, own_steps, scripts, dialect, state, visited)
  end

  will_emit = !own_steps[node].empty? || !emitted_children.empty?
  visited[node] = will_emit
  return false unless will_emit

  body = own_steps[node].map { |s| render_step(s, scripts, dialect, state) }.join
  body += emitted_children.map { |c| "#{c}\n" }.join

  f.puts(dialect == 'powershell' ? "function #{node} {" : "#{node}() {")
  f.puts indent_body(body, '  ')
  f.puts '}'
  f.puts ''
  true
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
  # Every generated function - a named script:, a shared provider_<meets>,
  #  or a section like gen_scripts()/lessons() - is defined up front, in
  #  that order, before any of them are actually called: a provider can
  #  call a script: function, and a section can call both a script:
  #  function and a provider, so whichever ran last still has to already
  #  exist. Actually *calling* them happens only at the very end (see
  #  below), in the one order that's always safe regardless of which
  #  functions call which internally - every provider first (each one's
  #  own unit is already dependency-correct - see split_shared), then the
  #  root section (global), which reaches every remaining step through
  #  its own nested calls.
  shared_groups, local_steps = split_shared(steps)
  children, own_steps = section_tree(local_steps)
  state = { apt_updated: false, pacman_synced: false }

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
      emit_script_functions(f, steps, scripts, dialect)
      emit_provider_functions(f, shared_groups, scripts, dialect, state)
      global_emitted = emit_section_functions(f, 'global', children, own_steps, scripts, dialect, state)
      shared_groups.each { |g| f.puts g[:name] }
      f.puts 'global' if global_emitted
      f.puts ''
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
      emit_script_functions(f, steps, scripts, dialect)
      emit_provider_functions(f, shared_groups, scripts, dialect, state)
      global_emitted = emit_section_functions(f, 'global', children, own_steps, scripts, dialect, state)
      shared_groups.each { |g| f.puts g[:name] }
      f.puts 'global' if global_emitted
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
