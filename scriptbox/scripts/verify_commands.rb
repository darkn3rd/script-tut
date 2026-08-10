#!/usr/bin/env ruby
# verify.rb - reports what's actually on PATH for every language this
#  project's lesson areas cover (win_scripts, shell_scripts, gen_scripts,
#  compiled_lang), plus each language's own dependent tooling (e.g. `bc`/
#  `getopt` for the shell lessons' arithmetic/flags lessons, `cpanm` for
#  Perl's Switch module, `make` for every compiled language) - a quick
#  "is this box actually set up to run the test suite" check, independent
#  of testbox/Script.rb's own environment-detection machinery (this never
#  needs to resolve *one* language for the directory it's sitting in the
#  way Script.rb does - it enumerates all of them at once).
#
#  Usage: ruby verify.rb [--format text|json|yaml|csv|tui]
#  (defaults to tui when run at a terminal, text otherwise)

require 'optparse'
require 'json'
require 'yaml'

# AREAS - the four lesson areas (lessons/win_scripts, shell_scripts,
#  gen_scripts, compiled_lang), each language's candidate binary name(s)
#  (tried in order, first found wins - e.g. python3 before the bare
#  "python" some systems alias to python2), how to probe its version, and
#  any dependent tooling a lesson in that language actually shells out to
#  (confirmed directly by grep, not guessed - see gen_scripts/perl and
#  shell_scripts' own c2x/o2x lessons; compiled_lang's `make` need is
#  documented directly in compiled_lang/README.md).
AREAS = [
  {
    name: 'Windows Scripts',
    languages: [
      # ".exe" candidates listed first and explicitly, not left to
      #  find_on_path's own PATHEXT-driven extension search - confirmed
      #  directly this matters under WSL1: a bare "cmd" there finds
      #  /usr/local/bin/cmd (this project's own wsl1-run wrapper, not a
      #  real interpreter to report on), while "cmd.exe" correctly finds
      #  the real /mnt/c/Windows/system32/cmd.exe instead. cmd/cscript
      #  have no native Linux port to prefer at all, so reaching for
      #  the Windows one first is always right for them - PowerShell is
      #  the one exception: confirmed directly, WSL1's Ubuntu has a
      #  genuine native `pwsh` (`which pwsh` -> /usr/bin/pwsh, a real,
      #  fully-functional PowerShell build, not any kind of wrapper), so
      #  it gets the opposite order - bare name first, matching how
      #  every other Shell/General Scripts tool already prefers native
      #  over reaching into /mnt/c for the Windows one.
      # "coreutils" in each tool entry is a search-only hint, same
      #  reasoning as TCL's own "tcl"/Java's own "jvm" - confirmed
      #  directly neither "date" nor "grep" shares any substring with
      #  the real package id "mscoreutils" at all, but
      #  `choco list coreutils --by-tags-only` finds it unambiguously.
      # native_tools: true - date/grep have to be reachable via
      #  cmd.exe's own real PATH, not wherever Ruby happens to be
      #  running from - confirmed directly a Cygwin /usr/bin/date.exe
      #  resolves fine from Ruby's own inherited PATH but is invisible
      #  to a real Batch script, which runs under cmd.exe and never
      #  sees Cygwin's /usr/bin at all. See windows_native_path_dirs.
      { name: 'Batch',        bin: %w[cmd.exe cmd],                             version: :cmd, tools: [%w[date coreutils], %w[grep coreutils]], native_tools: true, windows_only: true },
      # :psake - the win_scripts/powershell lessons run through
      #  Invoke-Psake (see run_all_tests.ps1) - unlike every other
      #  "tools" entry, psake isn't a real executable at all (no
      #  psake.exe/psake lands on PATH - Install-Module just drops
      #  .psd1/.psm1 files under pwsh's own module path), so it can't be
      #  found via find_on_path/resolve_entry the normal way - see
      #  resolve_psake_module, dispatched on this exact symbol.
      { name: 'PowerShell',   bin: %w[pwsh powershell pwsh.exe powershell.exe], version: :powershell, tools: [:psake] },
      { name: 'WSH JScript',  bin: %w[cscript.exe cscript],                     version: :cscript, windows_only: true },
      { name: 'WSH VBScript', bin: %w[cscript.exe cscript],                     version: :cscript, windows_only: true },
    ]
  },
  {
    name: 'Shell Scripts',
    languages: [
      { name: 'Bourne Again Shell (bash)', bin: %w[bash],      version: :flag, tools: %w[bc getopt], unix_only: true },
      { name: 'C Shell (tcsh)',            bin: %w[tcsh csh],  version: :flag, tools: %w[bc], unix_only: true },
      { name: 'Korn Shell (ksh)',          bin: %w[ksh],       version: :ksh_env, tools: %w[bc], unix_only: true },
      { name: 'POSIX Shell (dash/sh)',     bin: %w[dash sh],   version: :flag, tools: %w[bc getopt perl], unix_only: true },
      { name: 'Z Shell (zsh)',             bin: %w[zsh],       version: :flag, tools: %w[bc], unix_only: true },
    ]
  },
  {
    name: 'General Scripts',
    languages: [
      { name: 'AWK',     bin: %w[gawk awk],       version: :flag },
      { name: 'Groovy',  bin: %w[groovy],         version: :flag, tools: %w[java] },
      { name: 'Perl',    bin: %w[perl],           version: :flag, tools: %w[cpanm] },
      { name: 'PHP',     bin: %w[php],            version: :flag },
      { name: 'Python2', bin: %w[python2],        version: :flag },
      { name: 'Python3', bin: %w[python3 python], version: :flag },
      { name: 'Ruby',    bin: %w[ruby],           version: :flag, tools: %w[rake] },
      # "tcl" here is never actually found as a real executable (there's
      #  no tcl.exe on Windows) - it's included purely to widen the
      #  Chocolatey tag-search net (see chocolatey_owner/choco_tag_owner):
      #  confirmed directly `choco list tclsh --by-tags-only` matches
      #  nothing, but `choco list tcl --by-tags-only` finds
      #  "magicsplat-tcl-tk" - resolve_binary already skips straight past
      #  it to "tclsh" since that resolves first, at zero extra cost.
      { name: 'TCL',     bin: %w[tclsh tcl],     version: :tcl },
    ]
  },
  {
    name: 'Compiled Languages',
    languages: [
      { name: 'C++',   bin: %w[g++ clang++ cl],  version: :flag,    tools: %w[make] },
      { name: 'C#',    bin: %w[dotnet],          version: :flag,    tools: %w[make] },
      { name: 'Go',    bin: %w[go],              version: :go,      tools: %w[make] },
      # "jvm" here is never actually found as a real executable, same
      #  reasoning as TCL's own "tcl" - confirmed directly `choco list
      #  java --by-tags-only` returns 4 ambiguous hits (corretto17jdk,
      #  groovy, vscode, vscode.install - declined by choco_tag_owner's
      #  own single-hit requirement), but `choco list jvm --by-tags-only`
      #  finds exactly "corretto17jdk", unambiguously.
      { name: 'Java',  bin: %w[javac java jvm],  version: :java,    tools: %w[make] },
      { name: 'Rust',  bin: %w[rustc],           version: :flag,    tools: %w[make] },
    ]
  },
].freeze

# native_windows_ruby?() - true only for a real native (mingw/MSVC)
#  Windows Ruby, whose Kernel#` is cmd.exe-backed - false for a
#  genuinely POSIX-backed Ruby (Cygwin, WSL1, Linux, macOS), even one
#  running on Windows. Gem.win_platform? alone doesn't draw this line -
#  confirmed directly, it's also true under Cygwin - and the two
#  backtick backends need different quoting for anything with a literal
#  "$" in it (see probe_version's :powershell case).
def native_windows_ruby?
  Gem.win_platform? && RUBY_PLATFORM !~ /cygwin/i
end

# WSL_LAUNCHER_SHIM_PATHS - C:\Windows\System32\bash.exe (and its
#  SysWOW64 twin) isn't a real bash at all - it's WSL's own interactive
#  launcher stub, silently proxying into *whichever* WSL distro happens
#  to be marked default, and which distro that is isn't fixed -
#  confirmed directly reporting it as "Bourne Again Shell (bash)" is
#  actively misleading (its own probed dependents, bc/getopt, then show
#  MISSING, since they're searched for on *this* Windows Ruby's own
#  native PATH, not whatever's on the launched distro's PATH). Struck
#  from candidacy outright, but only on native Windows - a genuine
#  WSL1/WSL2 Ruby (Gem.win_platform? is false there) needs its own real
#  bash to resolve completely normally.
WSL_LAUNCHER_SHIM_PATHS = %w[
  C:\Windows\System32\bash.exe
  C:\Windows\SysWOW64\bash.exe
].freeze

def wsl_launcher_shim?(path)
  Gem.win_platform? && WSL_LAUNCHER_SHIM_PATHS.any? { |shim| path.casecmp?(shim) }
end

# find_on_path(name) - a pure-Ruby PATH scan rather than shelling out to
#  `which`/`where` - this project's whole investigation this session
#  turned up just how inconsistent those external tools' own behavior is
#  across MSYS2/Cygwin/WSL1/native Windows, so this sidesteps all of that
#  entirely and just does the same directory-listing check those tools
#  would, directly.
def find_on_path(name, path_dirs = nil)
  # Gem.win_platform? is false under Cygwin (confirmed directly) even
  #  though it's still a Windows filesystem where every real binary is
  #  a ".exe" underneath - without trying that extension explicitly, a
  #  bare-name search (e.g. "pwsh") still succeeds (Cygwin's own runtime
  #  silently resolves the extension for File.file? even when it's not
  #  in the string), but the extension then never makes it into the
  #  *returned* path, showing an inconsistent "/cygdrive/c/.../pwsh"
  #  next to "/cygdrive/c/.../cmd.exe" (the latter only correct because
  #  AREAS' own candidate already spelled out ".exe" explicitly).
  #  RUBY_PLATFORM directly, not the fuller cygwin_environment? check -
  #  that shells out to `uname` via this same find_on_path, which would
  #  recurse right back into here resolving "uname" itself.
  # !path_dirs.nil? - the only caller that ever passes path_dirs
  #  explicitly is windows_native_path_dirs (Batch's own native_tools,
  #  date/grep) - those directories are inherently Windows-native
  #  regardless of what filesystem *Ruby itself* happens to live on, so
  #  WSL1/WSL2/macOS-via-Wine all need the same PATHEXT-derived
  #  extension search Gem.win_platform?/cygwin already get - confirmed
  #  directly: under WSL2, a real cmd.exe-visible date.exe/grep.exe
  #  (confirmed via `cmd.exe /c where date.exe`) was reported MISSING,
  #  because only a bare "date"/"grep" (no extension) was ever tried.
  windows_fs = Gem.win_platform? || RUBY_PLATFORM =~ /cygwin/i || !path_dirs.nil?
  # PATHEXT's own entries are conventionally uppercase (".EXE;.BAT;...")
  #  - NTFS is case-insensitive so this doesn't affect whether a file is
  #  actually found, but it would otherwise leak into the reported path
  #  as a jarringly-uppercase "cmd.EXE" even though the real file on disk
  #  is "cmd.exe" - downcase these before ever building a candidate. The
  #  bare, extension-less name stays in the list too (tried last, after
  #  the real extensions) rather than replacing it - confirmed directly
  #  this matters even under Cygwin: /usr/bin/ksh is a genuine Cygwin
  #  symlink (`ksh -> mksh.exe`) whose *own* filename carries no
  #  extension at all, same for /usr/bin/python3 (-> /etc/alternatives/
  #  python3, itself another extension-less symlink) - trying only
  #  ".exe"/".bat"/... candidates never finds either, and silently falls
  #  through to an unrelated Windows-side install found later on PATH.
  exts = windows_fs ? (ENV['PATHEXT'] || '.EXE;.BAT;.CMD;.COM').split(';').map(&:downcase) + [''] : ['']
  # `name` may already carry a recognized extension itself (e.g.
  #  "cmd.exe", asked for explicitly - see AREAS' Windows Scripts
  #  candidates) - appending PATHEXT's own extensions on top of that too
  #  would go looking for nonsense like "cmd.exe.exe".
  exts = [''] if exts.any? { |ext| !ext.empty? && name.downcase.end_with?(ext) }
  (path_dirs || ENV['PATH'].to_s.split(File::PATH_SEPARATOR)).each do |dir|
    exts.each do |ext|
      candidate = File.join(dir, "#{name}#{ext}")
      # File.join always uses "/" - normalize to a plain Windows path
      #  (kept as the *real*, executable path - see to_posix for the
      #  MSYS2-POSIX-form conversion, applied only to the report's own
      #  output, never to what actually gets shelled out to).
      candidate = candidate.tr('/', '\\') if Gem.win_platform?
      next if wsl_launcher_shim?(candidate)

      return candidate if File.file?(candidate)
    end
  end
  nil
end

# to_posix(path) - path form for the *report* (called display_path
#  where used for that - see resolve_entry), and also the form
#  package_info's own pacman -Qo lookup needs (an MSYS2-native tool,
#  expecting a POSIX path the same way its own PATH/cwd/argv all are)
#  rather than the Windows form actually used to invoke things. Under
#  MSYS2 (ENV['MSYSTEM'] set) this converts to MSYS2's own POSIX form -
#  the form MSYS2's own shell/tools actually use and a human at an
#  MSYS2 prompt expects to see, extension included (confirmed this
#  should stay rather than trying to match `which`'s own extension-less
#  convention - simpler, and consistent with every path shown, not just
#  ones under a drive mount). Deliberately never fed back into
#  probe_version's own shell_out calls - confirmed directly, a native
#  Windows Ruby's Kernel#` is cmd.exe-backed (see Msys2ShellScript in
#  testbox/Script.rb) and cmd.exe can no more resolve a POSIX path than
#  File.file? can (same underlying reason find_on_path itself has to
#  check existence against the Windows form, never the converted one).
#
#  Shells out to cygpath rather than hand-rolling the conversion -
#  confirmed directly this isn't just "/<lowercase-drive>/..." for every
#  path: MSYS2 mounts its own install root as "/" itself, so anything
#  under it maps *relative to that root* instead
#  ("C:\tools\msys64\usr\bin\make.exe" -> "/usr/bin/make.exe", not
#  "/c/tools/msys64/usr/bin/make.exe"). cygpath already knows that whole
#  mount table authoritatively; reimplementing it here would just be
#  another way to get it subtly wrong.
def to_posix(path)
  return path unless path && Gem.win_platform? && ENV['MSYSTEM']

  cygpath = find_on_path('cygpath')
  return path unless cygpath

  `"#{cygpath}" -u "#{path}" 2>&1`.strip
end

# resolve_binary(candidates, path_dirs = nil) - first candidate name
#  actually found on PATH, tried in the order listed (e.g. python3
#  before bare "python", which some systems alias to python2 instead).
#  path_dirs overrides which directories get searched (see
#  windows_native_path_dirs) - nil means the ordinary ENV['PATH'].
def resolve_binary(candidates, path_dirs = nil)
  candidates.each do |name|
    path = find_on_path(name, path_dirs)
    return [name, path] if path
  end
  [candidates.first, nil]
end

# windows_native_path_dirs - the directories cmd.exe itself actually
#  searches, as opposed to Ruby's own inherited ENV['PATH'] - confirmed
#  directly these diverge under Cygwin: a real /usr/bin/date.exe (GNU
#  coreutils) resolves fine from Ruby's own POSIX-shell-inherited PATH,
#  but a genuine Batch script invoking bare "date" runs under cmd.exe,
#  which never sees Cygwin's /usr/bin at all - reporting that binary as
#  found would be misleading for exactly the audience (Batch script
#  authors) this tool exists to help. Queried once via a real
#  `cmd.exe /c echo %PATH%` subprocess call - the same mechanism a
#  fresh cmd.exe process actually uses, not a guess at it - then
#  converted from cmd.exe's own Windows-form answer to this Ruby's own
#  POSIX form via cygpath (batched, one call for the whole list), the
#  same conversion to_posix already relies on elsewhere in this file.
#  On a native Windows Ruby, ENV['PATH'] already IS what cmd.exe would
#  see (no POSIX shell in between), so this just reuses that directly
#  rather than paying for the extra subprocess call.
def windows_native_path_dirs
  return @windows_native_path_dirs if defined?(@windows_native_path_dirs)

  @windows_native_path_dirs =
    if native_windows_ruby?
      ENV['PATH'].to_s.split(File::PATH_SEPARATOR)
    else
      cmd = find_on_path('cmd.exe') || find_on_path('cmd')
      raw = cmd ? `"#{cmd}" /c echo %PATH% 2>&1`.strip : ''
      # Strips any trailing backslash(es) - confirmed directly a
      #  Windows %PATH% entry commonly ends with one (e.g.
      #  "C:\Windows\System32\"), and interpolating that straight into
      #  a double-quoted shell argument ("...System32\") leaves the
      #  backslash escaping the closing quote itself, not terminating
      #  it - the shell then keeps consuming the rest of the command
      #  line looking for a real closing quote that never comes
      #  ("Unterminated quoted string").
      dirs = raw.split(';').reject(&:empty?).map { |d| d.sub(/\\+\z/, '') }
      # cmd.exe's own answer is always Windows-form ("C:\Windows\...") -
      #  Cygwin's File.file? needs cygpath's POSIX form to check it at
      #  all; WSL1 needs wslpath's /mnt/c/... form for the same reason
      #  (a raw "C:\..." string means nothing to WSL1's own Linux-native
      #  filesystem calls - confirmed directly this isn't optional, not
      #  just cosmetic like to_posix's own MSYS2 conversion is). Neither
      #  tool batches multiple paths the way cygpath's own -u flag does
      #  for wslpath, so WSL1's case converts one directory at a time.
      if (cygpath = find_on_path('cygpath')) && !dirs.empty?
        `"#{cygpath}" -u #{dirs.map { |d| "\"#{d}\"" }.join(' ')} 2>&1`.each_line.map(&:strip)
      elsif (wslpath = find_on_path('wslpath')) && !dirs.empty?
        dirs.map { |d| `"#{wslpath}" -u "#{d}" 2>&1`.strip }
      else
        dirs
      end
    end
rescue StandardError
  @windows_native_path_dirs = []
end

# PACKAGE_CACHE - real path -> {name:, version:} or nil (looked up,
#  genuinely not package-owned) - populated once by prefetch_package_info!
#  before build_report ever walks the AREAS tree for real, so every
#  individual package_info(path) call below just hits this cache instead
#  of shelling out again. Confirmed directly this mattered: a naive
#  per-tool lookup (a fresh pacman -Qo, or worst of all cygcheck -c's
#  own full-package-listing scan, invoked once per tool) took 30-40s
#  across ~20 lookups on MSYS2/Cygwin, against ~1-6s on WSL1/native
#  Windows for the exact same report. pacman -Qo and dpkg -S/-s all
#  accept a whole batch of files/packages in one call - there's no
#  reason to pay each one's own startup cost 20 times over.
PACKAGE_CACHE = {}

# package_info(path) - {name:, version:} from this platform's own
#  package manager (pacman/MSYS2, cygcheck/Cygwin, dpkg/Debian-Ubuntu,
#  or the Cellar path itself for Homebrew/macOS - see lookup_package_info
#  for the priority order), given the file that's *actually* on disk -
#  not guessed from whatever name found it. Confirmed directly this
#  matters: MSYS2's own "ksh" binary is provided by a package literally
#  named "mksh", not "ksh" - the same kind of alias @@command_override
#  already has to handle for python2/python3 in testbox/Script.rb, just
#  discovered from the *package* side instead of the language side here.
#  Preferred over a plain --version probe (see probe_version) precisely
#  because it's package metadata - closer to what `pacman -Qi`/`apt-cyg
#  show`/`brew info` themselves report than a tool's own (sometimes
#  missing, see dash; sometimes needlessly verbose, see mksh's/real
#  ksh93's own --version banner - confirmed directly this affects macOS
#  too, wherever ksh93 is actually the resolved implementation) self-
#  reported version string. nil if no package manager is available, or
#  `path` isn't a package-owned file at all (manually placed, or built
#  from source).
#
#  A cached "not owned" (nil) answer must short-circuit here without
#  falling through to lookup_package_info's own individual, un-batched
#  shell-out - that's exactly the per-tool cost prefetching exists to
#  avoid. Hash#fetch-with-a-block *reads* an already-cached nil
#  correctly (its block only runs on a genuine key miss), but it never
#  *writes* the block's own result back into the hash - confirmed
#  directly this was a real gap: two languages resolving to the exact
#  same not-package-owned file (e.g. WSH JScript and VBScript both
#  landing on the identical cscript.exe) each re-ran the same
#  individual lookup from scratch instead of the second one being a
#  cache hit. key?/[]= here instead of fetch's block form is what
#  actually persists a fresh lookup - found *or* nil - for next time.
def package_info(path, candidates = nil)
  return nil unless path

  real = realpath(macos_java_home_binary(path) || path)
  return PACKAGE_CACHE[real] if PACKAGE_CACHE.key?(real)

  # `path` (pre-realpath) is passed through too - see apt_owner's own
  #  comment on Debian/Ubuntu's "usrmerge", where dpkg's database can
  #  disagree with what realpath resolves to.
  PACKAGE_CACHE[real] = lookup_package_info(real, candidates, path)
end

# realpath(path) - a package manager tracks the *real* file it
#  installed, not necessarily the name resolve_binary found it under -
#  confirmed directly, WSL1's /usr/bin/ksh is a symlink to
#  /usr/bin/ksh93 (the package "ksh93u+m" owns the target, dpkg -S on
#  the symlink itself finds nothing at all). A no-op for anything that
#  isn't a symlink, so resolving unconditionally is safe for the
#  already-working pacman/cygcheck cases too.
def realpath(path)
  File.realpath(path)
rescue StandardError
  path
end

# USRMERGE_PREFIXES - modern Debian/Ubuntu ("usrmerge") replaces /bin
#  and /sbin with directory-level symlinks into /usr/bin and /usr/sbin -
#  realpath resolves straight through those, but dpkg's own database
#  still records file ownership under whichever pre-merge form the
#  package was actually built to install into. Confirmed directly with
#  two different binaries: dash is recorded as "/bin/dash" (one
#  symlink hop, /bin itself); ksh93u+m's own ksh93 binary is recorded
#  as "/bin/ksh93", but reaching it via "ksh" goes through an
#  update-alternatives symlink first (/bin/ksh -> /etc/alternatives/ksh
#  -> /bin/ksh93) - realpath resolves *all* of that, landing on
#  "/usr/bin/ksh93", two hops past what dpkg has on record rather than
#  the usrmerge hop alone.
USRMERGE_PREFIXES = {
  '/usr/bin/' => '/bin/',
  '/usr/sbin/' => '/sbin/'
}.freeze

# usrmerge_variant(path) - the pre-usrmerge form of `path` (see
#  USRMERGE_PREFIXES), or nil if it doesn't start with one of the
#  merged prefixes at all.
def usrmerge_variant(path)
  USRMERGE_PREFIXES.each do |merged, original|
    return original + path.delete_prefix(merged) if path.start_with?(merged)
  end
  nil
end

# macos_java_home_binary(path) - macOS's own /usr/bin/java and
#  /usr/bin/javac are Apple-provided launcher stubs, not symlinks -
#  confirmed directly, realpath on either just returns the same
#  unchanged /usr/bin/... path, so a Homebrew-installed OpenJDK behind
#  them (registered under /Library/Java/JavaVirtualMachines, exactly as
#  Homebrew's own openjdk formula caveats instruct) stays invisible to
#  homebrew_owner's path-based matching - there's no symlink chain to
#  walk at all. `java_home` is the one Apple-provided tool that actually
#  knows which JDK those stubs currently resolve to; re-pointing lookup
#  at its real bin/ directory (still just an ordinary path, realpath'd
#  the normal way immediately afterwards) is what lets a Homebrew JDK
#  show up the same way every other Homebrew tool already does.
def macos_java_home_binary(path)
  return nil unless RUBY_PLATFORM =~ /darwin/

  name = File.basename(path.to_s)
  return nil unless %w[java javac].include?(name)

  java_home_tool = '/usr/libexec/java_home'
  return nil unless File.exist?(java_home_tool)

  home = `"#{java_home_tool}" 2>&1`.strip
  candidate = File.join(home, 'bin', name)
  File.exist?(candidate) ? candidate : nil
rescue StandardError
  nil
end

# version_manager_owner(real, candidates, original) - the SDKMAN/
#  Chocolatey/rbenv/rustup/pyenv catch-all chain, factored out of
#  lookup_package_info so prefetch_pacman!/prefetch_apt! can also reach
#  it (see their own comments) - none of these five are batch-listable
#  the way pacman/apt are, so there's no bulk prefetch step for them
#  either way; the only thing worth sharing is the chain itself, not
#  when it runs.
def version_manager_owner(real, candidates = nil, original = nil)
  tag_manager(chocolatey_owner(real, candidates), :chocolatey) ||
    tag_manager(sdkman_owner(real), :sdkman) ||
    tag_manager(rbenv_owner(real), :rbenv) ||
    tag_manager(rustup_owner(real, original), :rustup) ||
    tag_manager(pyenv_owner(real), :pyenv)
end

def lookup_package_info(real, candidates = nil, original = nil)
  owner =
    if ENV['MSYSTEM'] && (pacman = find_on_path('pacman'))
      tag_manager(pacman_owner(pacman, real), :pacman)
    elsif cygwin_environment? && (cygcheck = find_on_path('cygcheck'))
      tag_manager(cygcheck_owner(cygcheck, real), :cygcheck)
    elsif (dpkg = find_on_path('dpkg'))
      found = apt_owner(dpkg, real) ||
        (original && original != real && apt_owner(dpkg, original)) ||
        (variant = usrmerge_variant(real)) && apt_owner(dpkg, variant)
      tag_manager(found, :apt)
    else
      tag_manager(homebrew_owner(real), :homebrew) || tag_manager(macos_java_cask(real), :homebrew)
    end
  # SDKMAN, Chocolatey, pyenv, rbenv, and rustup aren't tied to any one
  #  OS's own package manager the way pacman/cygcheck/dpkg/Homebrew
  #  above are, so all five are tried as final catch-alls regardless of
  #  platform or which branch above ran, not as another elsif arm.
  owner || version_manager_owner(real, candidates, original)
end

# tag_manager(owner, manager) - nil-safe stamp of which package manager
#  actually resolved `owner` (one of :pacman/:cygcheck/:apt/:homebrew/
#  :chocolatey/:sdkman/:rbenv/:rustup/:pyenv). lookup_package_info's own
#  if/elsif dispatch is the only place that knows which owner_*
#  function fired - callers further out (format_table, format_tui) just
#  want the tag, not the dispatch logic that produced it. See
#  MANAGER_ICONS for what a caller actually does with this.
def tag_manager(owner, manager)
  owner && owner.merge(manager: manager)
end

# brew_prefix - `brew --prefix`, memoized, once. Confirmed directly this
#  matters: a plain regex just checking for "/Cellar/" or "/Caskroom/"
#  anywhere in the path missed real Homebrew-managed bash/zsh/perl/php/
#  ruby/pwsh - realpath on those stops one level short, at
#  "$(brew --prefix)/opt/<formula>/bin/<name>" rather than resolving on
#  through to a literal ".../Cellar/<formula>/<version>/..." segment
#  (Homebrew keeps that opt symlink itself version-pinned for these
#  rather than a second symlink hop down into Cellar - this is what the
#  install docs mean by "uses brew --prefix for the path"). Rooting the
#  match at the real, authoritative prefix - rather than guessing at
#  "/usr/local" (Intel) vs "/opt/homebrew" (Apple Silicon) vs any
#  custom --prefix - is also what makes matching *both* the opt and
#  Cellar forms safe: a bare "/opt/" substring match with no anchor
#  would misfire on plenty of unrelated paths that happen to contain
#  "/opt/" (e.g. WSL1's own /opt/... system dirs), Homebrew's own
#  prefix does not.
def brew_prefix
  return @brew_prefix if defined?(@brew_prefix)

  brew = find_on_path('brew')
  @brew_prefix = brew && `"#{brew}" --prefix 2>&1`.strip
rescue StandardError
  @brew_prefix = nil
end

# brew_installed_list(brew) - {name => version}, from one batched
#  `brew list --formula --versions` call (plus `--cask` for GUI-
#  installed CLI tools like the PowerShell cask) - the same one-full-
#  listing-fetched-once-and-grepped shape as cygcheck_installed_list,
#  so a formula's version never costs its own extra `brew info` round
#  trip per lookup.
def brew_installed_list(brew)
  @brew_installed_list ||= %w[--formula --cask].each_with_object({}) do |kind, h|
    `"#{brew}" list #{kind} --versions 2>&1`.each_line do |line|
      parts = line.split(/\s+/)
      h[parts[0]] = parts[1] if parts[0] && parts[1]
    end
  end
end

# homebrew_owner(real) - {name:, version:} for a Homebrew-managed
#  binary, matched against the real `brew --prefix` root (see
#  brew_prefix) rather than a bare "/Cellar/" guess, so it catches both
#  a fully-resolved Cellar path and one that stops at the opt symlink.
def homebrew_owner(real)
  prefix = brew_prefix
  return nil unless prefix && !prefix.empty?

  m = real.to_s.match(%r{\A#{Regexp.escape(prefix)}/(?:Cellar|opt|Caskroom)/([^/]+)/})
  return nil unless m

  name = m[1]
  { name: name, version: brew_installed_list(find_on_path('brew'))[name] }
end

# macos_java_cask(real) - {name:, version:} for a JDK cask (corretto,
#  temurin, zulu, ...), a case homebrew_owner's own prefix-rooted match
#  can never catch: confirmed directly, `brew install --cask corretto@17`
#  runs a real macOS .pkg installer that drops the JDK straight into
#  /Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk (the
#  standard system-wide JDK registration point every "java_home"-aware
#  tool expects), entirely outside Homebrew's own prefix tree - there's
#  no Cellar/opt/Caskroom symlink chain back to Homebrew at all for
#  homebrew_owner to walk, unlike a normal formula/cask install. The
#  cask's own name is still recoverable by fuzzy substring match: cask
#  names for JDKs are "<vendor>[@<major>]" (e.g. "corretto@17"), and the
#  installed bundle's own directory name reliably embeds both the
#  vendor and the major version together (e.g. "amazon-corretto-17.jdk")
#  - confirmed directly against a real "corretto@17" install.
def macos_java_cask(real)
  return nil unless RUBY_PLATFORM =~ /darwin/

  bundle = real.to_s[%r{/([^/]+)\.jdk/Contents/Home/bin/}, 1]
  return nil unless bundle

  brew = find_on_path('brew')
  return nil unless brew

  installed = brew_installed_list(brew)
  name = installed.keys.find { |cask| cask.split('@').all? { |part| bundle.downcase.include?(part.downcase) } }
  name && { name: name, version: installed[name] }
end

# sdkman_dir - $SDKMAN_DIR if set, else the conventional ~/.sdkman -
#  confirmed directly SDKMAN itself honors this same override (its own
#  init script checks $SDKMAN_DIR before defaulting), so a lookup that
#  ignored it could silently miss a real SDKMAN install on a machine
#  where it's been relocated.
def sdkman_dir
  return @sdkman_dir if defined?(@sdkman_dir)

  configured = ENV['SDKMAN_DIR']
  @sdkman_dir = configured && !configured.empty? ? configured : File.join(Dir.home, '.sdkman')
rescue StandardError
  @sdkman_dir = nil
end

# sdkman_owner(real) - {name:, version:} for an SDKMAN-managed
#  candidate, straight from the path string, no subprocess at all -
#  unlike Homebrew's opt-symlink case (see brew_prefix's own comment),
#  SDKMAN has no intermediate hop to worry about: it installs each
#  version under $SDKMAN_DIR/candidates/<candidate>/<version>/ directly
#  and points a "current" symlink at that exact directory, so realpath
#  (already computed by package_info before calling this) lands
#  straight on a real, uniquely-versioned path with both the candidate
#  name and its exact version - vendor suffix included, e.g.
#  "17.0.9-tem" vs "17.0.9-amzn" for two different Java builds of the
#  same numeric version, a distinction a raw --version probe can't
#  reliably draw - sitting right there in the string already.
def sdkman_owner(real)
  dir = sdkman_dir
  return nil unless dir

  m = real.to_s.match(%r{\A#{Regexp.escape(dir)}/candidates/([^/]+)/([^/]+)/})
  m && { name: m[1], version: m[2] }
end

# pyenv_root - $PYENV_ROOT if set, else the conventional ~/.pyenv -
#  same override-then-default reasoning as sdkman_dir, since pyenv
#  itself honors this same env var for where its shims/versions live.
def pyenv_root
  return @pyenv_root if defined?(@pyenv_root)

  configured = ENV['PYENV_ROOT']
  @pyenv_root = configured && !configured.empty? ? configured : File.join(Dir.home, '.pyenv')
rescue StandardError
  @pyenv_root = nil
end

# pyenv_owner(real) - {name:, version:} for a pyenv-managed Python
#  shim, tagged :pyenv (a version manager - same MANAGER_ICONS category
#  as :sdkman). The "package name" shown is the interpreter's own
#  resolved version string (e.g. "2.7.18"), not a package id at all -
#  pyenv shims are real files, not symlinks (unlike SDKMAN's own
#  versioned-directory symlink - see sdkman_owner's own comment), so
#  realpath is a no-op on one and there's no version-bearing path
#  segment to extract the way sdkman_owner does. Runs the shim's own
#  --version directly rather than asking pyenv itself (`pyenv
#  version-name`/`pyenv which`) - the shim already resolves
#  PYENV_VERSION/.python-version internally the exact same way a normal
#  invocation would, so this can't disagree with what the Version
#  column (probe_version, run separately) reports, and doesn't need
#  `pyenv` itself to be a separately resolvable binary on PATH.
def pyenv_owner(real)
  root = pyenv_root
  return nil unless root && real.to_s.start_with?("#{root}/shims/")

  raw = `"#{real}" --version < #{NULL_DEVICE} 2>&1`.strip
  version = raw[/(\d+(?:\.\d+)+)/, 1]
  version && { name: version, version: version }
end

# rbenv_root - $RBENV_ROOT if set, else the conventional ~/.rbenv - same
#  override-then-default reasoning as pyenv_root/sdkman_dir.
def rbenv_root
  return @rbenv_root if defined?(@rbenv_root)

  configured = ENV['RBENV_ROOT']
  @rbenv_root = configured && !configured.empty? ? configured : File.join(Dir.home, '.rbenv')
rescue StandardError
  @rbenv_root = nil
end

# rbenv_owner(real) - {name:, version:} for an rbenv-managed Ruby/gem
#  binary, tagged :rbenv (same version-manager category as :sdkman/
#  :pyenv). "<root>/versions/<version>/bin/<name>" is parsed straight
#  from the path - same reasoning as sdkman_owner, not pyenv_owner:
#  every binary under one "versions/<version>/bin/" directory (ruby
#  itself, but also every gem executable it ships or that's been
#  `gem install`-ed into it - rake, bundle, irb, ...) belongs to that
#  one rbenv-installed Ruby, the same way every tool under one SDKMAN
#  candidate directory belongs to that one JDK - confirmed directly per
#  direct correction: rake's own --version (its gem version, e.g.
#  "13.3.1") is a real, different number from the Ruby it's bundled
#  into, but the Package column is meant to answer "what did the version
#  manager install here", not "what does this specific binary self-
#  report" - shelling out per tool would answer the wrong question for
#  every gem shim, correctly only for `ruby` itself. Also confirmed
#  directly this is the form that actually shows up in practice: some
#  rbenv setups (e.g. the Ubuntu rbenv package driving a user-populated
#  $RBENV_ROOT) put the active version's own bin/ ahead of shims/ on
#  PATH, so find_on_path/realpath land straight on the versioned binary
#  and never see a shim path at all.
#
#  "<root>/shims/<name>" (the standard rbenv init layout, when it is
#  what PATH resolves to) carries no version in the path at all - a shim
#  is a single version-agnostic dispatcher, not tied to one installed
#  Ruby the way the versions/ directory is - so that case still falls
#  back to running `--version` directly, same as pyenv_owner; it can't
#  answer the "which Ruby owns this gem" question either way without a
#  real rbenv resolution (`rbenv which`/`rbenv version-name`) this
#  doesn't attempt.
def rbenv_owner(real)
  root = rbenv_root
  return nil unless root

  m = real.to_s.match(%r{\A#{Regexp.escape(root)}/versions/([^/]+)/bin/})
  return { name: m[1], version: m[1] } if m

  return nil unless real.to_s.start_with?("#{root}/shims/")

  raw = `"#{real}" --version < #{NULL_DEVICE} 2>&1`.strip
  version = raw[/(\d+(?:\.\d+)+)/, 1]
  version && { name: version, version: version }
end

# cargo_home - $CARGO_HOME if set, else the conventional ~/.cargo - same
#  override-then-default reasoning as rbenv_root/pyenv_root.
def cargo_home
  return @cargo_home if defined?(@cargo_home)

  configured = ENV['CARGO_HOME']
  @cargo_home = configured && !configured.empty? ? configured : File.join(Dir.home, '.cargo')
rescue StandardError
  @cargo_home = nil
end

# rustup_owner(real, original) - {name:, version:} for a rustup-managed
#  toolchain proxy, tagged :rustup (same version-manager category as
#  :sdkman/:pyenv/:rbenv). Unlike every other manager here, rustup has
#  no per-tool versioned directory to match at all - confirmed directly,
#  "rustc"/"cargo"/"rustfmt"/etc. under "$CARGO_HOME/bin/" are each a
#  symlink to the exact same "rustup" multiplexer binary, so `real`
#  (already realpath'd by package_info) is always just
#  "$CARGO_HOME/bin/rustup" regardless of which tool was actually
#  resolved - there's nothing tool- or version-specific left in the path
#  to key off. `original` (the pre-realpath path package_info already
#  carries for exactly this kind of case - see apt_owner's own usrmerge
#  handling) is what still points at the real tool name, so that's what
#  gets run for `--version`: invoking the "rustup" binary itself would
#  only ever report rustup's own version, not the active toolchain's.
def rustup_owner(real, original)
  home = cargo_home
  return nil unless home && original && real.to_s == File.join(home, 'bin', 'rustup')

  raw = `"#{original}" --version < #{NULL_DEVICE} 2>&1`.strip
  version = raw[/(\d+(?:\.\d+)+)/, 1]
  version && { name: version, version: version }
end

# choco_installed_list(choco) - {package id => version}, from one
#  `choco list --limit-output` batch call - "--limit-output" ("-r")
#  prints a stable, script-friendly "id|version" line per package, no
#  column-width table or trailing summary line to parse around - the
#  same one-full-listing-fetched-once shape as
#  cygcheck_installed_list/brew_installed_list.
def choco_installed_list(choco)
  @choco_installed_list ||= `"#{choco}" list --limit-output 2>&1`.each_line.each_with_object({}) do |line, h|
    id, version = line.strip.split('|', 2)
    h[id] = version if id && version
  end
end

# chocolatey_owner(real, candidates) - {name:, version:} for a
#  Chocolatey-managed binary, matched purely by name/tag against
#  `choco list`, with no path confirmation at all -
#  confirmed directly this has to be the approach: plenty of real
#  `choco install`s just run a downloaded installer and let it place
#  the binary wherever it normally would (Strawberry Perl to
#  C:\Strawberry, Go and dotnet-sdk to their own Program Files dirs,
#  the "magicsplat-tcl-tk"/"corretto17jdk" packages the same way),
#  completely outside any Chocolatey-owned directory - not just outside
#  $env:ChocolateyInstall, but also outside $env:ChocolateyToolsLocation
#  (the other Chocolatey-recognized install root, C:\tools by default),
#  the two together still missing most of what actually matters here. A
#  shimgen shim under ChocolateyInstall\bin wouldn't help distinguish
#  these either way - its real redirect target is embedded inside the
#  shim binary itself, not discoverable via realpath.
#
#  `candidates` is the language's whole bin: list (not just whichever
#  one resolve_binary happened to find first) - confirmed directly this
#  matters: PowerShell's own AREAS entry tries "pwsh" before
#  "powershell", so a genuine local pwsh.exe resolves before ever
#  trying the "powershell" name, and "pwsh" alone isn't a substring of
#  the real package id "powershell-core" ("powershell" is, but that
#  name would never even get tried without checking every candidate).
#
#  Same "good enough for a friendly report, not a security check"
#  tradeoff probe_version already makes - an exact id match against
#  `choco list` (dotnet, go, ruby, python3, gawk, groovy, rust via
#  "rustc" - all confirmed directly) is tried first, then a substring
#  match in either direction (catches "strawberryperl"/perl,
#  "powershell-core"/powershell). What's left after that - "javac"/
#  "corretto17jdk", "tclsh"/"magicsplat-tcl-tk" - share no substring at
#  all, but `choco info <pkg>`'s own Tags field does carry the missing
#  link (confirmed directly: corretto17jdk is tagged "corretto java
#  jvm", magicsplat-tcl-tk "magicsplat-tcl-tk magicsplat tcl tk",
#  powershell-core "powershell-core powershell pwsh admin") -
#  `choco list <name> --by-tags-only` searches that Tags field
#  specifically, so it's tried last, only for whatever the cheaper
#  list-based match didn't already resolve. `choco search` looks like
#  the more obvious tool for this but confirmed directly it's the wrong
#  one - it full-text-matches id/title/tags/description together and,
#  even with --local-only, returned flatly unrelated packages for exact
#  tag terms ("java" -> docfetcher/stigviewer/UnderscoreBackup, none
#  Java-related at all) - --by-tags-only is what actually stays scoped
#  to the Tags field alone.
#
#  Gated on native_windows_ruby? - Chocolatey itself is native-Windows-
#  only, and this hasn't been exercised from MSYS2/Cygwin/WSL1 even
#  though `choco.exe` might technically be reachable from their PATH
#  too.
def chocolatey_owner(real, candidates)
  return nil unless candidates && native_windows_ruby?

  # Chocolatey never installs applications into %SystemRoot% (that
  #  directory is reserved for OS components) - confirmed directly this
  #  guard is needed: C:\Windows\system32\bash.exe is Windows' own
  #  launcher stub for the default WSL distro, not MSYS2's bash at all
  #  (running it drops you into WSL1), yet a real "msys2" Chocolatey
  #  package happens to be tagged "bash" too - name/tag matching alone
  #  can't tell those apart, since it never looks at the path at all.
  #  Excluding %SystemRoot%/%windir% outright, before ever querying
  #  choco, is safe precisely because nothing Chocolatey-managed is
  #  ever legitimately found there.
  # Falls back to the conventional literal default when the env var
  #  comes back empty/unset for any reason, rather than silently
  #  skipping the guard - confirmed directly the bare ENV lookup alone
  #  wasn't actually blocking C:\Windows\system32\bash.exe as expected
  #  on at least one real machine, cause not yet pinned down.
  system_root = ENV['SystemRoot'] || ENV['windir']
  system_root = 'C:\Windows' if system_root.to_s.empty?
  # Separators normalized to "/" on both sides before comparing -
  #  confirmed directly the hardcoded literal fallback above still
  #  didn't block C:\Windows\system32\bash.exe, which pointed at a
  #  format mismatch rather than a missing env var: realpath (used to
  #  compute `real`) likely returns forward-slash form even on Windows,
  #  while system_root here is a plain backslash literal - a
  #  start_with? check across mismatched separators silently never
  #  matches, regardless of how correct the actual path is.
  return nil if real.to_s.downcase.tr('\\', '/').start_with?(system_root.downcase.tr('\\', '/'))

  choco = find_on_path('choco')
  return nil unless choco

  names = candidates.map { |c| c.sub(/\.exe\z/i, '') }.uniq
  installed = choco_installed_list(choco)
  # A raw substring check isn't safe at any length - confirmed directly
  #  with two different failure shapes: "cl" (C++'s own MSVC candidate)
  #  collides with "act-cli" purely because of the "cli" in it, and
  #  "date" (a plain dictionary word) collides with
  #  "chocolatey-windowsupdate.extension" purely because "date" is
  #  embedded in "update" - a length floor catches the first but not
  #  the second. Splitting each id on its own delimiters ("-", ".",
  #  "_") into real tokens and requiring an exact match against one of
  #  them is safe against both: "core" isn't a token of "windowsupdate"
  #  under any split, and neither is "cl" a token of "cli". This does
  #  cost a couple of previously-working matches that relied on the
  #  id/name being glued together with no delimiter at all
  #  ("strawberryperl" for "perl", "rust" for "rustc") - those fall
  #  through to choco_tag_owner now (or stay honestly unmatched)
  #  instead of a coincidental-but-correct substring hit, which is the
  #  right trade given the false positives above were the same kind of
  #  coincidence just pointed the wrong way.
  key = names.find { |n| installed.key?(n) } ||
        installed.keys.find { |id| names.any? { |n| id.downcase.split(/[^a-z0-9]+/).include?(n.downcase) } }
  return { name: key, version: installed[key] } if key

  names.each do |n|
    found = choco_tag_owner(choco, n)
    return found if found
  end
  nil
end

# choco_tag_owner(choco, name) - {name:, version:} via
#  `choco list <name> --by-tags-only --limit-output`, matched against
#  Chocolatey's own Tags metadata rather than a path or plain-id guess -
#  see chocolatey_owner's own comment for why this is the only way to
#  connect e.g. "tclsh" to "magicsplat-tcl-tk" at all, and why
#  `choco search` isn't used for this despite looking similar.
#
#  Only trusted when exactly one package carries the tag - confirmed
#  directly this ambiguity is real, not hypothetical: "java" tags four
#  different installed packages (corretto17jdk, groovy, vscode,
#  vscode.install) - groovy is already its own, separately-tracked
#  language elsewhere in AREAS, so picking any one of these by
#  assumption (e.g. "first result") risks mislabeling Java's own
#  version with a completely unrelated package's. Declining outright
#  when the tag alone doesn't pin down a single package is the same
#  "don't guess wrong" choice already made for cases with no lexical
#  relationship at all.
#
#  One subprocess call per still-unmatched candidate, not batched -
#  unlike choco_installed_list's single full listing, there's no
#  "look up tags for everything at once" equivalent, but this only runs
#  for the handful of names the cheap list-based match didn't already
#  resolve.
def choco_tag_owner(choco, name)
  raw = `"#{choco}" list "#{name}" --by-tags-only --limit-output 2>&1`
  hits = raw.each_line.filter_map do |line|
    id, version = line.strip.split('|', 2)
    [id, version] if id && version
  end
  return nil unless hits.length == 1

  id, version = hits.first
  { name: id, version: version }
end

# prefetch_package_info!() - resolves every language's and every tool's
#  binary across the whole AREAS tree (resolve_binary alone - pure Ruby,
#  no subprocess), then batch-queries the package manager once (pacman,
#  apt) - or, for Cygwin, just makes sure cygcheck_installed_list's own
#  memoized full listing gets fetched only the one time it's needed
#  regardless of how many files end up checked against it. Call this
#  once, before build_report's own tree-walk, so every later
#  package_info(path) call along the way is a cache hit.
def prefetch_package_info!
  originals = AREAS.flat_map { |area| area[:languages] }.flat_map do |lang|
    lang_path = resolve_binary(lang[:bin])[1]
    # Mirrors resolve_language's own "skip tools when the language
    #  itself isn't found" rule - no point prefetching package info for
    #  tools that will never be resolved or displayed anyway.
    next [lang_path] unless lang_path

    dirs = lang[:native_tools] ? windows_native_path_dirs : nil
    [lang_path] + (lang[:tools] || []).map { |tool| resolve_binary(Array(tool), dirs)[1] }
  end.compact.uniq
  return if originals.empty?

  # real => original (pre-realpath) - kept as a Hash, not just the
  #  realpath'd list alone, so prefetch_apt! can fall back to querying
  #  dpkg with the original form too. See apt_owner's own comment: on a
  #  Debian/Ubuntu "usrmerge" system, /bin is a directory-level symlink
  #  to /usr/bin, so realpath("/bin/dash") => "/usr/bin/dash", but
  #  dpkg's database still records ownership under the pre-merge
  #  "/bin/dash" form dpkg -S actually recognizes.
  real_to_original = originals.each_with_object({}) { |p, h| h[realpath(p)] = p }

  if ENV['MSYSTEM'] && (pacman = find_on_path('pacman'))
    prefetch_pacman!(pacman, real_to_original)
  elsif (dpkg = find_on_path('dpkg')) && !cygwin_environment?
    prefetch_apt!(dpkg, real_to_original)
  end
  # Cygwin needs no batch prefetch here - cygcheck_owner's own
  #  cygcheck_installed_list memoization already avoids paying for the
  #  expensive full-listing scan more than once; cygcheck -f itself is
  #  a cheap, targeted per-file lookup, unlike pacman's/dpkg's own
  #  meaningful per-invocation startup cost.
end

# cygwin_environment?() - true only for a genuine Cygwin session, not
#  just "cygcheck.exe happens to be somewhere on PATH" - confirmed
#  directly this distinction matters: Git for Windows bundles its own
#  vestigial cygcheck.exe (no real package database behind it), and
#  blindly trying it produced "No setup information found"/"setup"
#  nonsense parsed as if it were a real package name/version. MSYSTEM
#  being set (Git Bash included) rules Cygwin out immediately - MSYS2
#  and Cygwin are mutually exclusive runtimes; only `uname -s` actually
#  reporting "CYGWIN..." confirms the real thing.
def cygwin_environment?
  return false if ENV['MSYSTEM']

  uname = find_on_path('uname')
  return false unless uname

  `"#{uname}" -s 2>&1`.strip =~ /cygwin/i ? true : false
rescue StandardError
  false
end

# prefetch_pacman!(pacman, real_to_original) - one
#  `pacman -Qo <path1> <path2> ...` batch call instead of one per path -
#  pacman prints one "<path> is owned by <pkgname> <pkgver>" line per
#  *found* path (an unowned one just gets its own "error: No package
#  owns <path>" line, confirmed directly - silently skipped by the
#  match below), so every queried path gets marked "not owned" (nil) up
#  front and only overwritten for the ones that actually match a line
#  back. "Not owned by pacman" isn't the same as "not owned by
#  anything", though - confirmed directly this is the common case for
#  MSYS2 itself: pacman only tracks MSYS2's own packages, so anything a
#  version manager placed under $HOME (pyenv/rbenv/rustup/SDKMAN, all
#  routine on this same MSYS2 box) would otherwise sit permanently
#  cached nil - the trailing pass below gives each of those its one
#  shot, same as an ordinary lookup_package_info cache-miss would get
#  outside of prefetch (see version_manager_owner).
def prefetch_pacman!(pacman, real_to_original)
  posix_map = real_to_original.each_key.each_with_object({}) { |p, h| h[to_posix(p)] = p }
  posix_map.each_value { |real| PACKAGE_CACHE[real] = nil }

  raw = `"#{pacman}" -Qo #{posix_map.keys.map { |p| "\"#{p}\"" }.join(' ')} 2>&1`
  raw.each_line do |line|
    m = line.match(/\A(.+?) is owned by (\S+) (\S+)\s*\z/)
    next unless m

    real = posix_map[m[1]]
    PACKAGE_CACHE[real] = { name: m[2], version: m[3], manager: :pacman } if real
  end

  real_to_original.each do |real, original|
    next if PACKAGE_CACHE[real]

    PACKAGE_CACHE[real] = version_manager_owner(real, nil, original)
  end
rescue StandardError
  nil
end

# pacman_owner(pacman, path) - single-path fallback for a cache miss
#  (prefetch_package_info! not called, or missed this particular path) -
#  same "is owned by <pkgname> <pkgver>" line prefetch_pacman! parses in
#  bulk, just for one file.
def pacman_owner(pacman, path)
  raw = `"#{pacman}" -Qo "#{to_posix(path)}" 2>&1`.strip
  m = raw.match(/is owned by (\S+) (\S+)/)
  m && { name: m[1], version: m[2] }
rescue StandardError
  nil
end

# cygcheck_installed_list(cygcheck) - {name => version}, from
#  `cygcheck -c` with no argument - every installed package, memoized
#  process-wide (not per lookup) since it's the expensive part
#  (confirmed directly - this single call was what made every earlier
#  per-tool cygcheck_owner call so slow) and the table already carries
#  each package's version in the same listing, so no second
#  `cygcheck -c <name>` call is needed per package on top of it either.
def cygcheck_installed_list(cygcheck)
  @cygcheck_installed_list ||= `"#{cygcheck}" -c 2>&1`.lines.each_with_object({}) do |line, h|
    parts = line.split(/\s+/)
    h[parts[0]] = parts[1] if parts[0] && parts[1]
  end
end

# cygcheck_owner(cygcheck, path) - Cygwin's own file-ownership tool.
#  `cygcheck -f <file>` doesn't print a clean "name version" pair - it
#  prints the full package *specifier* ("bash-5.2.21-1",
#  "perl_base-5.44.0-1-x86_64") with no marked boundary between name
#  and version - and naively splitting on the first "-" mis-parses any
#  package whose own name contains one (confirmed directly:
#  "util-linux-2.40.2-2" is the package "util-linux", not "util").
#  cygcheck_installed_list's keys are every installed package's own bare
#  name - the *longest* one the specifier actually starts with
#  (followed by "-") disambiguates correctly, and its version comes
#  from that same already-fetched table.
def cygcheck_owner(cygcheck, path)
  spec = `"#{cygcheck}" -f "#{path}" 2>&1`.strip.lines.first.to_s.strip
  return nil if spec.empty? || spec =~ /not found|no package/i

  installed = cygcheck_installed_list(cygcheck)
  name = installed.keys.select { |n| spec == n || spec.start_with?("#{n}-") }.max_by(&:length)
  name ? { name: name, version: installed[name] } : { name: spec, version: nil }
rescue StandardError
  nil
end

# prefetch_apt!(dpkg, real_to_original) - one `dpkg -S <path1> <path2>
#  ...` batch call for ownership, then one more `dpkg -s <pkg1> <pkg2>
#  ...` batch call for every version at once (dpkg -s accepts multiple
#  package names, printing one "Package:"/"Version:" stanza per
#  package) - instead of two round trips (see apt_owner) *per* path.
#
#  Queries the realpath'd form, the original pre-realpath form, and the
#  realpath's own pre-usrmerge variant (see usrmerge_variant) for every
#  binary, mapping any one hit back to the same `real` PACKAGE_CACHE
#  key - confirmed directly this matters: dpkg -S "/usr/bin/dash" finds
#  nothing on a system where /bin is a directory-level symlink to
#  /usr/bin (dash genuinely is dpkg-managed, just recorded under the
#  pre-merge "/bin/dash"), and "ksh" needs the variant specifically -
#  realpath resolves it two hops past dpkg's own "/bin/ksh93" record
#  (through an update-alternatives symlink *and* usrmerge together),
#  so neither the original "/bin/ksh" nor the fully-resolved
#  "/usr/bin/ksh93" alone is what dpkg has on record.
def prefetch_apt!(dpkg, real_to_original)
  real_to_original.each_key { |real| PACKAGE_CACHE[real] = nil }

  real_for_queried = {}
  real_to_original.each do |real, original|
    real_for_queried[real] = real_for_queried[original] = real
    if (variant = usrmerge_variant(real))
      real_for_queried[variant] = real
    end
  end

  raw = `"#{dpkg}" -S #{real_for_queried.keys.map { |p| "\"#{p}\"" }.join(' ')} 2>&1`
  names = []
  raw.each_line do |line|
    next unless line.include?(': ')

    pkgs, found_path = line.strip.split(': ', 2)
    real = real_for_queried[found_path]
    next unless real

    name = pkgs.to_s.split(',').first.to_s.strip
    next if name.empty?

    PACKAGE_CACHE[real] = { name: name, version: nil, manager: :apt }
    names << name
  end

  unless names.empty?
    info = `"#{dpkg}" -s #{names.uniq.map { |n| "\"#{n}\"" }.join(' ')} 2>&1`
    versions = {}
    current = nil
    info.each_line do |line|
      if line.start_with?('Package:')
        current = line.sub(/\APackage:\s*/, '').strip
      elsif line.start_with?('Version:') && current
        versions[current] = line.sub(/\AVersion:\s*/, '').strip
      end
    end
    PACKAGE_CACHE.each_value { |pkg| pkg[:version] = versions[pkg[:name]] if pkg && versions.key?(pkg[:name]) }
  end

  # apt not owning a path is the common case for anything a version
  #  manager placed under $HOME instead (pyenv/rbenv/rustup/SDKMAN) -
  #  each of those gets exactly one more shot per still-nil path here,
  #  same as an ordinary lookup_package_info cache-miss would get
  #  outside of prefetch (see version_manager_owner). Previously this
  #  method just left every apt-less path cached nil for good - dpkg's
  #  own batch answer was never the *whole* answer to begin with.
  real_to_original.each do |real, original|
    next if PACKAGE_CACHE[real]

    PACKAGE_CACHE[real] = version_manager_owner(real, nil, original)
  end
rescue StandardError
  nil
end

# apt_owner(dpkg, path) - single-path fallback for a cache miss
#  (prefetch_package_info! not called, or missed this particular path).
#  `dpkg -S <file>` prints "<pkgname>: <file>" (or "<pkg1>,<pkg2>:
#  <file>" for the rare file shared by multiple packages - first one
#  wins, same "first listed provider" convention resolve_order.rb's own
#  needs/meets resolution already uses), with no version in the same
#  line at all - `dpkg -s <pkgname>` gets that separately, straight from
#  the local package database (no network/apt-cache-update dependency,
#  unlike `apt show`).
#
#  Called with the realpath'd form first, then (see lookup_package_info)
#  the original pre-realpath form as a fallback - confirmed directly
#  this matters on a Debian/Ubuntu "usrmerge" system: /bin is a
#  directory-level symlink to /usr/bin, so File.realpath("/bin/dash")
#  returns "/usr/bin/dash", but dpkg's own database still records
#  ownership under the pre-merge "/bin/dash" form - `dpkg -S
#  /usr/bin/dash` answers "no path found matching pattern" even though
#  dash is genuinely a dpkg-managed package.
#
#  A file dpkg doesn't manage at all (confirmed directly: any real
#  Windows binary reached via /mnt/c under WSL1, or a manually-placed
#  tool like Strawberry Perl's cpanm.bat) isn't just silent - dpkg -S
#  prints its own error, "dpkg-query: no path found matching pattern
#  <file>", to stderr. Merged in via 2>&1, that error's own
#  "dpkg-query:" prefix *also* contains a colon, so a bare "does this
#  contain ':'" check was misreading it as a successful
#  "<pkgname>: <file>" answer, with "dpkg-query" mistaken for the
#  package name. Checking that the text after the colon actually equals
#  the path just queried is what a genuine success has to satisfy.
def apt_owner(dpkg, path)
  raw = `"#{dpkg}" -S "#{path}" 2>&1`.strip.lines.first.to_s.strip
  return nil unless raw.include?(': ')

  pkgs, found_path = raw.split(': ', 2)
  return nil unless found_path == path

  name = pkgs.to_s.split(',').first.to_s.strip
  return nil if name.empty?

  version_line = `"#{dpkg}" -s "#{name}" 2>&1`.lines.find { |l| l.start_with?('Version:') }
  version = version_line.to_s.sub(/\AVersion:\s*/, '').strip
  { name: name, version: version.empty? ? nil : version }
rescue StandardError
  nil
end

# uname_string - a uname-style identifier matching config/env.yml's own
#  "supports" entries (e.g. "cygwin_nt.10_0_26200", "linux_ubuntu.26_04")
#  - built from a real `uname -s`/`-r` wherever one exists (Cygwin,
#  MSYS2, WSL1, Linux, macOS), or synthesized from Windows' own OS
#  version when it doesn't (a plain native Windows Ruby, e.g.
#  C:\tools\ruby34\bin\ruby.exe, has no `uname` on PATH at all).
def uname_string
  if find_on_path('uname')
    sys = `uname -s`.strip
    return linux_uname_string(`uname -r`.strip) if sys == 'Linux'

    # "CYGWIN_NT-10.0-26200"/"MINGW64_NT-10.0-26200" (uname -s alone,
    #  version baked in) -> lowercase, the first "-" becomes the
    #  kernel/version separator ".", every remaining "-"/"." becomes "_"
    #  (matches env.yml's own "cygwin_nt.10_0_26200"/
    #  "mingw64_nt.10_0_26200" exactly).
    kernel, sep, version = sys.downcase.partition('-')
    # macOS: uname -s ("Darwin") and -r ("26.5.0") come back separately,
    #  no "-" to partition on at all.
    version = `uname -r`.strip if sep.empty?
    "#{kernel}.#{version.tr('.-', '__')}"
  elsif Gem.win_platform?
    "windows_nt.#{windows_build_version.tr('.', '_')}"
  else
    'unknown'
  end
end

# os_release_fields(path) - {"ID" => "pop", "ID_LIKE" => "ubuntu debian",
#  "VERSION_ID" => "22.04", ...} from a systemd-style os-release file -
#  shared by linux_uname_string and match_platform's own ID_LIKE
#  fallback, so there's exactly one place that knows how to parse it.
def os_release_fields(path)
  File.read(path).each_line.each_with_object({}) do |line, h|
    k, _, v = line.strip.partition('=')
    h[k] = v.delete('"')
  end
end

# linux_uname_string(release) - `uname -s` alone is just "Linux", no
#  distro info at all - env.yml keys Linux entries on distro+version
#  instead (e.g. "linux_ubuntu.26_04"), which only /etc/os-release's
#  ID/VERSION_ID actually carries. Always built from the distro's own
#  ID (e.g. "linux_pop.22_04" on Pop!_OS), never ID_LIKE - this is the
#  string shown in the report header, and a derivative distro's own
#  real identity is what a human reading it actually wants to see; see
#  match_platform for where ID_LIKE comes in instead, purely as a
#  matching fallback.
def linux_uname_string(release)
  os_release = '/etc/os-release'
  return "linux.#{release.tr('.-', '__')}" unless File.exist?(os_release)

  fields = os_release_fields(os_release)
  "linux_#{fields['ID'] || 'linux'}.#{(fields['VERSION_ID'] || release).tr('.', '_')}"
end

# windows_build_version - "10.0.26200"-style OS version, for a plain
#  native Windows Ruby with no `uname` on PATH at all (unlike
#  MSYS2/Cygwin, which always provide one) - same technique
#  detect_shell.rb already uses for its own PowerShell probe.
def windows_build_version
  raw = IO.popen(['powershell.exe', '-NoProfile', '-NonInteractive', '-Command',
                   '[System.Environment]::OSVersion.Version.ToString()']) { |io| io.read }.strip
  # .NET's Version is 4-part (Major.Minor.Build.Revision, e.g.
  #  "10.0.26200.0") - env.yml's own entries are 3-part
  #  ("10_0_26200"), so drop the trailing revision component.
  raw.split('.').first(3).join('.')
rescue StandardError
  'unknown'
end

# match_platform(uname) - which config/env.yml "platform" label
#  (windows/macos/ubuntu26/ubuntu22/cygwin/msys) this uname string is
#  listed under, or nil if env.yml doesn't know about it yet.
#
#  For a Linux uname whose own distro isn't listed anywhere (e.g.
#  Pop!_OS's own "linux_pop.22_04"), falls back to /etc/os-release's
#  own ID_LIKE field instead of asking every env.yml maintainer to
#  enumerate every Ubuntu/Debian derivative (Pop!_OS, Mint, Zorin,
#  elementary OS, ...) by name - Pop!_OS's os-release already declares
#  "ID_LIKE=ubuntu debian", and this project's actual concerns (apt,
#  dpkg, package availability) are identical to genuine Ubuntu at the
#  same version. Tried in ID_LIKE's own listed order, first match wins -
#  same "first listed provider" convention resolve_order.rb's own
#  needs/meets resolution already uses.
def match_platform(uname)
  env_file = File.join(__dir__, '..', 'config', 'env.yml')
  return nil unless File.exist?(env_file)

  envs = YAML.load_file(env_file)['environments'] || []
  found = envs.find { |e| Array(e['supports']).include?(uname) }
  found ||= begin
    fallback = fallback_platform_uname(uname, envs)
    fallback && envs.find { |e| Array(e['supports']).include?(fallback) }
  end
  found && found['platform']
end

# fallback_platform_uname(uname, envs) - re-derives a "linux_<id>.<ver>"
#  string using /etc/os-release's own ID_LIKE tokens in place of ID
#  (keeping the same version suffix `uname` already carries), returning
#  the first one env.yml actually lists - nil if `uname` isn't
#  Linux-shaped, os-release has no ID_LIKE, or none of its tokens are
#  recognized either.
def fallback_platform_uname(uname, envs)
  m = uname.match(/\Alinux_([^.]+)\.(.+)\z/)
  return nil unless m

  os_release = '/etc/os-release'
  return nil unless File.exist?(os_release)

  known = envs.flat_map { |e| Array(e['supports']) }
  os_release_fields(os_release)['ID_LIKE'].to_s.split(' ').each do |like|
    next if like == m[1]

    candidate = "linux_#{like}.#{m[2]}"
    return candidate if known.include?(candidate)
  end
  nil
end

# probe_version(name, path, mode) - best-effort version string. This is
#  deliberately simpler than testbox/Script.rb's own per-environment
#  special_version methods (real cmd.exe/cscript.exe/tclsh version
#  strings need genuinely different probes - see Script.rb's
#  @@special_version_langs) - a report tool can settle for "close enough
#  to confirm it's installed", where the test harness can't.
# NULL_DEVICE - stdin gets redirected from this in every probe_version
#  subprocess call below - confirmed directly this isn't hypothetical:
#  MSYS2's own /usr/bin/date.exe, run bare with no arguments, doesn't
#  error or print anything - it prompts "Enter the new date:" and
#  blocks on stdin, the exact same class of hang testbox/Script.rb's
#  own PosixShellScript already had to defend against early in this
#  project (see its shell_out_command's own null-device redirect). A
#  probed binary reading from Ruby's own inherited stdin - which has no
#  input waiting, and won't hit EOF either since it's an interactive
#  console - would freeze the entire report generation, not just fail
#  one row. `< NUL`/`< /dev/null` redirection syntax is valid for both
#  a cmd.exe-backed and a POSIX-shell-backed Kernel#`, so this needs no
#  native_windows_ruby?-style branching the way probe_version's own
#  :powershell quoting does.
NULL_DEVICE = File::NULL

def probe_version(name, path, mode)
  return nil unless path

  case mode
  when :cmd
    `#{path} /c ver < #{NULL_DEVICE} 2>&1`[/Version ([\d.]+)/, 1]
  when :powershell
    # Quote style has to match which shell is actually delivering this
    #  backtick - confirmed directly (same reasoning testbox/Script.rb's
    #  own PosixShellScript#special_version already documents): a
    #  cmd.exe-backed Kernel#` (native Windows Ruby) doesn't touch "$",
    #  so double quotes work fine there and get stripped as cmd.exe's
    #  own grouping syntax before pwsh ever sees them - but a genuinely
    #  POSIX-backed Kernel#` (Cygwin, WSL1, ...) expands "$PSVersionTable"
    #  itself *inside* double quotes before pwsh does, leaving pwsh a
    #  syntax error ("An expression was expected after '('"). Single
    #  quotes prevent that expansion and still get stripped the same way
    #  by /bin/sh's own quoting, leaving pwsh the same bare, unquoted
    #  expression text either way.
    quoted = native_windows_ruby? ? '"$PSVersionTable.PSVersion.ToString()"' : "'$PSVersionTable.PSVersion.ToString()'"
    `"#{path}" -NoProfile -NonInteractive -Command #{quoted} < #{NULL_DEVICE} 2>&1`.strip
  when :cscript
    `#{path} < #{NULL_DEVICE} 2>&1`[/Version (\S+)/, 1]
  when :tcl
    tcl_version(path)
  when :go
    `"#{path}" version < #{NULL_DEVICE} 2>&1`[/go version go(\S+)/, 1]
  when :java
    raw = `"#{path}" -version < #{NULL_DEVICE} 2>&1`
    raw[/version "([^"]+)"/, 1] || raw[/(\d+\.\d+\.\d+)/, 1]
  when :ksh_env
    # `ksh` doesn't reliably resolve to the same implementation
    #  everywhere - confirmed directly, on MSYS2/Cygwin it's `mksh`
    #  (which has no --version, but sets $KSH_VERSION); on Ubuntu/WSL1
    #  it's real AT&T ksh93 (which *does* answer --version - "version
    #  sh (AT&T Research) 93u+m/..." - but doesn't reliably set
    #  $KSH_VERSION at all). Try the flag first since it's the more
    #  informative, standard-shaped answer when it works, falling back
    #  to the variable for whichever implementation doesn't support it.
    raw = `"#{path}" --version < #{NULL_DEVICE} 2>&1`.strip
    raw = `"#{path}" -c "echo $KSH_VERSION" < #{NULL_DEVICE} 2>&1`.strip if error_output?(raw)
    return nil if error_output?(raw)

    # mksh's own $KSH_VERSION is an SCCS/what(1)-style ident stamp
    #  ("@(#)MIRBSD KSH R59 2020/10/31" - confirmed directly), not a
    #  usable version number at all: "R59" is only mksh's own internal
    #  release counter, unrelated to (and far less precise than) the
    #  real package version pacman reports for it ("59.c-2"). Neither
    #  error_output? (this isn't a "bad flag" complaint) nor the
    #  "bare value, nothing to extract" assumption below actually holds
    #  for this specific shape - returning nil here routes it through
    #  resolve_language's own `probe_version(...) || pkg[:version]`
    #  fallback (see its own comment) instead of displaying this
    #  confusing SCCS string as if it were "the version".
    return nil if raw.start_with?('@(#)')

    # AT&T ksh93's own --version banner ("version         sh (AT&T
    #  Research) 93u+m/1.0.0-beta.2 2021-12-17") is a whole sentence,
    #  not a version string - confirmed directly this was displaying
    #  verbatim, "version" and all, in the report's Version column.
    #  Pull out just the "1.0.0-beta.2" segment after "93u+m/"; the
    #  $KSH_VERSION fallback above is already a bare value with nothing
    #  to extract, so only re-parse when this is genuinely the banner
    #  form.
    raw[%r{93u\+m/(\S+)}, 1] || raw
  else # :flag - the common case, try --version then -version
    raw = `"#{path}" --version < #{NULL_DEVICE} 2>&1`
    raw = `"#{path}" -version < #{NULL_DEVICE} 2>&1` if error_output?(raw)
    return nil if error_output?(raw)

    # Search the *whole* output, not just the first line - some tools
    #  (confirmed directly with Strawberry Perl) print a banner/blank
    #  line before the actual version text.
    found = raw.to_s[/\d+\.\d[\d.]*/]
    return found if found

    # No digit-dotted-number anywhere in the whole output - a real
    #  version banner almost always has one, so by this point
    #  something's already gone wrong, not just "a versionless tool".
    #  error_output? already catches every *known* shape of that
    #  (bad flag, missing dependency, ...), but new ones keep turning
    #  up one at a time (groovy's own "JAVA_HOME not set..." wrapper
    #  complaint was the latest, mksh's SCCS ident stamp before that) -
    #  rather than only ever reacting to the *next* one, cap the length
    #  here as a general backstop: a real "no --version flag" answer
    #  (dash, mksh's own non-error fallback shapes) is short, sentence-
    #  length prose reads as an unrecognized error, not a version, and
    #  should defer to package_info's own fallback (see
    #  resolve_language) rather than ever display raw error text as if
    #  it meant something.
    first_line = raw.to_s.lines.first.to_s.strip
    first_line.length <= 40 ? first_line : nil
  end
rescue StandardError
  nil
end

# error_output?(text) - true if this looks like a shell's own
#  complaint about an unrecognized flag rather than a version string -
#  confirmed directly, `dash --version`/`-version` (dash has no version
#  flag at all) and `mksh --version` (see :ksh_env - it doesn't
#  understand long options) both fail exactly this way rather than
#  merely printing nothing, so an empty-output retry alone isn't enough
#  to catch them. Rather than special-casing every shell that might do
#  this, just recognize the shape of the complaint generically.
def error_output?(text)
  return true if text.to_s.strip.empty?

  # "not found"/"no such file" - confirmed directly with cpanm.bat, a
  #  Windows launcher found via /mnt/c under WSL1 that resolve_binary
  #  happily locates (it's a real file) but a Linux shell can't actually
  #  execute (wrong format entirely, not just a missing flag).
  # "\w+_HOME not set" - confirmed directly with groovy under WSL2: its
  #  own wrapper script complains "JAVA_HOME not set and cannot find
  #  javac to deduce location, please set JAVA_HOME." when probed
  #  without a JVM configured, rather than a real version - not a "bad
  #  flag" complaint at all, so none of the patterns above catch it,
  #  and it doesn't contain a digit run either, so it fell all the way
  #  through to probe_version's own "just use the first line" fallback
  #  and got displayed as if it were the version. The *_HOME pattern is
  #  generic (not hardcoded to JAVA_HOME) since this is a common shape
  #  for JVM tool wrappers generally (GROOVY_HOME, MAVEN_HOME, ...), any
  #  of which could plausibly hit the exact same wall.
  text.to_s.lines.first.to_s =~ /illegal option|unknown option|unrecognized option|invalid option|not recognized|not found|no such file|\w+_HOME not set/i ? true : false
end

# tcl_version(path) - `echo "puts $tcl_patchLevel" | tclsh` is tempting
#  but wrong: confirmed directly, piping through cmd.exe's own `echo`
#  on native Windows Ruby hands tclsh a *single* pre-mangled token
#  ("puts 9.0.1", i.e. $tcl_patchLevel already substituted and glued to
#  "puts" with no space) rather than the two separate words "puts" and
#  "$tcl_patchLevel" tclsh needs to parse it as a command - cmd.exe's
#  own echo/pipe handling isn't POSIX shell semantics. Writing the
#  one-liner to a real temp file and running `tclsh thatfile` instead
#  sidesteps the whole question of how "echo | tclsh" gets tokenized on
#  any given shell, on any platform.
#
#  $tcl_patchLevel, not $tcl_version - confirmed directly $tcl_version
#  only ever carries major.minor ("8.6"), silently dropping the patch
#  level ("8.6.12") a distro package's own version string does include -
#  showing the coarser variable here would make this report *less*
#  precise than dpkg for no reason, defeating the whole point of
#  preferring a tool's own self-report (see resolve_entry).
def tcl_version(path)
  require 'tmpdir'
  Dir.mktmpdir do |dir|
    script = File.join(dir, 'tcl_version_probe.tcl')
    File.write(script, "puts $tcl_patchLevel\n")
    `"#{path}" "#{script}" < #{NULL_DEVICE} 2>&1`.strip
  end
end

# build_report - pure data (no formatting) - {platform:, areas: [...]},
#  each language carrying its own resolved binary/path/version plus a
#  "tools" array of its dependent tooling in the same shape, so a
#  formatter never needs to special-case "a tool" vs "a language".
def build_report
  prefetch_package_info!
  uname = uname_string
  {
    uname: uname,
    platform: match_platform(uname),
    ruby: RUBY_PLATFORM,
    areas: AREAS.map do |area|
      {
        name: area[:name],
        languages: area[:languages].map { |lang| resolve_language(lang) }
      }
    end
  }
end

def resolve_language(lang)
  entry = resolve_entry(lang[:bin], lang[:version])
  # Tools are only meaningful as *dependent* tooling for this specific
  #  language's own lessons - if the language's own compiler/
  #  interpreter isn't even present, there's nothing for them to be
  #  dependent tooling for. Confirmed directly this matters most for
  #  Batch: on any non-Windows platform cmd.exe is never found at all,
  #  so listing date.exe/grep.exe as if they were relevant Batch
  #  tooling would be actively misleading, not just extra noise -
  #  same reasoning applies to e.g. "make" under a missing compiler.
  #  Skipped rather than resolved-and-hidden, so no subprocess time is
  #  spent probing tools nothing can use anyway.
  tools = entry[:found] ? resolve_tools(lang) : []
  # windows_only/unix_only carried through from the AREAS entry itself
  #  (nil for the common case, e.g. PowerShell - genuinely cross-
  #  platform, so a real MISSING is still the right word for it even
  #  on macOS/Linux) - see status_text/platform_inapplicable? for what
  #  reads these.
  entry.merge(name: lang[:name], binaries: lang[:bin], tools: tools, windows_only: lang[:windows_only], unix_only: lang[:unix_only])
end

# resolve_tools(lang) - a tools: entry is normally a plain tool name
#  (e.g. "make"), but can also be an array of [real-name, search-only
#  hint, ...] - same "tcl"/"jvm" trick languages already use for
#  chocolatey_owner's tag search, just plumbed through Array() so the
#  common single-name case doesn't need to change shape at all.
def resolve_tools(lang)
  (lang[:tools] || []).map do |tool|
    next resolve_psake_module if tool == :psake

    names = Array(tool)
    # native_tools: true (Batch's own AREAS entry) means these tools
    #  need to be reachable via cmd.exe's real PATH specifically, not
    #  wherever Ruby itself happens to be running from - see
    #  windows_native_path_dirs.
    dirs = lang[:native_tools] ? windows_native_path_dirs : nil
    resolve_entry(names, :flag, dirs).merge(name: names.first)
  end
end

# resolve_psake_module - psake has no real executable to find via
#  find_on_path/resolve_entry at all (see its own :psake dispatch
#  comment on PowerShell's AREAS entry) - queries pwsh's own installed-
#  module list directly instead, the same source PowerShell's own
#  command auto-loading already relies on (see run_all_tests.ps1's
#  Invoke-PsakeRun, which never Import-Modules it either). Returns the
#  same {binaries:, found:, resolved_binary:, package_name:, path:,
#  version:} shape resolve_entry does, so table_row/every formatter
#  handles this row identically to a real tool's.
def resolve_psake_module
  pwsh = find_on_path('pwsh') || find_on_path('powershell')
  return { binaries: %w[psake], found: false, resolved_binary: nil, package_name: nil, manager: nil, path: nil, version: nil, name: 'psake' } unless pwsh

  raw = `"#{pwsh}" -NoProfile -Command "(Get-Module -ListAvailable -Name psake | Select-Object -First 1).Version.ToString()" 2>#{NULL_DEVICE}`.strip
  found = !raw.empty? && raw !~ /error|not recognized|exception/i

  {
    binaries: %w[psake],
    found: found,
    resolved_binary: found ? 'psake' : nil,
    package_name: nil,
    manager: nil,
    path: nil,
    version: found ? raw : nil,
    name: 'psake'
  }
end

# ENTRY_CACHE - [real path, version_mode] -> the {resolved_binary:,
#  package_name:, path:, version:} portion of resolve_entry's own
#  result - i.e. everything that costs a subprocess call to compute,
#  memoized across every call site that happens to resolve to the same
#  underlying file. Confirmed directly this matters beyond just
#  package_info's own cache (see its comment): WSH JScript and WSH
#  VBScript both resolve to the identical cscript.exe, which isn't
#  package-owned on Cygwin at all - package_info correctly caching its
#  own "not owned" answer still leaves probe_version's *own* --version
#  subprocess call running twice for the exact same file. This caches
#  the whole computed result instead, so a repeat path is a total no-op
#  the second time, not just a partial one.
ENTRY_CACHE = {}

# normalize_version(raw) - a distro package's own version string
#  routinely carries packaging metadata a human just wants stripped for
#  a quick "is this new enough" glance: an optional leading epoch
#  ("1:"), then everything from the first character that isn't a digit
#  or dot onward - a Debian upstream suffix like
#  "+git20210903+057cd650a4ed", a pre-release marker like "~beta.2", or
#  the packaging revision itself ("-3build1"/"-1ubuntu0.2"). Only ever
#  applied to a *package's* own version (see resolve_entry) - a tool's
#  own self-reported --version already comes back close to this shape
#  (see probe_version), so this never touches it.
def normalize_version(raw)
  return raw unless raw

  raw[/\A(?:\d+:)?(\d+(?:\.\d+)*)/, 1] || raw
end

# resolve_entry(candidates, version_mode) - shared by resolve_language
#  (a language) and its own "tools" list (its dependent tooling) - both
#  need the exact same resolve/package-lookup/version-fallback shape, so
#  a formatter can treat a language row and a tool row identically (see
#  table_row, which is handed either one without caring which).
#  package_info (real package metadata, when a package manager is
#  available) still takes priority over probe_version for *naming* -
#  see package_info's own comment for why that's preferred there (e.g.
#  surfacing "ksh" -> "ksh93u+m"). Versions are the opposite priority:
#  confirmed directly a distro package's version routinely carries
#  packaging noise a tool's own --version never does (dash's
#  "0.5.11+git20210903+057cd650a4ed-3build1" vs. bash's own clean
#  "5.1.16" self-report, where dpkg would otherwise show
#  "5.1-6ubuntu1.1") - so the tool's own self-reported version (or a
#  per-tool special case - see probe_version) is tried first, falling
#  back to the package's own (normalized - see normalize_version) only
#  when nothing usable comes back at all (dash has no --version flag,
#  so it has no other source).
def resolve_entry(candidates, version_mode, path_dirs = nil)
  name, path = resolve_binary(candidates, path_dirs)
  real = path && realpath(path)
  cached = real && ENTRY_CACHE.key?([real, version_mode]) && ENTRY_CACHE[[real, version_mode]]

  computed = cached || begin
    pkg = package_info(path, candidates)
    {
      resolved_binary: pkg ? pkg[:name] : name,
      # Kept separate from resolved_binary (which always has *some*
      #  value, even a package manager, e.g. "cmd" for Batch) -
      #  table_row only wants to flag an actual package-identity
      #  discovery like "ksh" -> "mksh", not every ordinary case where
      #  the candidate name searched for isn't identical to the
      #  language's own display name.
      package_name: pkg && pkg[:name],
      manager: pkg && pkg[:manager],
      path: to_posix(path),
      version: probe_version(name, path, version_mode) || (pkg && normalize_version(pkg[:version]))
    }
  end
  ENTRY_CACHE[[real, version_mode]] = computed if real && !cached

  { binaries: candidates, found: !path.nil? }.merge(computed)
end

# ---------------------------------------------------------------------
# Formatters
# ---------------------------------------------------------------------

def format_table(report)
  widths = table_widths(report)

  lines = [
    "Platform: #{report[:platform] || 'unrecognized'} (#{report[:uname]})",
    "Ruby:     #{report[:ruby]}",
    ''
  ]
  report[:areas].each do |area|
    lines << "== #{area[:name]} =="
    lines << table_header(widths)
    area[:languages].each do |lang|
      lines << table_row(lang[:name], lang, '', widths)
      lang[:tools].each_with_index { |tool, i| lines << table_row(tool[:name], tool, tool_prefix(lang[:tools], i), widths) }
    end
    lines << ''
  end
  lines.join("\n")
end

# tool_prefix(tools, index) - "  └─ " (tree-branch "last child")
#  for the last entry in `tools`, "  ├─ " (tree-branch "more
#  siblings follow") for every other one - real box-drawing characters
#  instead of the plain-ASCII "\_" stand-in this used before, per direct
#  request ("not very attractive"). A language row itself (top-level,
#  not a tool) gets no prefix at all - callers pass '' for that case
#  rather than calling this.
def tool_prefix(tools, index)
  glyph = index == tools.length - 1 ? '└─' : '├─'
  "  #{glyph} "
end

# table_header(widths) - column header line, same layout table_row
#  itself uses. Package became its own always-shown column (see
#  row_parts) instead of a conditional "Label [pkg]" suffix - that older
#  form was self-explanatory without a header; a bare extra column of
#  text on every row isn't.
TABLE_HEADERS = %w[Name Package Status Version].freeze

def table_header(widths)
  format("%-#{widths[0]}s %-#{widths[1]}s %-#{widths[2]}s %-#{widths[3]}s %s", *TABLE_HEADERS, 'Path')
end

# table_widths(report) - [label_width, package_width, status_width,
#  version_width], each sized to the longest value that will actually
#  appear in that column across the whole report *or* its own header
#  label, whichever is longer - a short report (e.g. everything resolved
#  to a 3-char package like "cmd") would otherwise misalign under a
#  wider header like "Package". A fixed guess (the original approach)
#  silently breaks alignment for every row after the first one whose
#  content runs longer than the guess - confirmed directly with a Debian
#  epoch version string ("1:5.1.0-1ubuntu0.2"), which exceeds a fixed
#  14-char guess. Recomputed from the already-built report (pure string
#  ops on data already resolved by build_report), not by re-probing any
#  binary.
def table_widths(report)
  parts = report[:areas].flat_map do |area|
    area[:languages].flat_map do |lang|
      [row_parts(lang[:name], lang, '')] + lang[:tools].each_with_index.map { |tool, i| row_parts(tool[:name], tool, tool_prefix(lang[:tools], i)) }
    end
  end
  (0..3).map { |i| ([TABLE_HEADERS[i].length] + parts.map { |p| p[i].length }).max }
end

# row_parts(label, entry, prefix) - [label, package, status, version,
#  path] as plain strings, no column padding applied yet - shared by
#  table_widths (which only needs each string's length) and table_row
#  (which pads them once the real widths are known).
# display_path(path) - collapses a leading $HOME into "~", the
#  universal POSIX shorthand for a user's own home directory - only
#  ever used by the human-readable table (see row_parts); JSON/YAML/CSV/
#  etc. keep the real absolute path, since those are for another tool
#  to consume, not a person to read. Windows paths are left alone - "~"
#  has no such meaning there.
def display_path(path)
  return path if path.nil? || Gem.win_platform?

  home = ENV['HOME']
  return path if home.nil? || home.empty?

  if path == home
    '~'
  elsif path.start_with?("#{home}/")
    "~#{path[home.length..]}"
  else
    path
  end
end

# STATUS_UNAVAILABLE - shorter than "unavailable" itself, which is what
#  this stood for originally - used in place of "MISSING" for a
#  language that's expected to be absent given the current platform
#  (Batch/WSH JScript/WSH VBScript on non-Windows; the Shell Scripts
#  area's shells on native Windows - see platform_inapplicable?) rather
#  than a real gap worth flagging. "MISSING" implies something's wrong;
#  this doesn't.
STATUS_UNAVAILABLE = 'N/A'

# platform_inapplicable?(entry) - true if `entry`'s own windows_only/
#  unix_only tag (set in AREAS, carried through by resolve_language)
#  doesn't match the platform this report is actually running on.
#  Gem.win_platform? is true for both a native and a Cygwin-hosted Ruby
#  (see native_windows_ruby?'s own comment on that distinction) - the
#  right line here, since cmd.exe/cscript.exe are equally reachable
#  either way, and a POSIX shell is equally "not the default" either
#  way. Doesn't special-case WSL1's own real-Windows-tools-via-/mnt/c
#  reachability (see AREAS's own Batch comment) - a WSL1 Ruby that's
#  genuinely Linux-native reports Gem.win_platform? false, so a Batch
#  entry that's actually unreachable there still reads MISSING, not
#  N/A; a real find still overrides this either way (see status_text),
#  so the only effect is which word an already-absent WSL1 Batch gets.
def platform_inapplicable?(entry)
  win = Gem.win_platform?
  (entry[:windows_only] && !win) || (entry[:unix_only] && win)
end

# status_text(entry) - 'OK' / 'MISSING' / STATUS_UNAVAILABLE, in that
#  priority order: found always wins regardless of windows_only/
#  unix_only (e.g. bash actually installed on Windows via Git-Bash/
#  Cygwin/MSYS2 is still just OK, not something to second-guess).
def status_text(entry)
  return 'OK' if entry[:found]
  return STATUS_UNAVAILABLE if platform_inapplicable?(entry)

  'MISSING'
end

def row_parts(label, entry, prefix)
  status = status_text(entry)
  # Always its own column now, even when it's the same word as the
  #  label (e.g. "Ruby" / "ruby") - previously this only showed at all
  #  when it differed from label, folded into "Label [pkg]" inline. A
  #  steady column position is worth the occasional redundant-looking
  #  row; a column that silently vanishes depending on the data isn't.
  ["#{prefix}#{label}", entry[:package_name] || '-', status, entry[:version] || '-', display_path(entry[:path]) || '-']
end

def table_row(label, entry, prefix, widths)
  format("%-#{widths[0]}s %-#{widths[1]}s %-#{widths[2]}s %-#{widths[3]}s %s", *row_parts(label, entry, prefix))
end

def format_json(report)
  JSON.pretty_generate(report)
end

def format_yaml(report)
  # Symbol keys serialize as "!ruby/symbol foo" under Psych's default
  #  round-trip-safe dump - stringify keys first so plain "foo:" comes out
  #  instead, since this output is for a human/other tool to read, not to
  #  be reloaded back into this same Ruby structure.
  YAML.dump(JSON.parse(JSON.generate(report)))
end

# format_csv(report) - one row per language, one row per tool
#  (Parent naming which language it belongs to) - flat and spreadsheet-
#  friendly rather than nested like table/json/yaml, since CSV has no
#  natural way to represent the tools: sub-list otherwise. Platform/Ruby
#  (table's own header lines) are left out - they're not rows of the
#  same shape as everything else, and CSV has no clean way to carry
#  metadata alongside a single tabular header row. Built with the
#  stdlib csv library rather than joining strings with commas by hand -
#  a path or package name containing a comma, quote, or space needs
#  real quoting/escaping to round-trip correctly, the same reasoning
#  against hand-rolling already applied to path conversion elsewhere in
#  this file (cygpath/wslpath instead of guessing at the mount table).
#
#  require 'csv' happens here, lazily, rather than at file load time -
#  confirmed directly this matters: csv stopped being a default gem as
#  of Ruby 3.4, so a Ruby that doesn't have it installed as a real gem
#  would fail to even *load* this file at all otherwise - breaking
#  every other script in this project that requires_relative
#  verify_commands.rb purely for its detection helpers and never
#  touches CSV output, not just the (actually rare) case of someone
#  asking for --format csv without the gem installed.
def format_csv(report)
  require 'csv'
  CSV.generate do |csv|
    csv << %w[Area Name Kind Parent Status Version Package Manager Path]
    report[:areas].each do |area|
      area[:languages].each do |lang|
        csv << [area[:name], lang[:name], 'language', nil, status_text(lang), lang[:version], lang[:package_name], lang[:manager], lang[:path]]
        lang[:tools].each do |tool|
          csv << [area[:name], tool[:name], 'tool', lang[:name], status_text(tool), tool[:version], tool[:package_name], tool[:manager], tool[:path]]
        end
      end
    end
  end
end

# MANAGER_ICONS - one glyph per :manager tag (see tag_manager) for
#  format_tui's Package column. Only :pacman/:cygcheck/:apt/:homebrew/
#  :chocolatey/:sdkman/:rbenv/:rustup/:pyenv are wired to a real
#  detector anywhere in this file (see lookup_package_info) - an
#  ordinary PATH-only resolution (no package-manager owner found at
#  all) gets no icon at all today, which is most tools - see
#  MANAGER_ICON_FALLBACK. cpan/gem/jar/composer detection doesn't exist
#  yet; add a new tag_manager call site and a MANAGER_ICONS entry
#  together if one gets built later, same pattern as every manager
#  already here (pyenv itself is exactly that pattern applied to
#  Python: see pyenv_owner).
MANAGER_ICONS = {
  chocolatey: '🍫', # also stands in for a future plain NuGet-only detector
  homebrew: '🍺',
  apt: '📦',
  cygcheck: '📦',
  pacman: '📦', # also stands in for a future rpm/other-system-package detector
  sdkman: '⚙️', # version manager
  rbenv: '⚙️',  # also a version manager - same icon as sdkman, same category
  rustup: '⚙️', # ditto
  pyenv: '⚙️'   # ditto
}.freeze
# Blank, not a "?"/"unknown" glyph of any kind - an unmatched manager is
#  the ordinary case (see MANAGER_ICONS's own comment), not an error
#  condition worth calling attention to on every other row.
MANAGER_ICON_FALLBACK = ''

def manager_icon(manager)
  MANAGER_ICONS.fetch(manager, MANAGER_ICON_FALLBACK)
end

# pkg_cell(entry) - the Package column's own text: icon prefixed
#  directly onto the package name (not a separate column) - so the icon
#  reads as "what kind of package is *this*", not as another fact about
#  the language/tool row it happens to sit on. No leading space at all
#  when there's no icon (MANAGER_ICON_FALLBACK is blank), rather than a
#  permanent blank gutter character in front of every unmatched row.
def pkg_cell(entry)
  pkg = entry[:package_name] || '-'
  icon = manager_icon(entry[:manager])
  icon.empty? ? pkg : "#{icon} #{pkg}"
end

# format_tui(report) - interactive bordered-table view via the
#  ratatui_ruby gem (https://rubygems.org/gems/ratatui_ruby, LGPL-3.0),
#  a Rust-backed TUI library - not a default dependency of this project
#  (see format_csv's own comment on why 'csv' is require'd lazily here
#  rather than at file load time; same reasoning, doubly so for a gem
#  that isn't even in Ruby's standard library). `gem install
#  ratatui_ruby` first. No precompiled native gem exists for Intel
#  macOS (x86_64-darwin) as of this writing - confirmed directly against
#  rubygems.org's own version list, which has arm64-darwin, x86_64-
#  linux, and x64-mingw-ucrt fat gems plus a source "ruby" platform gem
#  - an Intel Mac falls through to that source gem and needs a local
#  Rust toolchain (rustc/cargo) to compile it.
#
#  Arrow-key row selection (highlighted row, q/Esc to quit) plus a
#  footer summary - matching ratatui.rs's own table example
#  (https://ratatui.rs/examples/widgets/table/), per direct request
#  after a screenshot of that example's actual rendered output. `rows:`
#  and `selected` are plain values rebuilt every frame from a local
#  `selected` index this method owns itself - ratatui_ruby's table
#  factory takes `selected_row:` directly (a plain Integer), so there's
#  no need for the separate TableState/render_stateful_widget path
#  real ratatui's own Rust API requires for the same feature.
def format_tui(report)
  # Confirmed directly: with stdin redirected from /dev/null, this
  #  still gets past init_terminal cleanly and just blocks forever on
  #  the first poll_event, since no real key event can ever arrive -
  #  no error, no output, nothing to Ctrl-C into from a script that
  #  invoked this expecting "print and exit" like every other
  #  formatter. Every other FORMATTERS entry is safe to run from a
  #  pipe/CI job; this is the one exception, so it gets its own upfront
  #  check rather than a silent hang discovered the hard way.
  unless $stdout.tty?
    raise "format_tui needs an interactive terminal (stdout isn't a TTY) - use --format text instead"
  end

  require 'ratatui_ruby'

  groups = area_groups(report)
  total_rows = groups.sum { |_name, pairs| pairs.length }
  found_count = groups.sum { |_name, pairs| pairs.count { |entry, _prefix| entry[:found] } }

  selected = 0

  RatatuiRuby.run do |tui|
    bold = tui.style(modifiers: [:bold])
    highlight = tui.style(fg: :black, bg: :yellow, modifiers: [:bold])
    italic = tui.style(modifiers: [:italic])

    loop do
      tui.draw { |frame| draw_tui_frame(tui, frame, report, groups, selected, bold, highlight, italic, found_count, total_rows) }

      # poll_event with no timeout blocks indefinitely (confirmed
      #  directly against the gem's own Rust source, events.rs -
      #  poll_data_accepts_none_timeout_for_indefinite_blocking) until a
      #  real event arrives - no busy-wait/sleep needed.
      event = tui.poll_event
      next unless event.key?

      break if event.esc? || event.char == 'q'

      selected = (selected - 1) % total_rows if event.up? && total_rows.positive?
      selected = (selected + 1) % total_rows if event.down? && total_rows.positive?
    end
  end
  nil
end

# area_groups(report) - [[area_name, [[entry, prefix], ...]], ...],
#  one group per AREA (Windows Scripts/Shell Scripts/General Scripts/
#  Compiled Languages) rather than a single flattened list - see
#  draw_tui_frame's own comment for why format_tui stopped flattening
#  every area into one table. `prefix` is '' for a language row, or
#  tool_prefix's tree-branch glyph for a tool row - computed once here
#  rather than by every caller, same reasoning as table_widths/
#  format_table sharing it on the text-table side.
def area_groups(report)
  report[:areas].map do |area|
    pairs = area[:languages].flat_map do |lang|
      [[lang, '']] + lang[:tools].each_with_index.map { |tool, i| [tool, tool_prefix(lang[:tools], i)] }
    end
    [area[:name], pairs]
  end
end

# draw_tui_frame(...) - one titled, bordered sub-block per area instead
#  of a single table spanning the whole report - confirmed directly
#  from a screenshot that a single flat table reads as one
#  undifferentiated wall of rows, no visual seam between e.g. "Windows
#  Scripts" and "Shell Scripts" at all. Each area keeps its own header
#  row (ratatui's own column-width engine, computed per table) rather
#  than one hand-aligned shared header pulled out separately above them
#  all - a shared header's spacing would drift out of sync with each
#  table's own internal column math the moment row content differs
#  between areas, since nothing would keep the two in sync.
#
#  Borders are collapsed between adjacent areas: every area block draws
#  only [:top, :left, :right] (never :bottom) - so the boundary between
#  two stacked areas is drawn exactly once, by the area *below*, not
#  twice as two independent full boxes touching would. The very last
#  seam is closed by the outer platform-title block's own bottom border
#  instead, the same way the first area's top seam is closed by the
#  outer block's top border.
#
#  Selection stays a single flat index across every area (not one
#  per-area selection) - see format_tui's own `selected`/up?/down?
#  handling - so arrow-key navigation flows seamlessly from the last
#  row of one area into the first row of the next, matching how a
#  single table would have behaved before this split. Only the area
#  the globally-selected row actually falls in gets a `selected_row:`;
#  every other area's table renders with none.
def draw_tui_frame(tui, frame, report, groups, selected, bold, highlight, italic, found_count, total_rows)
  outer = tui.block(
    title: " #{report[:platform] || 'unrecognized'} (#{report[:uname]}) (q to quit, up/down to navigate) ",
    borders: [:all],
    border_type: :rounded
  )
  frame.render_widget(outer, frame.area)
  inner = outer.inner(frame.area)

  # Leftover vertical space (a terminal taller than the report actually
  #  needs) split evenly across every area's own Length constraint,
  #  rather than left as one unused block below the footer - confirmed
  #  directly from a screenshot that plain content-sized Length
  #  constraints left most of a tall terminal empty. Computed by hand
  #  instead of switching each area to Constraint::Min and letting
  #  ratatui's own solver grow them - confirmed directly that doesn't
  #  distribute evenly either: with four Min constraints, one area
  #  (arbitrarily, not first or last) absorbed 100% of the slack while
  #  the other three stayed at their bare minimum.
  needed = groups.map { |_name, pairs| pairs.length + 1 }
  footer_height = 1
  extra = [inner.height - needed.sum - footer_height, 0].max
  base_extra = extra / groups.length
  remainder = extra % groups.length
  heights = needed.each_with_index.map { |h, i| h + base_extra + (i < remainder ? 1 : 0) }
  constraints = heights.map { |h| tui.constraint_length(h) } + [tui.constraint_length(footer_height)]
  rects = tui.layout_split(inner, direction: :vertical, constraints: constraints)

  offset = 0
  groups.each_with_index do |(name, pairs), i|
    local_selected = selected - offset
    local_selected = nil unless (0...pairs.length).cover?(local_selected)

    table = tui.table(
      header: %w[Name Package Status Version Path].map { |text| tui.paragraph(text: text, style: bold) },
      rows: pairs.map { |entry, prefix| tui_row(tui, entry, prefix) },
      widths: [26, 24, 9, 12, 40],
      column_spacing: 1,
      selected_row: local_selected,
      row_highlight_style: highlight,
      highlight_symbol: '👉 ',
      # Default is :when_selected - confirmed directly that leaves each
      #  area's own gutter width dependent on whether *that* table
      #  currently happens to hold the selection, so every column across
      #  every other (unselected) area visibly shifts left/right by the
      #  highlight symbol's width as selection crosses an area boundary.
      #  :always reserves the same gutter in every area's table
      #  regardless of its own selection state, keeping columns aligned.
      highlight_spacing: :always,
      block: tui.block(title: " #{name} ", borders: %i[top left right])
    )
    frame.render_widget(table, rects[i])
    offset += pairs.length
  end

  footer = tui.paragraph(text: "#{found_count}/#{total_rows} found", style: italic)
  frame.render_widget(footer, rects.last)
end

# STATUS_COLORS - fg color per status_text value; anything not listed
#  (there's nothing else status_text can return) falls back to :white,
#  never reached in practice.
STATUS_COLORS = {
  'OK' => :green,
  'MISSING' => :red,
  STATUS_UNAVAILABLE => :dark_gray # neutral, not alarming - see STATUS_UNAVAILABLE's own comment
}.freeze

# status_cell(tui, entry) - the Status column's own colored Paragraph -
#  color only exists in the TUI (row_parts/format_csv's plain-text
#  status stays uncolored ANSI-free text, right for output another
#  tool or a redirected file might consume).
def status_cell(tui, entry)
  text = status_text(entry)
  tui.paragraph(text: text, style: tui.style(fg: STATUS_COLORS.fetch(text, :white)))
end

# tui_row(tui, entry, prefix) - [name, package, status, version, path]
#  for one format_tui row - the TUI's own equivalent of row_parts, kept
#  separate rather than reused because the two have nothing but field
#  names in common: row_parts returns pre-padded plain strings for a
#  fixed-width text line, this returns raw values for ratatui_ruby's
#  own table widget to lay out. Package carries its own manager icon
#  (see pkg_cell) rather than a dedicated leading column - the icon
#  describes the package, not the language/tool. Needs `tui` itself
#  (unlike row_parts) only because status_cell does - building a
#  styled Paragraph cell needs a live TUI instance, same reason the
#  bold header Paragraphs get built inside RatatuiRuby.run and not
#  before it (see format_tui's own comment). `prefix` comes from
#  area_groups (tool_prefix's tree-branch glyph, or '' for a language
#  row) rather than being computed here, same as row_parts.
def tui_row(tui, entry, prefix)
  [
    "#{prefix}#{entry[:name]}",
    pkg_cell(entry),
    status_cell(tui, entry),
    entry[:version] || '-',
    display_path(entry[:path]) || '-'
  ]
end

# 'text' - the plain stdout report format_table has always produced.
#  Named for what it *is* (plain text to stdout), not how it's laid
#  out, so 'tui' has an unambiguous name of its own to sit alongside it
#  rather than overloading "table" to mean two different things.
FORMATTERS = {
  'text' => method(:format_table),
  'json' => method(:format_json),
  'yaml' => method(:format_yaml),
  'csv' => method(:format_csv),
  'tui' => method(:format_tui)
}.freeze

if __FILE__ == $PROGRAM_NAME
  # Defaults to the interactive TUI when actually run by a person at a
  #  terminal - the main way to play with this report now - and falls
  #  back to the plain text report otherwise (piped, redirected, CI), so
  #  nothing that invokes this non-interactively without an explicit
  #  --format breaks. Confirmed directly nothing in this project
  #  currently even could break either way: every caller
  #  (run_all_tests.rb/.ps1, compile_check.rb, generate_install_sh.rb,
  #  print_env_uname.rb) uses this file as a Ruby library
  #  (require/require_relative straight into package_info etc.) or
  #  shells out to a one-off `ruby -e`, never as a bare
  #  `ruby verify_commands.rb` - but the tty-based fallback is still the
  #  right default to have regardless, for whatever calls it that way
  #  next.
  format = $stdout.tty? ? 'tui' : 'text'
  OptionParser.new do |opts|
    opts.banner = 'Usage: verify.rb [--format text|json|yaml|csv|tui] ' \
                  '(defaults to tui at a terminal, text otherwise)'
    opts.on('-f FORMAT', '--format FORMAT', FORMATTERS.keys, "Output format (#{FORMATTERS.keys.join('|')})") do |f|
      format = f
    end
  end.parse!

  result = FORMATTERS.fetch(format).call(build_report)
  puts result unless result.nil?
end
