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
      { name: 'Korn Shell (ksh)',          bin: %w[ksh],       version: :flag, tools: %w[bc] },
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

# find_on_path(name) - a pure-Ruby PATH scan rather than shelling out to
#  `which`/`where` - this project's whole investigation this session
#  turned up just how inconsistent those external tools' own behavior is
#  across MSYS2/Cygwin/WSL1/native Windows, so this sidesteps all of that
#  entirely and just does the same directory-listing check those tools
#  would, directly.
def find_on_path(name)
  exts = Gem.win_platform? ? (ENV['PATHEXT'] || '.EXE;.BAT;.CMD;.COM').split(';') : ['']
  ENV['PATH'].to_s.split(File::PATH_SEPARATOR).each do |dir|
    exts.each do |ext|
      candidate = File.join(dir, "#{name}#{ext}")
      # File.join always uses "/" - normalize to the platform's own
      #  separator so a resolved path doesn't show a confusing mix of
      #  "\" (from PATH's own entries) and "/" (from here).
      candidate = candidate.tr('/', '\\') if Gem.win_platform?
      return candidate if File.file?(candidate)
    end
  end
  nil
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
    `"#{path}" -NoProfile -NonInteractive -Command "$PSVersionTable.PSVersion.ToString()" 2>&1`.strip
  when :cscript
    `#{path} 2>&1`[/Version (\S+)/, 1]
  when :tcl
    tcl_version(path)
  when :go
    `"#{path}" version 2>&1`[/go version go(\S+)/, 1]
  when :java
    raw = `"#{path}" -version 2>&1`
    raw[/version "([^"]+)"/, 1] || raw[/(\d+\.\d+\.\d+)/, 1]
  else # :flag - the common case, try --version then -version
    raw = `"#{path}" --version 2>&1`
    raw = `"#{path}" -version 2>&1` if raw.to_s.strip.empty?
    # Search the *whole* output, not just the first line - some tools
    #  (confirmed directly with Strawberry Perl) print a banner/blank
    #  line before the actual version text.
    raw.to_s[/\d+\.\d[\d.]*/] || raw.to_s.lines.first.to_s.strip
  end
rescue StandardError
  nil
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
  name, path = resolve_binary(lang[:bin])
  {
    name: lang[:name],
    binaries: lang[:bin],
    resolved_binary: name,
    found: !path.nil?,
    path: path,
    version: probe_version(name, path, lang[:version]),
    tools: (lang[:tools] || []).map do |tool|
      tname, tpath = resolve_binary([tool])
      { name: tname, found: !tpath.nil?, path: tpath, version: probe_version(tname, tpath, :flag) }
    end
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
  format('%-28s %-8s %-12s %s', "#{prefix}#{label}", status, entry[:version] || '-', entry[:path] || '-')
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
