#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'
require 'optparse'
require_relative 'resolve_order'

# arg_suffix(step) - step[:args] (see resolve_order.rb's own flatten)
#  rendered as a leading-space-prefixed string to splice straight after
#  an install command's own package name, or '' when absent - the
#  general-purpose escape hatch for opaque extra flags (gem's own
#  --platform ruby, pipx's own --include-deps) that don't need the
#  manifest itself to understand them, only pass them through verbatim.
#  Array() accepts either a single string or a list, same normalization
#  apt's own `name:`/append's own `dest:`/`lines:` already get.
def arg_suffix(step)
  args = Array(step[:args]).join(' ')
  args.empty? ? '' : " #{args}"
end

# bash_install/powershell_install - the *dialect-specific* half of a
#  step's install command - just the package-manager invocation for
#  step[:type], nil for a type that dialect doesn't know about ('script'
#  is deliberately absent from both: it's dialect-agnostic, handled once
#  in command_for instead of duplicated in each).
def bash_install(step, tree)
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
  # apt_repository: - a sibling key on this same step (see resolve_
  #  order.rb's own flatten, which reads it directly onto the step, not
  #  as a separate attached one) - `add-apt-repository` itself refreshes
  #  the package index for the new repo by default (no --no-update
  #  passed), so nothing extra is needed before the install line below
  #  sees packages from it. add_apt_repo: is the other, non-PPA way to
  #  add a repo (a raw signed-by key + list file, e.g. Corretto/Docker) -
  #  a *name* into the manifest's own add_apt_repos: block (mirroring
  #  file:/append:'s own name-into-files:/appends: shape), rendered as a
  #  call to the shared add_apt_repo() function instead of a literal
  #  add-apt-repository invocation - see emit_helper_functions for where
  #  that function itself gets defined.
  when 'apt'
    repo = step[:apt_repository] ? "sudo add-apt-repository -y #{step[:apt_repository]}\n" : ''
    if step[:add_apt_repo]
      entry = tree['add_apt_repos'][step[:add_apt_repo]]
      trusted = entry['trusted'] ? 'yes' : ''
      repo += %(add_apt_repo "#{entry['name']}" "#{entry['key_url']}" "#{entry['repo_uri']}" "#{entry['distro_string']}" "#{trusted}"\n)
    end
    "#{repo}sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y #{Array(step[:name]).join(' ')}"
  # -s/--skip-existing - safe to run again if this exact version is
  #  already installed (a repeat/unattended run shouldn't fail or
  #  rebuild from source unnecessarily).
  when 'pyenv'  then "pyenv install -s #{step[:name]}"
  when 'rbenv'  then "rbenv install -s #{step[:name]}"
  # rvm install is itself idempotent (a re-run against an already-
  #  installed version reports it as already present and exits 0, same
  #  as asdf's own install) - no --skip-existing-style flag needed. The
  #  "make this the default" step is the manifest's own sibling `cmd:`
  #  (rvm use ... --default), appended automatically by command_for,
  #  same as rbenv/asdf's own cmd: siblings.
  when 'rvm' then "rvm install #{step[:name]}"
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
  # asdf_plugin: "<name> <repo_url>" (e.g. "ruby https://github.com/
  #  asdf-vm/asdf-ruby.git") - `asdf plugin add` itself errors out if
  #  the plugin's already registered (unlike sdkman/pyenv/rbenv's own
  #  install commands, none of which need an explicit guard for
  #  re-provisioning), so this checks `plugin list` first rather than
  #  relying on --skip-existing-style flag asdf's own `plugin add` has
  #  no equivalent of.
  when 'asdf_plugin'
    plugin, repo = step[:name].split(' ', 2)
    %(asdf plugin list | grep -qx "#{plugin}" || asdf plugin add #{plugin} #{repo})
  # asdf: "<language> <version>" (e.g. "ruby 4.0.6") - `asdf install`
  #  already skips a version that's installed, no --skip-existing-style
  #  flag needed the way pyenv/rbenv's own `-s`/`--skip-existing` is.
  #  Setting it as the active version (asdf's own `set -u`/`global`) is
  #  a separate concern, same as pyenv/rbenv's own `cmd:` sibling for
  #  "make this the default" - not this step's own job.
  when 'asdf' then "asdf install #{step[:name]}"
  when 'gem'    then "gem install #{step[:name]}#{arg_suffix(step)}"
  when 'pipx'   then "pipx install #{step[:name]}#{arg_suffix(step)}"
  # pwsh, not native PowerShell - a bash-dialect platform (ubuntu2204.yml)
  #  reaches PowerShellGet through the same `pwsh -NoProfile -Command
  #  "..."` wrapper powershell_cmd itself uses below, not a bare
  #  Install-Module call - there's no PowerShell interpreter running
  #  this script itself to invoke it directly. -Force covers the
  #  untrusted-PSGallery prompt on its own (see powershell_cmd's own
  #  Set-PSRepository/Install-Module example) - no separate repository-
  #  trust step needed for a module install on its own.
  when 'powershell_package_provider'
    _, ver = parse_version_constraint(step)
    version_flag = ver ? " -MinimumVersion #{ver}" : ''
    %(pwsh -NoProfile -Command "Install-PackageProvider -Name #{step[:name]}#{version_flag} -Force")
  when 'powershell_module'
    %(pwsh -NoProfile -Command "Install-Module -Name #{step[:name]}#{arg_suffix(step)} -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber")
  # powershell_cmd - one raw PowerShell command/expression, run through
  #  the same `pwsh -NoProfile -Command "..."` wrapper as powershell_
  #  package_provider/powershell_module above (this dialect has no
  #  PowerShell interpreter of its own running the script), for the
  #  cases those two dedicated types don't cover (e.g. `Set-PSRepository
  #  -Name PSGallery -InstallationPolicy Trusted` - trusting a
  #  repository, not installing a provider or a module). Prefer
  #  powershell_module/powershell_package_provider when either actually
  #  fits - this is the escape hatch for everything else, the same
  #  relationship bash_install's own bare `cmd:` type has to every
  #  dedicated package type. Unlike `cmd:` (spelled identically in both
  #  dialects, since the author writes one command that already works
  #  verbatim in both shells), powershell_cmd's own *rendering* genuinely
  #  differs per dialect - bash needs the pwsh wrapper, native
  #  PowerShell doesn't (see powershell_install's own 'powershell_cmd'
  #  case) - only the manifest-authored PowerShell text itself is
  #  shared between them.
  when 'powershell_cmd' then %(pwsh -NoProfile -Command "#{step[:name]}")
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
  # A version-constrained needs: (see resolve_order.rb's own check_
  #  version_needs!) that nothing in the final resolved output actually
  #  satisfies - runs in this step's own original position (same
  #  ordering everything else already has), but as a visible runtime
  #  warning instead of a command that would just fail (or silently
  #  install against too old a dependency) on the box.
  when 'omitted_version_need' then %(echo "WARNING: #{step[:omitted_reason]}" >&2)
  end
end

def powershell_install(step)
  case step[:type]
  when 'choco' then "choco install #{step[:name]} -y"
  when 'gem'   then "gem install #{step[:name]}#{arg_suffix(step)}"
  when 'pipx'  then "pipx install #{step[:name]}#{arg_suffix(step)}"
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
  # pkgbox/chocolatey/<name>/ - a local nuspec source for a package
  #  missing from the community Chocolatey feed (see pkgbox's own
  #  README). Path derived from type+name, never stored in the manifest
  #  itself - nothing here ever needs parsing a path back out of a
  #  string, same reasoning apt_repository/add_apt_repo get their own
  #  key instead of being packed into name:. version: is always an exact
  #  pin here (`=` only, not `>=`) - choco's own --version has no way to
  #  express "at least this version," only "exactly this version," so a
  #  manifest author writing `>= X` for a choco_local step would be
  #  promising behavior this can't actually deliver.
  when 'choco_local'
    op, ver = parse_version_constraint(step)
    if op == '>='
      raise "choco_local '#{step[:name]}': version must be an exact pin ('=' or a bare version) - choco install --version has no floor semantics"
    end

    pkg_dir = "pkgbox/chocolatey/#{step[:name]}"
    version_flag = ver ? %( --version="#{ver}") : ''
    <<~PS1.strip
      choco pack "#{pkg_dir}/#{step[:name]}.nuspec" --output-directory="#{pkg_dir}/vendor"
      choco install #{step[:name]} --source="#{pkg_dir}/vendor"#{version_flag} --yes
    PS1
  # Native Install-PackageProvider/Install-Module - this dialect's whole
  #  script already runs under PowerShell, so no pwsh wrapper is needed
  #  the way bash_install's own equivalents require. -Force covers the
  #  untrusted-PSGallery confirmation on its own for 'powershell_module'
  #  (see the Set-PSRepository/Install-Module discussion this followed).
  when 'powershell_package_provider'
    _, ver = parse_version_constraint(step)
    version_flag = ver ? " -MinimumVersion #{ver}" : ''
    "Install-PackageProvider -Name #{step[:name]}#{version_flag} -Force"
  when 'powershell_module'
    "Install-Module -Name #{step[:name]}#{arg_suffix(step)} -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber"
  # powershell_cmd - see bash_install's own case: the manifest-authored
  #  PowerShell text runs verbatim here, no pwsh wrapper needed (this
  #  dialect's whole script already runs under PowerShell).
  when 'powershell_cmd' then step[:name]
  # See bash_install's own 'omitted_version_need' case.
  when 'omitted_version_need' then %(Write-Warning "#{step[:omitted_reason]}")
  end
end

# file_write(step, tree) - a 'file' step (see resolve_order.rb's own
#  ATTACHABLE_KEYS) as a heredoc write, looked up in the manifest's own
#  files: block by name. The generic, data-driven equivalent of what
#  used to be a hand-written `cat <<'EOF' > $HOME/.zshrc` script body -
#  same heredoc shape, just emitted directly from files:'s own dest:/
#  content: instead of a script author having to write the wrapper by
#  hand each time. content is forced to end in exactly one newline
#  before the terminator - confirmed directly via a real bash syntax
#  error this matters, not just tidiness: a files: entry that happens
#  to be the very last thing in its own YAML file inherits that file's
#  own missing trailing newline (a common editor/save artifact) straight
#  into its own content string, which without this would glue EOF onto
#  the last content line instead of giving it its own - the heredoc
#  terminator then never matches, and bash reads to end-of-file instead.
def file_write(step, tree)
  entry = tree['files'][step[:name]]
  content = entry['content'].end_with?("\n") ? entry['content'] : "#{entry['content']}\n"
  # mkdir -p the destination's own directory first - a heredoc redirect
  #  creates the *file* if missing but never a missing parent directory
  #  (confirmed directly via a real `vagrant provision` failure: the
  #  manifest's own ubuntu22_asdf_ps1 writes to $HOME/.config/powershell/
  #  asdf.ps1, a directory nothing else creates before this step runs
  #  under a narrow --SECTION selection that pulls in asdf's own
  #  global-level unit without win_scripts/rust's own scripts alongside
  #  it - "No such file or directory" from bash's own `>`, not a Ruby-
  #  side bug). Chef's own 'file' case (helpers.rb) already has to do
  #  this for the identical reason - this brings the bash generator to
  #  parity with it rather than leaving file: steps one directory-
  #  existence assumption away from crashing depending on which other
  #  steps happened to run first. File.dirname is purely textual (no
  #  filesystem access at generation time) - safe on a $HOME-containing
  #  path like this one, which doesn't exist as a real directory on the
  #  machine running this generator anyway.
  dir = File.dirname(entry['dest'])
  "mkdir -p \"#{dir}\"\ncat <<'EOF' > #{entry['dest']}\n#{content}EOF"
end

# append_lines(step, tree) - an 'append' step (see resolve_order.rb's
#  own ATTACHABLE_KEYS) as one call to the shared append_line() function
#  (see helpers/common.yml, emitted by emit_helper_functions) per
#  dest/line pair, looked up in the manifest's own appends: block by
#  name. `dest` may be a single path or a list (e.g. both .bashrc and
#  .zshrc) - Array() normalizes either shape the same way bash_install's
#  own apt/pacman cases already do for `name`. The guard-file-exists/
#  grep-guard/`|| true` logic itself lives once in append_line() now,
#  not re-emitted per line here - see common.yml's own comment for why
#  each of those pieces matters.
def append_lines(step, tree)
  entry = tree['appends'][step[:name]]
  Array(entry['dest']).flat_map do |dest|
    Array(entry['lines']).map do |line|
      # Lines like msys2/cygwin_purge_windows_path embed their own single
      #  quotes (tr ':' '\n', grep -vE '^/[a-zA-Z]/', ...). Naively
      #  interpolating `line` inside a '...' wrapper lets those embedded
      #  quotes toggle bash's own quote-parsing mid-string, silently
      #  corrupting what gets written (confirmed directly: produced
      #  `tr : n` instead of `tr ':' '\n'` in a real generated .bashrc).
      #  Standard bash single-quote escaping - close, escaped literal
      #  quote, reopen - keeps the whole line literal regardless of
      #  what it contains.
      quoted = "'" + line.gsub("'") { "'\\''" } + "'"
      %(append_line "#{dest}" #{quoted})
    end
  end.join("\n")
end

# powershell_append_lines(step, tree) - the PowerShell dialect's
#  equivalent of append_lines above: same shape (looked up in appends:
#  by name, dest may be a single path or a list, one call to the shared
#  append_line function - see helpers/common.yml's own cmd_powershell:,
#  emitted by emit_helper_functions - per dest/line pair). dest is
#  wrapped in double quotes so a manifest can use "$PROFILE" itself, not
#  just a literal path - PowerShell double-quoted strings interpolate
#  variables the same way bash's do, so append_line's own $Dest
#  parameter receives the already-expanded path, not the literal text
#  "$PROFILE". Line values are escaped for a PowerShell single-quoted
#  string (a literal quote there is just doubled, not the close/escape/
#  reopen dance bash needs).
def powershell_append_lines(step, tree)
  entry = tree['appends'][step[:name]]
  Array(entry['dest']).flat_map do |dest|
    Array(entry['lines']).map do |line|
      quoted = "'" + line.gsub("'") { "''" } + "'"
      %(append_line "#{dest}" #{quoted})
    end
  end.join("\n")
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
#  `tree` (the whole parsed manifest, not just its own scripts: block)
#  so 'file'/'append' can look themselves up in files:/appends: the
#  same way 'script' already looks itself up in scripts:.
# noop_comment(step) - a 'noop' step's own line: pure documentation, no
#  install command at all - see resolve_order.rb's own PACKAGE_TYPES
#  and flatten comment for why this type exists (a meets:/needs: pair
#  with no actual package on either side to attach to). A `#` comment
#  reads identically in bash and PowerShell, so - unlike file_write/
#  append_lines - this needs no dialect branching of its own.
def noop_comment(step)
  extra = []
  extra << "meets: #{step[:meets]}" if step[:meets]
  extra << "needs: #{Array(step[:needs]).join(', ')}" if step[:needs]
  "# noop#{extra.empty? ? '' : " (#{extra.join(', ')})"}"
end

def command_for(step, tree, dialect)
  install =
    case step[:type]
    # A bare function *call*, not the body - write_install_script's own
    #  emit_script_functions already defined it, once, up front. Still
    #  gated on the body actually existing (not just `step[:name]`
    #  unconditionally), so a typo'd/missing scripts: entry still falls
    #  through to the "unsupported" TODO below instead of generating a
    #  call to a function that was never defined.
    when 'script' then (tree['scripts'].dig(step[:name], 'cmd') ? step[:name] : nil)
    when 'cmd' then step[:name]
    # 'file' stays bash-only for now (heredoc write) - no windows.yml
    #  manifest uses it yet, so there's no PowerShell equivalent to write
    #  here until one actually needs it. 'append' does have both: see
    #  append_lines (bash) / powershell_append_lines (PowerShell) above.
    when 'file' then file_write(step, tree)
    when 'append' then dialect == 'powershell' ? powershell_append_lines(step, tree) : append_lines(step, tree)
    when 'noop' then noop_comment(step)
    else dialect == 'powershell' ? powershell_install(step) : bash_install(step, tree)
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

# emit_script_functions(f, steps, tree, dialect) - defines every
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
def emit_script_functions(f, steps, tree, dialect)
  steps.select { |s| s[:type] == 'script' }.map { |s| s[:name] }.uniq.each do |sname|
    body = tree['scripts'].dig(sname, 'cmd')&.rstrip
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

# emit_helper_functions(f, steps, tree, dialect, helpers) - every shared
#  helper function this script's own steps actually need, defined once
#  up front, before anything calls it - same "define once, call at
#  point of use" shape as emit_script_functions, except these come from
#  a cross-platform scriptbox/config/helpers/<name>.yml (see
#  lineage_for/load_helpers) instead of this platform's own scripts:
#  block, so every platform sharing an OS lineage reuses the same
#  function body instead of each duplicating it. A helper's own cmd:/
#  cmd_powershell: is already a complete, self-contained function
#  definition (unlike scripts:'s own cmd:, which is just a body this
#  wraps in `name() { ... }`) - see helpers/debian.yml's own
#  add_apt_repo. Four ways a step can need one: an add_apt_repo: field,
#  an append: step, or a condition: field naming a test function (this
#  generator's own rendering calls the helper itself - see
#  bash_install's 'apt' case, append_lines/powershell_append_lines, and
#  render_step's own condition-guard wrapping), or a script's own
#  manifest-authored uses: field (the script's *cmd body itself* calls
#  it, which this generator can't see inside that raw string, so the
#  manifest author has to say so explicitly). cmd_powershell: is
#  optional per helper (add_apt_repo has none - nothing on the Windows/
#  PowerShell side uses it yet) - a helper needed only in a dialect it
#  has no body for is silently skipped, same as a helper nobody needs
#  at all.
def emit_helper_functions(f, steps, tree, dialect, helpers)
  return if helpers.nil?

  needed = []
  needed << 'add_apt_repo' if steps.any? { |s| s[:add_apt_repo] }
  needed << 'append_line' if steps.any? { |s| s[:type] == 'append' }
  steps.each { |s| needed << parse_condition(s[:condition]).first if s[:condition] }
  steps.select { |s| s[:type] == 'script' }.map { |s| s[:name] }.uniq.each do |sname|
    needed.concat(Array(tree.dig('scripts', sname, 'uses')))
  end

  key = dialect == 'powershell' ? 'cmd_powershell' : 'cmd'
  needed.uniq.each do |hname|
    body = helpers.dig('helpers', hname, key)&.rstrip
    next unless body

    f.puts body
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

# render_step(step, tree, dialect, insert_before) - one step's full
#  output block (status line + install command + any dialect-specific
#  follow-up), as a single un-indented string ending in a blank line -
#  the same shape write_install_script used to emit directly into the
#  file before steps were grouped into functions, now built once here so
#  provider/section function bodies (see emit_provider_functions/
#  emit_section_functions) all use exactly one implementation.
#  Deliberately does *not* handle the one-time apt-get update/pacman -Syu
#  refresh itself anymore - see write_install_script's own comment on
#  why tracking that here (by which step is generated *first*) went
#  wrong once steps could live inside a function that's defined earlier
#  in the file than one that actually *runs* earlier.
#  step[:condition] (see resolve_order.rb's own parse_condition) wraps
#  just this step's own status/install/choco-extras block - not the
#  insert_before calls ahead of it, which are relocated *other* steps'
#  own installs and run unconditionally regardless of whether *this*
#  step's own condition holds. `is_vm_guest`-style test functions are
#  shared helpers (see helpers/common.yml, emitted by
#  emit_helper_functions the same way append_line is), called by name -
#  the guard is the bare call for `== true`, a dialect-appropriate
#  negation for `== false`.
def render_step(step, tree, dialect, insert_before = {})
  lines = []
  Array(insert_before[step.object_id]).each { |name| lines << name }

  inner = []
  if dialect == 'powershell'
    inner << "Write-Host '==> [#{step[:path]}] #{step[:type]}: #{step[:name]}'"
    inner << command_for(step, tree, dialect)
    if step[:type] == 'choco'
      inner << 'Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"'
      inner << 'Update-SessionEnvironment'
    end
  else
    inner << "echo '==> [#{step[:path]}] #{step[:type]}: #{step[:name]}'"
    inner << command_for(step, tree, dialect)
  end

  if step[:condition]
    fn_name, expected = parse_condition(step[:condition])
    body = indent_body("#{inner.join("\n")}\n", '  ').rstrip
    if dialect == 'powershell'
      lines << "if (#{expected ? fn_name : "-not (#{fn_name})"}) {"
      lines << body
      lines << '}'
    else
      lines << "if #{expected ? fn_name : "! #{fn_name}"}; then"
      lines << body
      lines << 'fi'
    end
  else
    lines.concat(inner)
  end

  "#{lines.join("\n")}\n\n"
end

# emit_provider_functions(f, groups, tree, dialect) - defines each
#  relocate_cross_cutting group as its own function, up front - *defines*
#  only. Nothing here calls one: a relocated provider is only ever
#  called from the specific consumer(s) that actually needed it moved
#  (see render_step's own insert_before, wired up inside
#  emit_section_functions) - never a separate "run every provider first"
#  pre-phase, which would just reintroduce the same implicit-ordering
#  break this whole mechanism exists to avoid (see resolve_order.rb's
#  own relocate_cross_cutting comment).
def emit_provider_functions(f, groups, tree, dialect)
  groups.each do |group|
    f.puts(dialect == 'powershell' ? "function #{group[:name]} {" : "#{group[:name]}() {")
    body = group[:steps].map { |s| render_step(s, tree, dialect) }.join
    f.puts indent_body(body, '  ')
    f.puts '}'
    f.puts ''
  end
end

# section_tree(steps, claimed) - groups every not-claimed step (see
#  resolve_order.rb's relocate_cross_cutting - a claimed step has been
#  pulled out to run somewhere else entirely) by owning_function, and
#  records which function calls which. A step's own path, e.g. "global.
#  lessons.gen_scripts.groovy", filtered down to just its
#  FUNCTION_SECTIONS segments ("global", "lessons", "gen_scripts") and
#  taken pairwise, says lessons is gen_scripts' own parent - derived
#  from each file's actual tree shape, not hardcoded, so this comes out
#  right even for windows.yml's own quirk of nesting cibox/scriptbox/
#  testbox under lessons instead of directly under global like every
#  other platform's config (reflects the manifest as actually written,
#  rather than silently reshaping it to match the others).
def section_tree(steps, claimed)
  children = Hash.new { |h, k| h[k] = [] }
  own_steps = Hash.new { |h, k| h[k] = [] }

  steps.each_with_index do |step, i|
    next if claimed[i]

    boundaries = step[:path].split('.').select { |seg| FUNCTION_SECTIONS.include?(seg) }
    boundaries.each_cons(2) { |parent, child| children[parent] << child unless children[parent].include?(child) }
    own_steps[boundaries.last] << step if boundaries.last
  end

  [children, own_steps]
end

# emit_section_functions(f, node, children, own_steps, ..., insert_before,
#  ...) - depth-first defines `node`'s own function (its own local
#  steps, in original relative order - each one preceded by a call to
#  whatever relocate_cross_cutting says must run immediately before it,
#  see render_step's own insert_before - then a call to each child that
#  actually ended up with something to do), recursing into children
#  first so a would-be-empty node - every one of its children turned out
#  empty too, and it has no local steps of its own - is detected and
#  skipped rather than emitted as a no-op function or, worse, called by
#  its own parent as a dangling reference to a function that was never
#  defined. Returns whether it emitted itself, which is exactly what the
#  caller (its parent, or write_install_script for the root) needs to
#  decide that.
def emit_section_functions(f, node, children, own_steps, tree, dialect, insert_before, visited = {})
  return visited[node] if visited.key?(node)

  emitted_children = children[node].select do |child|
    emit_section_functions(f, child, children, own_steps, tree, dialect, insert_before, visited)
  end

  will_emit = !own_steps[node].empty? || !emitted_children.empty?
  visited[node] = will_emit
  return false unless will_emit

  body = own_steps[node].map { |s| render_step(s, tree, dialect, insert_before) }.join
  body += emitted_children.map { |c| "#{c}\n" }.join

  f.puts(dialect == 'powershell' ? "function #{node} {" : "#{node}() {")
  f.puts indent_body(body, '  ')
  f.puts '}'
  f.puts ''
  true
end

# write_install_script(name, steps, tree, dialect, generated_dir,
#  header_lines, natural_steps, apt_mirror, out_path:) - writes
#  generated/<name>_install.<ext> in the given dialect, shared by
#  generate_install_script.rb's and gen_installer.rb's own entry points
#  so the two never drift into writing the file header/footer two
#  different ways. `tree` - the whole parsed manifest, not just its own
#  scripts: block - so command_for's own 'file'/'append' cases can
#  reach files:/appends: the same way 'script' already reaches
#  scripts:, without every function in this call chain needing its own
#  extra parameter as more of these named-lookup blocks get added.
#  `natural_steps` - a flatten() snapshot taken *before* topological_
#  order reorders anything - has to come from the caller: topological_
#  order has already mutated `steps` in place by the time it reaches
#  here, and
#  relocate_cross_cutting needs the tree's original, undisturbed
#  document order (see its own comment, and resolve_order.rb's
#  natural_function_order). `apt_mirror` - see apt_mirror_for - is
#  optional. `out_path:` - see each entry point's own --output flag -
#  overrides the default generated/<name>_install.<ext> location
#  entirely (any path, not just a different filename in the same
#  directory) when a caller wants the result somewhere else, e.g.
#  running two --select variants side by side without one overwriting
#  the other. Its parent directory is created the same way generated_
#  dir already is for the default case - a caller passing a brand new
#  subdirectory shouldn't have to mkdir_p it themselves first.
#  PowerShell gets a real self-elevation check up front rather than a
#  comment reminding the user to run it as Administrator - confirmed
#  directly every choco/feature step in practice needs it, and Start-
#  Process -Verb RunAs relaunching itself once at the top is simpler
#  and more reliable than trying to elevate per step. Returns the path
#  written.
def write_install_script(name, steps, tree, dialect, generated_dir, header_lines, natural_steps, apt_mirror = nil, out_path: nil)
  ext = dialect == 'powershell' ? 'ps1' : 'sh'
  out_path ||= File.join(generated_dir, "#{name}_install.#{ext}")
  FileUtils.mkdir_p(File.dirname(out_path))
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
  # Every generated function - a named script:, a relocated
  #  provider_<meets>, or a section like gen_scripts()/lessons() - is
  #  defined up front, in that order, before any of them are actually
  #  called, since any of them can call any other. Actually *calling*
  #  one only happens in two places: a relocated provider is called from
  #  inside whichever specific consumer needed it moved (see
  #  emit_section_functions' own insert_before), and the root section
  #  (global) is called once at the very end, reaching every other step
  #  through its own nested calls.
  natural_order = natural_function_order(natural_steps)
  groups, claimed, insert_before = relocate_cross_cutting(steps, natural_steps, natural_order)
  children, own_steps = section_tree(steps, claimed)
  helpers = load_helpers(lineage_for(tree, name))

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
      emit_script_functions(f, steps, tree, dialect)
      emit_helper_functions(f, steps, tree, dialect, helpers)
      emit_provider_functions(f, groups, tree, dialect)
      global_emitted = emit_section_functions(f, 'global', children, own_steps, tree, dialect, insert_before)
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
      # Swaps the mirror host/path in every sources.list line, whatever
      #  it currently is, for apt_mirror - has to run before the
      #  unconditional apt-get update just below, not as an ordinary
      #  package step (see apt_mirror_for's own comment on why).
      #  Confirmed directly against a real failing mirror before
      #  encoding this pattern.
      if apt_mirror && steps.any? { |s| s[:type] == 'apt' }
        mirror = apt_mirror.end_with?('/') ? apt_mirror : "#{apt_mirror}/"
        f.puts "echo '==> switching apt mirror to #{mirror}'"
        f.puts "sudo sed -i -E 's#https?://[a-zA-Z0-9.-]+/ubuntu/##{mirror}#g' /etc/apt/sources.list"
        f.puts ''
      end
      # Unconditional, once, right at the top - *not* injected just
      #  before whichever apt/pacman step happens to need it (the old
      #  approach): once steps could be relocated into a function that's
      #  *defined* earlier in this file than one that actually *runs*
      #  earlier (see provider_java, whose own apt: step used to get
      #  generated - and therefore flagged as "already refreshed" -
      #  before global()'s own, earlier-running `apt: zsh` step), there
      #  is no single generation-order position that's reliably "the
      #  first apt/pacman step to actually execute" for every config
      #  shape. Running the refresh unconditionally up front is what a
      #  provisioning script would do anyway, and it's cheap and
      #  idempotent - no correctness cost for the configs that don't
      #  need it at all.
      if steps.any? { |s| s[:type] == 'apt' }
        f.puts "echo '==> apt-get update (refresh package index)'"
        f.puts 'sudo apt-get update'
        f.puts ''
      end
      if steps.any? { |s| s[:type] == 'pacman' }
        f.puts "echo '==> pacman -Syu (refresh package database)'"
        f.puts 'pacman -Syu --noconfirm'
        f.puts ''
      end
      emit_script_functions(f, steps, tree, dialect)
      emit_helper_functions(f, steps, tree, dialect, helpers)
      emit_provider_functions(f, groups, tree, dialect)
      global_emitted = emit_section_functions(f, 'global', children, own_steps, tree, dialect, insert_before)
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

# apt_mirror_for(tree, name) - the URL from an optional 'apt_mirror:' key
#  (same sibling position as 'shell:' - see dialect_for), or nil. Exists
#  because a box's own default apt mirror can be unreliable (confirmed
#  directly: generic/ubuntu2204's default, mirrors.edge.kernel.org,
#  intermittently 404'd on real packages and, on a later run, was
#  outright unreachable - "No route to host" - for the exact same host)
#  and the fix has to run *before* write_install_script's own
#  unconditional apt-get update, not as an ordinary package step inside
#  the tree - a normal step only ever runs from within global()'s own
#  call chain, which happens after that preamble update already ran.
def apt_mirror_for(tree, name)
  node = tree[name]
  node.is_a?(Hash) ? node['apt_mirror'] : nil
end

# lineage_for(tree, name) - this platform's own OS lineage (e.g.
#  'debian' for Ubuntu - see scriptbox/config/env.yml's own
#  environments: entries), used to pick which scriptbox/config/helpers/
#  <name>.yml file(s) this platform's generated script can pull shared
#  functions from (see load_helpers) - author-declared there, not
#  detected here or at runtime (no /etc/os-release probing at
#  generation time). Normally a single value - most package-install-
#  level helpers (add_apt_repo, ...) are already correct for the whole
#  Debian family, Ubuntu included, with nothing Ubuntu-specific needed.
#  A list is also accepted (most-specific first, mirroring how /etc/
#  os-release's own ID+ID_LIKE would chain - e.g. ['ubuntu', 'debian']),
#  for the rarer case a real Ubuntu-only tier is actually needed (e.g.
#  client-server config like firewalls, where real per-distro
#  differences show up - not a concern for simple package installs). A
#  merged tree (gen_installer.rb's own load_merged_config) already has
#  tree['environments'] populated; a direct, single-file
#  `generate_install_script.rb <config.yml>` invocation doesn't merge
#  env.yml in, so this falls back to reading it directly as a
#  well-known sidecar next to this very script - keeps both entry
#  points consistent without gen_installer.rb's own full multi-file
#  merge semantics leaking in here.
# 'common' is always appended, least-specific, regardless of what (if
#  anything) a platform declares - see helpers/common.yml's own
#  append_line: unlike add_apt_repo, it isn't tied to any one OS family
#  (Ubuntu, cygwin, and msys2 manifests all use append: steps), so every
#  bash-dialect platform picks it up here rather than each family's own
#  lineage having to name it explicitly.
def lineage_for(tree, name)
  environments = tree['environments']
  if environments.nil?
    env_path = File.join(__dir__, '..', 'config', 'env.yml')
    environments = File.exist?(env_path) ? YAML.load_file(env_path)['environments'] : nil
  end
  entry = Array(environments).find { |e| e['platform'] == name }
  lineage = entry ? Array(entry['lineage']) : []
  lineage + ['common']
end

# load_helpers(lineage) - every helper from every scriptbox/config/
#  helpers/<name>.yml in `lineage` (see lineage_for) that actually
#  exists, merged into one {'helpers' => {name => {'cmd' => ...}}} - nil
#  if none of `lineage`'s entries have a helpers file (debian.yml and
#  common.yml are the only two so far; lineage_for always includes
#  'common', so in practice this is only ever nil for a platform whose
#  lineage entry somehow doesn't resolve at all). Merged least-specific
#  first, so a *more* specific file's own helper of the same name wins
#  if `lineage` ever has more than one entry - it's already
#  most-specific-first (lineage_for appends 'common' last), so this
#  walks it in reverse.
def load_helpers(lineage)
  return nil if lineage.nil? || lineage.empty?

  merged = {}
  lineage.reverse_each do |name|
    path = File.join(__dir__, '..', 'config', 'helpers', "#{name}.yml")
    next unless File.exist?(path)

    data = YAML.load_file(path)[name]
    merged.merge!(data['helpers']) if data && data['helpers']
  end
  merged.empty? ? nil : { 'helpers' => merged }
end

# root_key - the platform key a config file is about (e.g. "macos",
#  "windows"). Every config file has exactly one of these alongside its
#  "scripts" block; anything else is a malformed file, so fail fast
#  rather than silently guessing which key to use.
def root_key(tree)
  candidates = tree.keys - RESERVED_KEYS
  if candidates.size != 1
    warn "#{$PROGRAM_NAME}: expected exactly one top-level key besides #{RESERVED_KEYS.join('/')}, found: #{candidates.join(', ')}"
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

# print_usage(stream) - shared between --help (stdout, exit 0) and a
#  missing config_path (stderr, exit 1) - same message either way, just
#  a different destination/exit status depending on whether the user
#  actually asked for it or just forgot an argument.
def print_usage(stream)
  stream.puts "usage: #{$PROGRAM_NAME} <config.yml> [SECTION ...] [--select TAG,TAG] [--exclude TAG,TAG] [--output PATH]"
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
  stream.puts ''
  stream.puts '  --select TAG,TAG - opt in to a tagged alternative (e.g. rbenv/pyenv/'
  stream.puts '    asdf_ruby/asdf_python vs. Ubuntu\'s own system ruby/python) - see'
  stream.puts '    resolve_order.rb\'s own tag_eligible?/resolve_included (issue #16).'
  stream.puts '    An untagged entry always runs regardless. A tagged entry runs if'
  stream.puts '    it carries the literal tag \'default\' (the manifest author\'s own'
  stream.puts '    declared fallback where no untagged alternative exists), at least'
  stream.puts '    one of its own tags is named here, or something already running'
  stream.puts '    needs: it.'
  stream.puts '  --exclude TAG,TAG - veto a tag even over --select/default.'
  stream.puts '  --output PATH - write here instead of generated/<platform>_install.<ext>'
  stream.puts '    (any path, not just a different filename - its parent directory is'
  stream.puts '    created if missing).'
end

if __FILE__ == $PROGRAM_NAME
  if %w[-h --help].include?(ARGV.first)
    print_usage($stdout)
    exit 0
  end

  options = { select: [], exclude: [], output: nil }
  OptionParser.new do |opts|
    opts.on('--select TAGS') { |v| options[:select] = v.split(',').map(&:strip) }
    opts.on('--exclude TAGS') { |v| options[:exclude] = v.split(',').map(&:strip) }
    opts.on('--output PATH', 'write here instead of generated/<platform>_install.<ext>') { |v| options[:output] = v }
  end.parse!(ARGV)

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
  name = root_key(tree)
  # Substitutes across the *whole* tree, not just tree[name] - even
  #  though variables: itself lives nested inside the platform's own
  #  root key (see resolve_order.rb's own RESERVED_KEYS comment on why
  #  that part is scoped per-platform), scripts:/files:/appends: are
  #  themselves top-level RESERVED_KEYS blocks, siblings of tree[name],
  #  not nested inside it - a <%= $name %> reference in a script body
  #  (e.g. ubuntu22_asdf's own `ASDF_VERSION="<%= $asdf_ver %>"`) sat
  #  there unsubstituted, verbatim, in every generated output until
  #  this was widened from tree[name] alone - confirmed directly, not
  #  theoretical: `grep ASDF_VERSION generated/ubuntu22_install.sh`
  #  showed the literal template text, not a version number, before
  #  this fix. Values still come from just this one platform's own
  #  variables: block - a name only a *different* platform's own
  #  scripts: entry happened to reference would still raise (no such
  #  manifest does today).
  tree = substitute_variables(tree, tree[name]['variables'] || {})

  # Order matters here: resolve_included (issue #16 tag-activation,
  #  hierarchy expansion, and SECTION-selector narrowing, all in one
  #  pass) runs first, on the *full* list, for the same reason
  #  topological_order itself needs the full list before dedup! narrows
  #  it - a filtered-then-ordered order would let topological_order see
  #  (and possibly relocate) a `meets:` provider that resolve_included
  #  was always going to drop in favor of its selected/default
  #  alternative, corrupting the very ordering topological_order is
  #  supposed to guarantee. topological_order runs on the now-filtered
  #  list next; dedup! runs *last*, within just that filtered set -
  #  confirmed directly running dedup! before selection is wrong, not
  #  just reordered differently: selecting a single section (e.g. just
  #  "testbox") could lose a step entirely if dedup! had already kept
  #  some *other*, unselected section's identical step as the "first"
  #  occurrence instead.
  steps = flatten(tree[name])
  # Snapshotted before resolve_included/topological_order mutate/filter
  #  steps' own order - see write_install_script's own comment on why -
  #  a filtered `steps` may not include every natural-order sibling
  #  relocate_cross_cutting's own prefix walk looks for.
  natural_steps = steps.dup
  steps, omitted = resolve_included(steps, options[:select], options[:exclude], selectors: expand_selectors(ARGV[1..]))
  topological_order(steps)
  dedup!(steps)
  version_omitted = check_version_needs!(steps)

  generated_dir = File.join(__dir__, '..', 'generated')
  FileUtils.mkdir_p(generated_dir)
  dialect = dialect_for(tree, name)
  header_lines = [
    "Generated from #{config_path} by #{$PROGRAM_NAME} - do not edit by hand.",
    'Installs everything in the file, in dependency-resolved order.'
  ]
  # See resolve_order.rb's own resolve_included - a step whose own needs:
  #  had no eligible provider at all (not just "wasn't selected this
  #  run") got dropped rather than emitted as a command guaranteed to
  #  fail; surfaced here instead of silently disappearing.
  omitted.each do |step, missing|
    header_lines << "Omitted: [#{step[:path]}] #{step[:type]}: #{step[:name]} - needs '#{missing}', no eligible provider (check --select/--exclude, or the manifest's own default tags)"
  end
  # See resolve_order.rb's own check_version_needs! - unlike the plain
  #  omission above (dropped from the output entirely), these steps are
  #  still present and still run, just as a runtime warning instead of
  #  the install they can't actually satisfy - noted here too so it's
  #  visible without having to read the whole generated script.
  version_omitted.each do |step|
    header_lines << "Omitted (version): #{step[:omitted_reason]}"
  end
  out_path = write_install_script(name, steps, tree, dialect, generated_dir, header_lines, natural_steps, apt_mirror_for(tree, name), out_path: options[:output])
  puts "wrote #{out_path}"
end
