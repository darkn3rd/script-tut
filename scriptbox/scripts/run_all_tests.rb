#!/usr/bin/env ruby
# run_all_tests.rb - runs `rake` (testbox's own Rake harness - see
#  testbox/testbox.rake's Script.print_summary) in every lesson
#  language directory across all four areas, printing each language's
#  own name/version/platform alongside its Total/Pass/Fail/Skip line as
#  soon as that language finishes, then one grand total summed across
#  every area at the end.
#
#  This is deliberately thin - Script.rb already does all the real
#  environment-detection and test-execution work (that's the whole
#  point of this project's own testbox harness); this script's only
#  job is to drive `rake` across every directory and collect its
#  already-well-defined output, the same way a human following
#  compiled_lang/README.md's own "Running by Hand" section would do one
#  directory at a time.
#
#  Usage: ruby run_all_tests.rb

require_relative 'verify_commands'
require 'timeout'

# WINEDEBUG=-all suppresses WINE's own debug-channel logging (all
#  channels) - confirmed directly this is needed: on macOS, WSH's own
#  JScript/VBScript areas run under WINE there, and its MoltenVK
#  backend prints diagnostic lines (e.g. "[mvk-info] MoltenVK version
#  1.4.1") to stdout/stderr that land right in the middle of Script.rb's
#  own combined output once merged via 2>&1 - sometimes interleaved
#  into the exact same line as a real "Language Version:" line, which
#  post-hoc line filtering can't reliably undo. Silencing it at the
#  source is the only fix that's actually robust against that
#  interleaving. ||= so an explicit WINEDEBUG the user already set
#  (e.g. for their own debugging) isn't clobbered.
ENV['WINEDEBUG'] ||= '-all'

LESSON_ROOT = File.expand_path('../../lessons', __dir__)

# RAKE_TIMEOUT - seconds before giving up on a single language's own
#  `rake` run rather than blocking the whole batch forever - confirmed
#  directly this is needed: a native-Windows run of the powershell area
#  hangs indefinitely (root cause not yet pinned down - possibly a
#  console prompt waiting on input despite the NULL_DEVICE stdin
#  redirect below). Timeout.timeout doesn't kill the underlying rake/
#  pwsh subprocess itself when it fires - just stops *this script* from
#  waiting on it - so a genuinely hung process is left running orphaned
#  rather than terminated; that's a real gap, but a script that finishes
#  reporting everything else (with one language marked TIMEOUT) is
#  still far more useful than one that never returns control at all.
RAKE_TIMEOUT = 120

# LANGUAGE_DIRS - every lesson language directory, grouped by area -
#  the same 22 directories verify_commands.rb's own AREAS/Compiled
#  Languages entries describe, but keyed by actual directory name
#  (win_scripts/wsh.jscript, not "WSH JScript") since that's what
#  Dir.chdir needs, not a display label.
LANGUAGE_DIRS = {
  'win_scripts' => %w[batch powershell wsh.jscript wsh.vbscript],
  'shell_scripts' => %w[bash csh ksh posix zsh],
  'gen_scripts' => %w[awk groovy perl php python2 python3 ruby tcl],
  'compiled_lang' => %w[cpp cs go java rust]
}.freeze

# ANSI - Script.rb's own colorize() wraps the Pass/Fail/Skip *labels* in
#  color codes unconditionally (no TTY check, confirmed directly by a
#  real `rake` run) - stripped before parsing rather than worked around
#  in the regexes themselves, so Total=/Pass=/Fail=/Skip= match the same
#  simple way regardless of whether color codes are present at all.
ANSI = /\e\[\d+m/.freeze

# run_rake(dir) - the raw, ANSI-stripped combined stdout+stderr of a
#  `rake` run in dir. stdin redirected from NULL_DEVICE for the same
#  reason compile_check.rb's own build_lesson already does this - a
#  hang here would freeze the whole run, not just one language. Wrapped
#  in RAKE_TIMEOUT as a second line of defense on top of that, for
#  whatever this class of hang turns out to be beyond simple stdin
#  starvation.
def run_rake(dir)
  rake = find_on_path('rake')
  return 'rake not found on PATH' unless rake

  Dir.chdir(dir) { Timeout.timeout(RAKE_TIMEOUT) { `"#{rake}" < #{NULL_DEVICE} 2>&1` } }.gsub(ANSI, '')
rescue Timeout::Error
  "ERROR: rake did not finish within #{RAKE_TIMEOUT}s (possibly hung)"
end

# NOT_INSTALLED - Script.rb's own PATH check (see its "Cannot find
#  ... on PATH" fatal check, run before any lesson executes) - matched
#  separately from parse_result's own fields so a genuinely missing
#  interpreter reads as a clean, expected skip rather than a raw
#  "could not parse rake output" dump - confirmed directly this is the
#  common case for languages nobody's installed on a given box (groovy,
#  python2, ...), not a real parsing failure.
NOT_INSTALLED = /ERROR: Cannot find "(\S+)" on PATH/.freeze

# trim_version(str) - just the leading "name + version number" portion
#  of a raw version banner, dropping everything from the first comma or
#  parenthesis onward - confirmed directly this is needed: gawk's own
#  Script.version answer is "GNU Awk 5.4.0, API 4.1, PMA Avon 8-g1,
#  (GNU MPFR 4.2.2, GNU MP 6.3.0)", PHP's is "PHP 8.1.28 (cli) (built:
#  ...) (NTS)" - neither is wrong, just far too verbose for a one-line
#  summary row. This only trims *display* here, in run_all_tests.rb's
#  own table - it doesn't touch testbox/Script.rb itself, which is the
#  real, separately-tested harness `rake` uses on its own.
#  Also returns nil for anything that looks like a shell's own "I don't
#  understand that flag" complaint rather than a real version - reusing
#  verify_commands.rb's own error_output? heuristic (already required
#  here) rather than reinventing it - confirmed directly this happens
#  for the same reason probe_version's own :ksh_env mode exists:
#  mksh (Cygwin/MSYS2's own "ksh") doesn't understand --version at all,
#  so Script.rb's own probe there comes back as literally
#  "ksh: ksh: --: unknown option" - not a version string, an error one.
#  "unknown" (not "-") specifically for the error case, distinct from a
#  plain missing value - the reason isn't "no data", it's "this probe
#  can't answer at all; only the package it came from could" (see
#  verify_commands.rb's own package_info, which is exactly how it gets
#  mksh's real version in that report instead of hitting this same
#  wall).
#  A generic digit-run match ("everything up to and including the
#  first dotted version number") rather than "truncate at the first
#  comma/paren" - confirmed directly the simpler truncation loses real
#  data on some banners: "sh" resolving to Git-for-Windows' own bash
#  answers "Shell (sh) = GNU bash, version 5.3.15(1)-release (...)",
#  where the version number itself comes *after* a comma - truncating
#  there would leave just "GNU bash", dropping "5.3.15" entirely. The
#  leading "Shell (xxx) = " Script.rb sometimes prefixes that same
#  answer with is stripped first so the real banner underneath is what
#  actually gets matched.
def trim_version(str)
  return nil if str.nil?
  return 'unknown' if error_output?(str)

  # "Windows Script Host Version 10.0" (WSH's own answer) is pure
  #  redundant boilerplate on top of that - the language column already
  #  says "JScript (WSH)"/"VBScript (WSH)", so keeping it here just
  #  pushed the version column wide enough to misalign everything after
  #  it - confirmed directly.
  # ksh93's own "version         sh (AT&T Research) 93u+m/1.0.10
  #  2022-08-25" answer (confirmed directly on macOS and WSL1 both) -
  #  same boilerplate-prefix shape as the other two, just with real
  #  info (a build tag, a date) after it that the plain digit-run match
  #  below would otherwise stop short at (it matches the bare "93" and
  #  gives up, since "u+m" isn't part of a dotted number).
  # "go version go1.26.4" (Go's own answer) repeats "go" twice for no
  #  reason useful here - the language column already says "Go".
  #  "Groovy Version: 5.0.7" is the same redundant-label shape too.
  cleaned = str.sub(/\AShell\s*\([^)]*\)\s*=\s*/i, '')
               .sub(/\AWindows Script Host Version\s+/i, '')
               .sub(/\Aversion\s+sh\s*\([^)]*\)\s*/i, '')
               .sub(/\Ago version\s+/i, '')
               .sub(/\AGroovy Version:\s*/i, '')
               .strip
  result = (cleaned[/\A.*?\d+(?:\.\d+)*/] || cleaned.split(/[,(\n]/).first.to_s).strip
  # Safety net, not a primary strategy - confirmed directly the
  #  targeted fixes above can't realistically cover every version
  #  banner shape this project's ~22 language areas might ever print;
  #  capping the length guarantees a new one can misalign this table's
  #  columns but can never mangle it entirely.
  result.length > 28 ? "#{result[0, 25]}..." : result
end

# WEAK_VERSION - Script.rb's own generic "couldn't determine a real
#  version" fallback for a shell with no --version at all (dash, same
#  reasoning as mksh's own error-string case just above, just a silent
#  placeholder instead of a raw error) - confirmed directly this is
#  literally just the word "Shell", not any kind of version number.
WEAK_VERSION = /\Ashell\z/i.freeze

# BARE_NUMBER - a lone 1-3 digit number with no dots (e.g. ksh93's own
#  truncated "93", see trim_version's own comment on that shape) -
#  suspicious enough on its own that resolve_version prefers real
#  package metadata over it when one's available, rather than trusting
#  it as a complete version.
BARE_NUMBER = /\A\d{1,3}\z/.freeze

# parse_result(output) - pulls the header (Language Target/Version/
#  Environment) and the final Summary line's four counts out of a
#  `rake` run's own output - see testbox/testbox.rake's header task and
#  Script.print_summary for the exact text this matches against. path
#  is the resolved binary Script.rb actually found (the "(...)" after
#  Language Target), used below both to show which concrete binary a
#  generic category like "POSIX Shell" resolved to (dash vs sh vs
#  ash, ...) and to fall back to real package metadata when Script.rb's
#  own version probe comes back weak or erroring.
def parse_result(output)
  # Greedy up to the *last* "(...)" on the line, not the first -
  #  confirmed directly Script.rb sometimes prints a second parenthetical
  #  as part of the language name itself (e.g.
  #  "Language Target:  JScript (WSH) (C:\Windows\System32\cscript.exe)"),
  #  and the earlier non-greedy version grabbed "(WSH)" as if it were
  #  the path - that bogus "WSH" string then got treated as a real file
  #  and matched against Chocolatey's tag search, landing on
  #  "powershell-core" by sheer coincidence. Ruby's ^/$ are line anchors
  #  by default (no /m needed), so this stays scoped to one line even
  #  though `output` itself is the whole multi-line rake run.
  target = output.match(/Language Target:\s+(.+)\s+\(([^)]+)\)\s*$/)
  {
    language: target && target[1],
    path: target && target[2],
    version: output[/Language Version:\s+(.+)/, 1],
    platform: output[/Environment:\s+(.+)/, 1],
    total: output[/Total=(\d+)/, 1]&.to_i,
    pass: output[/Pass=(\d+)/, 1]&.to_i,
    fail: output[/Fail=(\d+)/, 1]&.to_i,
    skip: output[/Skip=(\d+)/, 1]&.to_i
  }
end

# resolve_package(r) - verify_commands.rb's own package_info (already
#  required here) for whatever binary Script.rb actually resolved, or
#  nil if it isn't package-tracked (or no package manager exists).
#  Computed once per row and passed into both display_language and
#  resolve_version below, rather than each calling package_info
#  separately - PACKAGE_CACHE already memoizes by real path so a
#  second call would be cheap either way, but there's no reason to
#  make two calls for one row at all.
def resolve_package(r)
  return nil unless r[:path]

  package_info(r[:path], [File.basename(r[:path], '.*')])
end

# display_language(r, pkg) - the generic category Script.rb reports
#  (e.g. "POSIX Shell") plus, when it adds real information, the
#  binary's real *package* identity when known (e.g. "Korn Shell
#  (mksh)", not "Korn Shell (ksh)" - confirmed directly this is the
#  same package-vs-binary-name gap verify_commands.rb's own report
#  already surfaces: the installed package is "mksh", "ksh" is just
#  the executable name it provides), falling back to the resolved
#  binary's own filename when no package identity is available at all.
#  Suppressed when that name is already part of the label (e.g.
#  "Bourne Again Shell (bash)" already says "bash"), using a
#  word-boundary match rather than a plain substring check - confirmed
#  directly a raw .include? is the same short-generic-string trap
#  already hit with Chocolatey matching earlier: "sh" (a real, common
#  resolution here - Git for Windows' own sh.exe) is a substring of
#  "Shell" itself, which would wrongly suppress "POSIX Shell (sh)" down
#  to just "POSIX Shell" purely because "sh" hides inside the word
#  "Shell". \bsh\b doesn't match there (no word boundary between the
#  "h" and the "e" it's embedded in), but still correctly matches
#  "bash" inside "Bourne Again Shell (bash)", where it belongs.
def display_language(r, pkg)
  return r[:language] unless r[:path]

  name = (pkg && pkg[:name]) || File.basename(r[:path], '.*')
  return r[:language] if r[:language].nil? || r[:language] =~ /\b#{Regexp.escape(name)}\b/i

  "#{r[:language]} (#{name})"
end

# resolve_version(r, pkg) - trim_version's own answer, falling back to
#  pkg's real package metadata whenever Script.rb's own probe came back
#  weak (WEAK_VERSION) or erroring (trim_version's own "unknown") - the
#  same "only the package really knows" fallback verify_commands.rb's
#  report already leans on for mksh/dash's own real version, applied
#  here too rather than just accepting "unknown" when a better answer
#  is one cheap lookup away.
def resolve_version(r, pkg)
  v = trim_version(r[:version])
  return v if v && v != 'unknown' && v !~ WEAK_VERSION && v !~ BARE_NUMBER

  pkg && pkg[:version] ? pkg[:version] : (v || 'unknown')
end

# expand_selection(argv) - {area => [lang, ...]} to actually run, from
#  positional args like "gen_scripts", "gen_scripts/perl",
#  "gen_scripts/{perl,ruby,python3}", or "gen_scripts/*" - parsed here
#  in Ruby rather than relied on the invoking shell to expand
#  (bash/zsh would handle {a,b,c} and * themselves, but this project
#  also runs from PowerShell/cmd.exe, neither of which does POSIX-style
#  brace or glob expansion at all - relying on the shell would make
#  this selector syntax silently stop working there). No args at all
#  means every area/language, same as before this option existed.
def expand_selection(argv)
  return LANGUAGE_DIRS if argv.empty?

  selected = Hash.new { |h, k| h[k] = [] }
  argv.each do |token|
    area, _, langs_part = token.partition('/')
    unless LANGUAGE_DIRS.key?(area)
      warn "Unknown area '#{area}' - skipping (expected one of: #{LANGUAGE_DIRS.keys.join(' ')})"
      next
    end

    if langs_part.empty? || langs_part == '*'
      selected[area] = LANGUAGE_DIRS.fetch(area).dup
      next
    end

    names = langs_part.start_with?('{') && langs_part.end_with?('}') ? langs_part[1..-2].split(',').map(&:strip) : [langs_part]
    names.each do |name|
      unless LANGUAGE_DIRS.fetch(area).include?(name)
        warn "Unknown language '#{name}' under '#{area}' - skipping"
        next
      end
      selected[area] << name unless selected[area].include?(name)
    end
  end
  selected
end

def run_all(argv = ARGV)
  $stdout.sync = true
  selection = expand_selection(argv)
  if selection.empty? || selection.values.all?(&:empty?)
    warn 'Nothing to run.'
    return
  end
  totals = { total: 0, pass: 0, fail: 0, skip: 0 }
  not_installed = []

  selection.each do |area, langs|
    langs.each do |lang|
      dir = File.join(LESSON_ROOT, area, lang)
      unless Dir.exist?(dir)
        puts "#{lang}: directory not found (#{dir})"
        next
      end

      output = run_rake(dir)

      if (m = output.match(NOT_INSTALLED))
        puts format('%-36s SKIPPED (%s not found on PATH)', lang, m[1])
        not_installed << lang
        next
      end

      r = parse_result(output)

      if r[:total].nil?
        puts "#{lang}: could not parse rake output"
        output.each_line { |line| puts "  #{line}" }
        next
      end

      pkg = resolve_package(r)
      puts format('%-36s %-26s %-34s Total=%-4d Pass=%-4d Fail=%-4d Skip=%d',
                   display_language(r, pkg) || lang, resolve_version(r, pkg), r[:platform] || '-',
                   r[:total], r[:pass], r[:fail], r[:skip])

      totals[:total] += r[:total]
      totals[:pass] += r[:pass]
      totals[:fail] += r[:fail]
      totals[:skip] += r[:skip]
    end
  end

  puts '==============================================================='
  puts format('Final Summary: Total=%d  Pass=%d  Fail=%d  Skip=%d',
               totals[:total], totals[:pass], totals[:fail], totals[:skip])
  puts "Not installed (skipped): #{not_installed.join(', ')}" unless not_installed.empty?
end

if __FILE__ == $PROGRAM_NAME
  if %w[-h --help].include?(ARGV.first)
    puts 'Usage: run_all_tests.rb [AREA | AREA/lang | AREA/{lang1,lang2} | AREA/*] ...'
    puts "Areas: #{LANGUAGE_DIRS.keys.join(' ')}"
    puts 'No arguments runs every area/language.'
  else
    run_all
  end
end
