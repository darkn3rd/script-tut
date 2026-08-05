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
#  Usage: ruby verify.rb [--format table|json|yaml]

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
      { name: 'Batch',        bin: %w[cmd],                version: :cmd },
      { name: 'PowerShell',   bin: %w[pwsh powershell],     version: :powershell },
      { name: 'WSH JScript',  bin: %w[cscript],             version: :cscript },
      { name: 'WSH VBScript', bin: %w[cscript],             version: :cscript },
    ]
  },
  {
    name: 'Shell Scripts',
    languages: [
      { name: 'Bourne Again Shell (bash)', bin: %w[bash],      version: :flag, tools: %w[bc getopt] },
      { name: 'C Shell (tcsh)',            bin: %w[tcsh csh],  version: :flag, tools: %w[bc] },
      { name: 'Korn Shell (ksh)',          bin: %w[ksh],       version: :ksh_env, tools: %w[bc] },
      { name: 'POSIX Shell (dash/sh)',     bin: %w[dash sh],   version: :flag, tools: %w[bc getopt perl] },
      { name: 'Z Shell (zsh)',             bin: %w[zsh],       version: :flag, tools: %w[bc] },
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
      { name: 'Ruby',    bin: %w[ruby],           version: :flag },
      { name: 'TCL',     bin: %w[tclsh],          version: :tcl },
    ]
  },
  {
    name: 'Compiled Languages',
    languages: [
      { name: 'C++',   bin: %w[g++ clang++ cl],  version: :flag,    tools: %w[make] },
      { name: 'C#',    bin: %w[dotnet],          version: :flag,    tools: %w[make] },
      { name: 'Go',    bin: %w[go],              version: :go,      tools: %w[make] },
      { name: 'Java',  bin: %w[javac java],      version: :java,    tools: %w[make] },
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

# find_on_path(name) - a pure-Ruby PATH scan rather than shelling out to
#  `which`/`where` - this project's whole investigation this session
#  turned up just how inconsistent those external tools' own behavior is
#  across MSYS2/Cygwin/WSL1/native Windows, so this sidesteps all of that
#  entirely and just does the same directory-listing check those tools
#  would, directly.
def find_on_path(name)
  # PATHEXT's own entries are conventionally uppercase (".EXE;.BAT;...")
  #  - NTFS is case-insensitive so this doesn't affect whether a file is
  #  actually found, but it would otherwise leak into the reported path
  #  as a jarringly-uppercase "cmd.EXE" even though the real file on disk
  #  is "cmd.exe" - downcase these before ever building a candidate.
  exts = Gem.win_platform? ? (ENV['PATHEXT'] || '.EXE;.BAT;.CMD;.COM').split(';').map(&:downcase) : ['']
  ENV['PATH'].to_s.split(File::PATH_SEPARATOR).each do |dir|
    exts.each do |ext|
      candidate = File.join(dir, "#{name}#{ext}")
      # File.join always uses "/" - normalize to a plain Windows path
      #  (kept as the *real*, executable path - see display_path for the
      #  MSYS2-POSIX-form conversion, applied only to the report's own
      #  output, never to what actually gets shelled out to).
      candidate = candidate.tr('/', '\\') if Gem.win_platform?
      return candidate if File.file?(candidate)
    end
  end
  nil
end

# display_path(path) - path form for the *report*, as opposed to
#  find_on_path's real, executable one. Under MSYS2 (ENV['MSYSTEM'] set)
#  this converts to MSYS2's own POSIX form - the form MSYS2's own
#  shell/tools actually use and a human at an MSYS2 prompt expects to
#  see. Deliberately never fed back into probe_version's own shell_out
#  calls - confirmed directly, a native Windows Ruby's Kernel#` is
#  cmd.exe-backed (see Msys2ShellScript in testbox/Script.rb) and
#  cmd.exe can no more resolve a POSIX path than File.file? can (same
#  underlying reason find_on_path itself has to check existence against
#  the Windows form, never the converted one).
#
#  Shells out to cygpath rather than hand-rolling the conversion -
#  confirmed directly this isn't just "/<lowercase-drive>/..." for every
#  path: MSYS2 mounts its own install root as "/" itself, so anything
#  under it maps *relative to that root* instead
#  ("C:\tools\msys64\usr\bin\make.EXE" -> "/usr/bin/make.EXE", not
#  "/c/tools/msys64/usr/bin/make.EXE"). cygpath already knows that whole
#  mount table authoritatively; reimplementing it here would just be
#  another way to get it subtly wrong.
def display_path(path)
  posix = to_posix(path)
  return posix unless posix

  # `which` itself never shows the executable extension for a bare-name
  #  lookup - confirmed directly, `which bc` -> "/usr/bin/bc", not
  #  "/usr/bin/bc.exe" - every lookup here is by bare name too (never
  #  "foo.exe"), so match that and strip it for display.
  posix.sub(/\.(exe|bat|cmd|com)\z/i, '')
end

# to_posix(path) - the real, on-disk path (extension intact, unlike
#  display_path) converted to MSYS2's own POSIX form - shared by
#  display_path and package_info's own pacman -Qo lookup, which needs
#  pacman's own idea of the path (an MSYS2-native tool, expecting a
#  POSIX path the same way its own PATH/cwd/argv all are) rather than
#  the Windows form actually used to invoke things.
def to_posix(path)
  return path unless path && Gem.win_platform? && ENV['MSYSTEM']

  cygpath = find_on_path('cygpath')
  return path unless cygpath

  `"#{cygpath}" -u "#{path}" 2>&1`.strip
end

# resolve_binary(candidates) - first candidate name actually found on
#  PATH, tried in the order listed (e.g. python3 before bare "python",
#  which some systems alias to python2 instead).
def resolve_binary(candidates)
  candidates.each do |name|
    path = find_on_path(name)
    return [name, path] if path
  end
  [candidates.first, nil]
end

# package_info(path) - {name:, version:} from this platform's own
#  package manager, given the file that's *actually* on disk - not
#  guessed from whatever name found it. Confirmed directly this
#  matters: MSYS2's own "ksh" binary is provided by a package literally
#  named "mksh", not "ksh" - the same kind of alias @@command_override
#  already has to handle for python2/python3 in testbox/Script.rb, just
#  discovered from the *package* side instead of the language side here.
#  Preferred over a plain --version probe (see probe_version) precisely
#  because it's package metadata - closer to what `pacman -Qi`/`apt-cyg
#  show` themselves report than a tool's own (sometimes missing, see
#  dash; sometimes needlessly verbose, see mksh's banner) self-reported
#  version string. nil if no package manager is available, or `path`
#  isn't a package-owned file at all (manually placed, or built from
#  source).
def package_info(path)
  return nil unless path

  if ENV['MSYSTEM'] && (pacman = find_on_path('pacman'))
    pacman_owner(pacman, path)
  elsif cygwin_environment? && (cygcheck = find_on_path('cygcheck'))
    cygcheck_owner(cygcheck, path)
  end
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

# pacman_owner(pacman, path) - `pacman -Qo <file>` prints
#  "<file> is owned by <pkgname> <pkgver>" - name and version in one
#  authoritative call, no separate "guess the package name" step needed.
def pacman_owner(pacman, path)
  raw = `"#{pacman}" -Qo "#{to_posix(path)}" 2>&1`.strip
  m = raw.match(/is owned by (\S+) (\S+)/)
  m && { name: m[1], version: m[2] }
rescue StandardError
  nil
end

# cygcheck_owner(cygcheck, path) - Cygwin's own file-ownership tool.
#  Unlike pacman -Qo, `cygcheck -f <file>` doesn't print a clean
#  "name version" pair - it prints the full package *specifier*
#  ("bash-5.2.21-1", "perl_base-5.44.0-1-x86_64") with no marked
#  boundary between name and version - and naively splitting on the
#  first "-" mis-parses any package whose own name contains one
#  (confirmed directly: "util-linux-2.40.2-2" is the package
#  "util-linux", not "util"). `cygcheck -c` with no argument lists
#  every installed package's own bare name in its first column - the
#  *longest* one the specifier actually starts with (followed by "-")
#  disambiguates correctly, then a second `cygcheck -c <name>` call gets
#  its clean version the same way pacman_owner gets its own in one shot.
def cygcheck_owner(cygcheck, path)
  spec = `"#{cygcheck}" -f "#{path}" 2>&1`.strip.lines.first.to_s.strip
  return nil if spec.empty? || spec =~ /not found|no package/i

  installed = `"#{cygcheck}" -c 2>&1`.lines.map { |l| l.split(/\s+/).first }.compact
  name = installed.select { |n| spec == n || spec.start_with?("#{n}-") }.max_by(&:length)
  return { name: spec, version: nil } unless name

  version_line = `"#{cygcheck}" -c "#{name}" 2>&1`.lines.find { |l| l.start_with?("#{name} ") }
  { name: name, version: version_line.to_s.split(/\s+/)[1] }
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

# linux_uname_string(release) - `uname -s` alone is just "Linux", no
#  distro info at all - env.yml keys Linux entries on distro+version
#  instead (e.g. "linux_ubuntu.26_04"), which only /etc/os-release's
#  ID/VERSION_ID actually carries.
def linux_uname_string(release)
  os_release = '/etc/os-release'
  return "linux.#{release.tr('.-', '__')}" unless File.exist?(os_release)

  fields = File.read(os_release).each_line.each_with_object({}) do |line, h|
    k, _, v = line.strip.partition('=')
    h[k] = v.delete('"')
  end
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
def match_platform(uname)
  env_file = File.join(__dir__, '..', 'config', 'env.yml')
  return nil unless File.exist?(env_file)

  tree = YAML.load_file(env_file)
  tree['environments']&.find { |e| Array(e['supports']).include?(uname) }&.fetch('platform', nil)
end

# probe_version(name, path, mode) - best-effort version string. This is
#  deliberately simpler than testbox/Script.rb's own per-environment
#  special_version methods (real cmd.exe/cscript.exe/tclsh version
#  strings need genuinely different probes - see Script.rb's
#  @@special_version_langs) - a report tool can settle for "close enough
#  to confirm it's installed", where the test harness can't.
def probe_version(name, path, mode)
  return nil unless path

  case mode
  when :cmd
    `#{path} /c ver 2>&1`[/Version ([\d.]+)/, 1]
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
    `"#{path}" -NoProfile -NonInteractive -Command #{quoted} 2>&1`.strip
  when :cscript
    `#{path} 2>&1`[/Version (\S+)/, 1]
  when :tcl
    tcl_version(path)
  when :go
    `"#{path}" version 2>&1`[/go version go(\S+)/, 1]
  when :java
    raw = `"#{path}" -version 2>&1`
    raw[/version "([^"]+)"/, 1] || raw[/(\d+\.\d+\.\d+)/, 1]
  when :ksh_env
    # `ksh` doesn't reliably resolve to a real AT&T/ksh93 build at all -
    #  confirmed directly, on MSYS2 it's the `mksh` package - and neither
    #  ksh93 nor mksh have a --version flag; both instead set their own
    #  $KSH_VERSION in every shell they start, which works identically
    #  whichever actual ksh implementation this resolves to.
    raw = `"#{path}" -c "echo $KSH_VERSION" 2>&1`.strip
    error_output?(raw) ? nil : raw
  else # :flag - the common case, try --version then -version
    raw = `"#{path}" --version 2>&1`
    raw = `"#{path}" -version 2>&1` if error_output?(raw)
    return nil if error_output?(raw)

    # Search the *whole* output, not just the first line - some tools
    #  (confirmed directly with Strawberry Perl) print a banner/blank
    #  line before the actual version text.
    raw.to_s[/\d+\.\d[\d.]*/] || raw.to_s.lines.first.to_s.strip
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

  text.to_s.lines.first.to_s =~ /illegal option|unknown option|unrecognized option|invalid option|not recognized/i ? true : false
end

# tcl_version(path) - `echo "puts $tcl_version" | tclsh` is tempting but
#  wrong: confirmed directly, piping through cmd.exe's own `echo` on
#  native Windows Ruby hands tclsh a *single* pre-mangled token
#  ("puts 9.0", i.e. $tcl_version already substituted and glued to
#  "puts" with no space) rather than the two separate words "puts" and
#  "$tcl_version" tclsh needs to parse it as a command - cmd.exe's own
#  echo/pipe handling isn't POSIX shell semantics. Writing the one-liner
#  to a real temp file and running `tclsh thatfile` instead sidesteps the
#  whole question of how "echo | tclsh" gets tokenized on any given
#  shell, on any platform.
def tcl_version(path)
  require 'tmpdir'
  Dir.mktmpdir do |dir|
    script = File.join(dir, 'tcl_version_probe.tcl')
    File.write(script, "puts $tcl_version\n")
    `"#{path}" "#{script}" 2>&1`.strip
  end
end

# build_report - pure data (no formatting) - {platform:, areas: [...]},
#  each language carrying its own resolved binary/path/version plus a
#  "tools" array of its dependent tooling in the same shape, so a
#  formatter never needs to special-case "a tool" vs "a language".
def build_report
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
  entry.merge(
    name: lang[:name],
    binaries: lang[:bin],
    tools: (lang[:tools] || []).map { |tool| resolve_entry([tool], :flag).merge(name: tool) }
  )
end

# resolve_entry(candidates, version_mode) - shared by resolve_language
#  (a language) and its own "tools" list (its dependent tooling) - both
#  need the exact same resolve/package-lookup/version-fallback shape, so
#  a formatter can treat a language row and a tool row identically (see
#  table_row, which is handed either one without caring which).
#  package_info (real package metadata, when a package manager is
#  available) takes priority over probe_version (the binary's own
#  self-reported --version, or a per-tool special case - see
#  probe_version) for both name and version - see package_info's own
#  comment for why that's preferred where it's available at all.
def resolve_entry(candidates, version_mode)
  name, path = resolve_binary(candidates)
  pkg = package_info(path)
  {
    binaries: candidates,
    resolved_binary: pkg ? pkg[:name] : name,
    # Kept separate from resolved_binary (which always has *some* value,
    #  even a package manager, e.g. "cmd" for Batch) - table_row only
    #  wants to flag an actual package-identity discovery like
    #  "ksh" -> "mksh", not every ordinary case where the candidate name
    #  searched for isn't identical to the language's own display name.
    package_name: pkg && pkg[:name],
    found: !path.nil?,
    path: display_path(path),
    version: (pkg && pkg[:version]) || probe_version(name, path, version_mode)
  }
end

# ---------------------------------------------------------------------
# Formatters
# ---------------------------------------------------------------------

def format_table(report)
  lines = [
    "Platform: #{report[:platform] || 'unrecognized'} (#{report[:uname]})",
    "Ruby:     #{report[:ruby]}",
    ''
  ]
  report[:areas].each do |area|
    lines << "== #{area[:name]} =="
    area[:languages].each do |lang|
      lines << table_row(lang[:name], lang, 0)
      lang[:tools].each { |tool| lines << table_row(tool[:name], tool, 1) }
    end
    lines << ''
  end
  lines.join("\n")
end

def table_row(label, entry, indent)
  status = entry[:found] ? 'OK' : 'MISSING'
  prefix = ('  ' * indent) + (indent.positive? ? '\_ ' : '')
  # Surface a genuine package-identity discovery, e.g. "ksh" actually
  #  provided by the "mksh" package on MSYS2 - not just an ordinary
  #  every-day mismatch between the display label and whatever bare
  #  command name was searched for (e.g. "Batch" vs "cmd"), which
  #  package_name (unlike resolved_binary) is never set for at all.
  pkg_name = entry[:package_name]
  # Case-insensitive - confirmed directly, "Perl" vs. package "perl"
  #  otherwise still counts as a "discovery" and shows a redundant
  #  "Perl [perl]".
  shown = pkg_name && !label.downcase.include?(pkg_name.downcase) ? "#{label} [#{pkg_name}]" : label
  format('%-36s %-8s %-14s %s', "#{prefix}#{shown}", status, entry[:version] || '-', entry[:path] || '-')
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

FORMATTERS = { 'table' => method(:format_table), 'json' => method(:format_json), 'yaml' => method(:format_yaml) }.freeze

if __FILE__ == $PROGRAM_NAME
  format = 'table'
  OptionParser.new do |opts|
    opts.banner = 'Usage: verify.rb [--format table|json|yaml]'
    opts.on('-f FORMAT', '--format FORMAT', FORMATTERS.keys, "Output format (#{FORMATTERS.keys.join('|')})") do |f|
      format = f
    end
  end.parse!

  puts FORMATTERS.fetch(format).call(build_report)
end
