#!/usr/bin/ruby

# =============================================
# Script class
#   Utility class for
#    - executing tests,
#    - reporting environment, and
#    - reporting test results
# =============================================
# Test Structure
#
# Tests labeled with a three-letter prefix:
#  1. [A-Z] Group
#  2. [0-9] Category
#  3. [0-9] Implementations for each Category
#
# Each Implementation will have 1+ Tests
# Each Test will have
#  - Input
#    - argument
#    - 1+ lines of input
#  - Output
#    - standard output
#    - standard error
# =============================================

# =============================================
# Notes on RUBY_PLATFORM
#  i386-mingw32
#  x86_64-darwin12.3.0
#  i386-cygwin
#  x86_64-linux
# Notes on Windows
#  Cygwin: C:\cygwin\bin = /usr/bin
#  MSYS-Git: C:\Program Files\Git\bin = /usr/bin
#  UWIN: C:\Program Files\UWIN\usr\bin = /usr/bin (doesn't map)
# Notes on Mac
#  OS X Version - sw_vers | grep "ProductVersion" | cut -d$'\t' -f2
# =============================================

# =============================================
# ScriptBase / CommandShellScript / PowerShellScript / PosixShellScript
#
# ScriptBase holds everything that doesn't depend on which shell Kernel#`
# actually invokes: test data, reporting, comparison/normalization helpers,
# and the test-execution loop itself.
#
# Everything that DOES depend on the execution environment - finding an
# executable's path, probing a "special" (non `--version`) language's
# version, the null-redirect device, and how a test's stdin gets injected -
# is a template method left unimplemented here and supplied by exactly one
# of the three concrete subclasses below. Each subclass uses tools native
# to its own environment (cmd.exe builtins, PowerShell cmdlets, or POSIX
# coreutils) rather than assuming POSIX tools are on PATH everywhere.
#
# `Script`, the name the rest of the codebase (testbox.rake) calls, is
# bound at the bottom of this file to whichever concrete subclass matches
# the environment actually in use.
# =============================================

class ScriptBase
  # command name
  @@command = {
    :awk    => "gawk",
    :groovy => "groovy",
    :pl     => "perl",
    :php    => "php",
    :py     => "python",
    :rb     => "ruby",
    :tcl    => "tclsh",
    :bash   => "bash",
    :csh    => "tcsh",
    :sh     => "sh",
    :ksh    => "ksh",
    :js     => "cscript",
    :vbs    => "cscript",
    :ps1    => "powershell",
    :cmd    => "cmd"
  }

  # options required for command
  @@option = {
    :awk    => "-f",
    :groovy => "",
    :pl     => "",
    :php    => "",
    :py     => "",
    :rb     => "",
    :tcl    => "",
    :bash   => "",
    :csh    => "",
    :sh     => "",
    :ksh    => "",
    :js     => "//Nologo",
    :vbs    => "//Nologo",
    :ps1    => '-NoLogo -NoProfile -ExecutionPolicy Bypass -File',
    :cmd    => "/c",
  }

  # commands used to probe a language's version via its own `--version`
  # (or equivalent) flag. Identical across every execution environment -
  # only how the raw output is captured differs, which is shell_out's job.
  # Extraction of the version substring from the raw output is pure Ruby
  # (see extract_version) rather than a shell pipeline, so it needs no
  # external tool support at all.
  @@version_probe = {
    :awk    => "gawk --version 2>&1",
    :groovy => "groovy --version 2>&1",
    :pl     => "perl --version 2>&1",
    :php    => "php --version 2>&1",
    :py     => "%{cmd} --version 2>&1",
    :rb     => "ruby --version 2>&1",
    :bash   => "bash --version 2>&1",
    :csh    => "csh --version 2>&1",
    :ksh    => "ksh --version 2>&1",
    :java   => "javac -version 2>&1",
    :go     => "go version 2>&1",
    :rs     => "rustc --version 2>&1",
    :cpp    => "g++ --version 2>&1",
    :cs     => "dotnet --version 2>&1",
  }

  # Languages whose version can't be had from a simple "cmd --version"
  # probe (a shell/host, not a standalone interpreter binary). Each
  # subclass implements special_version(lang) to handle these natively.
  @@special_version_langs = [:tcl, :sh, :js, :vbs, :cmd, :ps1]

  # Descriptive Name of Command
  @@language_name = {
    :awk    => "AWK",
    :groovy => "Groovy",
    :pl     => "Perl",
    :php    => "PHP",
    :py     => "Python",
    :rb     => "Ruby",
    :tcl    => "TCL",
    :bash   => "Bourne Again Shell",
    :csh    => "C-Shell",
    :sh     => "POSIX Shell",
    :ksh    => "Korn Shell",
    :js     => "JScript (WSH)",
    :vbs    => "VBScript (WSH)",
    :ps1    => "PowerShell",
    :cmd    => "Batch",
    :java   => "Java",
    :go     => "Go",
    :rs     => "Rust",
    :cpp    => "C++",
    :cs     => "C#",
  }

  # compiler binary for each compiled language - see @@compiled_languages
  # and ensure_compiled!. Unlike @@command (an interpreter that the test
  #  file is handed to as a data argument), these only ever run once per
  #  test session, via `make`, to produce the actual thing invoked per
  #  test (see invocation_name).
  @@compiler = {
    :java => "javac",
    :go   => "go",
    :rs   => "rustc",
    :cpp  => "g++",
    # Not "csc": a bare csc needs either a hand-built ~240-file BCL
    #  reference list (fragile) or Mono (an extra dependency, plus its
    #  compiled .exe needs a wrapper to run on real POSIX). cs/Makefile
    #  instead generates a minimal throwaway .csproj per lesson and
    #  builds it with `dotnet build` - see that Makefile's own comment.
    :cs   => "dotnet",
  }

  # Languages with no interpreter at all (see @@command) - a lesson file
  #  here is only ever handed to `make` (see ensure_compiled!), and what
  #  actually gets invoked per test is the resulting build artifact (see
  #  invocation_name), not the source file itself.
  @@compiled_languages = @@compiler.keys

  # Some languages have multiple, incompatible major versions that share a
  # file extension (e.g. python2/ and python3/ both use *.py). When the
  # directory name matches a key here, it overrides the extension-derived
  # command so each directory runs with its own interpreter binary.
  @@command_override = {
    "python2" => "python2",
    "python3" => "python3"
  }

  # Languages known to need interactive_shell_out for a test tagged
  #  "interactive": true, rather than the normal shell_out. Batch's SET /p,
  #  used in a GOTO loop, can't correctly consume a pre-built Windows pipe
  #  across repeated reads (it just re-reads the first line forever) -
  #  interactive_shell_out works around that by feeding input lines one at
  #  a time in response to actual output, mimicking real keystrokes. Every
  #  other language's own input construct (gets, <>, readline, ...)
  #  already handles a pre-built pipe fine in every environment, so they
  #  stay on the simpler/faster shell_out - and some (e.g. Perl, which
  #  fully buffers STDOUT when it isn't a real terminal) would actually
  #  deadlock under interactive_shell_out despite not needing it at all.
  @@interactive_required_languages = [:cmd]

  # Languages that need an explicit relative-path prefix (e.g. ".\file" on
  #  Windows, "./file" on real POSIX) rather than a bare filename when
  #  invoked. NoDefaultCurrentDirectoryInExePath (a Windows security
  #  hardening setting - see execute) only disables the implicit
  #  current-directory search used to resolve *the program to execute*.
  #  That only matters for :cmd and the compiled languages, where the
  #  test artifact itself is what's being resolved that way (cmd /c
  #  <file>, or a compiled binary run directly). Every interpreted
  #  language passes the test file as a data argument to an
  #  already-resolved interpreter (e.g. "ruby file.rb") - never affected
  #  by that restriction - so prefixing it there was never necessary, and
  #  it leaks into any script that prints its own invocation name/path
  #  (e.g. Ruby's $0, Python's sys.argv[0]).
  @@needs_path_prefix_languages = [:cmd] + @@compiled_languages

  @@ostype    = RUBY_PLATFORM.split('-')[1].scan(/[a-z]+/)
  @@cputype   = RUBY_PLATFORM.split('-')[0]
  # A compiled language's build artifacts (a00.output.exe, a00.output.cmd,
  #  ...) sit right next to a00's source file and match this same glob -
  #  restrict to extensions actually recognized as a source language (see
  #  @@command/@@compiler) so a leftover binary from a previous `make`
  #  never gets mistaken for the language itself.
  @@known_extensions = (@@command.keys + @@compiler.keys).map(&:to_s)
  @@language  = Dir.glob('a00.*').map { |f| f.split('.')[-1] }.find { |ext| @@known_extensions.include?(ext) }
  @@dirname   = File.basename(Dir.pwd)
  @@jsonfile   = "../../testbox/expected.json"
  @@titlesfile = "../../testbox/titles.json"

  # tally of category-level results across a run, printed by print_summary
  @@summary = { :total => 0, :pass => 0, :fail => 0, :skip => 0 }

  # commands already confirmed present on PATH this run (see command()) -
  #  a Set so a missing interpreter fails loudly exactly once, not on
  #  every single test that would otherwise try and fail to invoke it.
  require 'set'
  @@verified_commands = Set.new

  # Process JSON files and configure @@dataset
  require 'json'
  require 'date'
  if File.exist?(@@jsonfile)
    @@dataset = JSON.parse(File.read(@@jsonfile))
  else
    STDERR.puts "ERROR: Cannot Find JSON File"
    exit 1
  end

  # Titles are cosmetic (human-readable lesson names in test output), so a
  #  missing/unreadable titles.json falls back to no title rather than
  #  aborting the run.
  @@titles = File.exist?(@@titlesfile) ? JSON.parse(File.read(@@titlesfile)) : {}

  def self.language_name
    @@language_name[@@language.to_sym]
  end

  def self.data(reference)
    @@dataset[reference]
  end

  # title(reference) - human-readable lesson name for a category (e.g.
  #  "g0" -> "Assign by Index and Length"), or "" if not found.
  def self.title(reference)
    @@titles[reference.to_s] || ""
  end

  # command() - returns the interpreter binary to invoke, preferring a
  #  directory-specific override (see @@command_override) over the
  #  extension-derived default. python2/ and python3/ are expected to have
  #  their own unambiguous "python2"/"python3" binary on every supported
  #  platform (see the project's setup docs - Windows needs an explicit
  #  copy of python.exe under each name, since the stock installer only
  #  ever provides a bare "python"; macOS/pyenv shims provide both
  #  natively) - so, unlike a missing "pwsh", this is never silently
  #  papered over. If the resolved binary isn't actually on PATH, that
  #  means the documented setup step was skipped, and every test would
  #  otherwise fail with the same confusing "not recognized" error
  #  (exactly what happened when "pwsh" was assumed present - see
  #  native_unix?) - so fail once, loudly, and stop, rather than a wall of
  #  near-identical per-test failures.
  def self.command
    # @@command has no entry for a compiled language (see
    #  @@compiled_languages) - it falls through to @@compiler, since
    #  that's the one thing that actually needs to be on PATH to run
    #  these lessons at all (see ensure_compiled!). Reusing `command`
    #  for this, rather than a separate method, means the same
    #  PATH-verification and header-display logic below covers both
    #  cases for free.
    cmd = @@command_override[@@dirname] || @@command[@@language.to_sym] || @@compiler[@@language.to_sym]
    # PowerShell's POSIX package (installed as `pwsh`) never provides a
    #  `powershell` binary - that name is only the Windows Desktop edition
    #  executable. Gated on native_unix?, not posix?: Msys2ShellScript is
    #  posix? true but is still Windows underneath, where "powershell" is
    #  the real (and likely only) binary - see native_unix?'s comment.
    cmd = "pwsh" if cmd == "powershell" && native_unix?

    unless @@verified_commands.include?(cmd)
      if find_executable(cmd).to_s.empty?
        STDERR.puts "ERROR: Cannot find \"#{cmd}\" on PATH (needed to run #{@@dirname}/ lessons). " \
                    "Check the setup instructions for this language."
        exit 1
      end
      @@verified_commands << cmd
    end

    cmd
  end

  # runner() - the interpreter (+ options) that a test file gets handed to
  #  as a data argument, e.g. "ruby ". A compiled language has no such
  #  thing - the build artifact (see invocation_name) runs itself - so
  #  this is deliberately blank rather than "javac "/"g++ ", which would
  #  otherwise get prepended to every test's command line.
  def self.runner
    return "" if @@compiled_languages.include?(@@language.to_sym)
    "#{command} #{@@option[@@language.to_sym]}"
  end

  # invocation_name(cmd) - what to actually put on the command line for
  #  lesson file `cmd`. For an interpreted language this is just `cmd`
  #  itself (handed to runner as a data argument). For a compiled
  #  language, `cmd` is the *source* file (e.g. "a00.output.rs") - what
  #  actually needs to run is the build artifact make produced from it,
  #  named after the source minus its language extension (see
  #  compiled_lang/README.md's naming convention) plus whatever this
  #  platform's runnable extension is (see binary_extension).
  def self.invocation_name(cmd)
    return cmd unless @@compiled_languages.include?(@@language.to_sym)
    "#{cmd.sub(/\.[^.]+\z/, "")}#{binary_extension}"
  end

  # binary_extension() - the real on-disk extension of the artifact
  #  `make` produces for the current compiled language (see
  #  compiled_lang/*/Makefile). Every compiled language here builds a
  #  native "*.exe" on a cmd.exe-backed environment except Java, which
  #  has no standalone-binary story - its Makefile instead generates a
  #  "*.cmd" launcher wrapping `java -cp . ClassName` (see
  #  compiled_lang/java/Makefile). On real POSIX (native_unix?), every
  #  language's Makefile produces an extension-less, executable-bit file
  #  (a native binary, or - for Java - a "#!/bin/sh" launcher script), so
  #  there's nothing to append.
  def self.binary_extension
    return "" if native_unix?
    # ".bat", not ".cmd": :cmd (Batch) already owns ".cmd" as its own
    #  lesson source extension - reusing it here made a Java wrapper
    #  indistinguishable from an actual Batch lesson file to @@language
    #  auto-detection (both are "a00.output.cmd"). cmd.exe treats ".bat"
    #  as an equally native batch-script extension, so this loses nothing.
    @@language.to_sym == :java ? ".bat" : ".exe"
  end

  # shell_out(cmd_str) - runs cmd_str the same way the harness runs a
  #  test's command (i.e. via Kernel#`, whatever shell that natively
  #  invokes), and returns raw stdout/stderr. Subclasses may add their own
  #  additional helpers (e.g. explicitly routing through powershell.exe)
  #  without changing this default.
  def self.shell_out(cmd_str)
    `#{cmd_str}`
  end

  # stream_shell_out(cmd_str) - like shell_out, but prints cmd_str's
  #  combined output line-by-line as it's produced instead of capturing it
  #  silently until the process exits. Used only for the one-time `make`
  #  build in ensure_compiled! - a compiled language's full build can take
  #  a noticeable moment, and without this the harness sits in total
  #  silence for that whole stretch before the first test result appears.
  #  Forces $stdout.sync so lines actually appear as they're read rather
  #  than sitting in Ruby's own output buffer until the block exits.
  #  Returns whether the command exited successfully.
  def self.stream_shell_out(cmd_str)
    old_sync, $stdout.sync = $stdout.sync, true
    IO.popen(cmd_str) { |io| io.each_line { |line| print line } }
    $?.success?
  ensure
    $stdout.sync = old_sync
  end

  # needs_interactive?(test) - true only if the test is tagged
  #  "interactive" AND the current language is one known to actually need
  #  the workaround (see @@interactive_required_languages). The tag alone
  #  isn't enough: it's a property of the *test*, shared across every
  #  language's implementation via expected.json, but the underlying
  #  buffered-pipe problem is specific to individual languages/interpreters
  #  (e.g. only batch's SET /p), not a general trait of a test category.
  def self.needs_interactive?(test)
    !!test["interactive"] && @@interactive_required_languages.include?(@@language.to_sym)
  end

  # interactive_shell_out(cmd_str, input_lines) - like shell_out, but for
  #  tests tagged "interactive": true. Windows buffers a pre-built pipe's
  #  entire input at once rather than delivering it incrementally, which
  #  some interactive loops (e.g. a batch `SET /p` inside a GOTO loop)
  #  can't correctly consume across repeated reads - it just re-reads the
  #  same first line forever instead of advancing. Feeding input_lines
  #  one at a time over a live stdin pipe, in response to the process
  #  actually producing output, sidesteps that: it mimics real keystrokes
  #  rather than one large pre-buffered write.
  #  A stalled/runaway process is force-killed after timeout_seconds so a
  #  broken script can't hang the whole test run.
  def self.interactive_shell_out(cmd_str, input_lines, timeout_seconds: 15)
    require 'open3'
    output = String.new
    remaining = input_lines.dup

    Open3.popen3(cmd_str) do |stdin, stdout, _stderr, wait_thr|
      # Ruby's Timeout can't reliably interrupt a thread blocked in a
      #  native Windows pipe read, so instead of racing the read itself,
      #  an independent watchdog thread kills the process directly after
      #  timeout_seconds. That breaks the pipe out from under the blocked
      #  readpartial, which is what actually unblocks it. Plain
      #  Process.kill(wait_thr.pid) isn't enough: on native Windows Ruby,
      #  wait_thr.pid is the outer cmd.exe wrapper Kernel#`/Open3 always
      #  spawns, not the real interpreter running underneath it - killing
      #  that outer PID leaves the actual hung grandchild (e.g. perl.exe)
      #  alive and still holding the pipe open. taskkill's /T flag kills
      #  the whole process tree rooted at that PID instead.
      watchdog = Thread.new do
        sleep timeout_seconds
        `taskkill /F /T /PID #{wait_thr.pid}` if wait_thr.alive?
      rescue StandardError
      end

      begin
        while wait_thr.alive?
          begin
            output << stdout.readpartial(4096)
          rescue EOFError, IOError, SystemCallError
            break
          end
          stdin.puts(remaining.shift) unless remaining.empty?
          stdin.flush
        end
      ensure
        watchdog.kill
        watchdog.join
      end

      stdin.close rescue nil
      begin
        loop { output << stdout.readpartial(4096) }
      rescue EOFError, IOError, SystemCallError
      end
    end

    # Open3.popen3's pipes are binary, unlike Kernel#` (used by shell_out),
    #  which translates CRLF to LF on Windows automatically - normalize the
    #  same way here so interactive/non-interactive tests compare equally.
    output.gsub("\r\n", "\n")
  end

  # version() - human-readable version string for the language under test.
  #  Dispatches to special_version for languages that aren't a plain
  #  "interpreter --version" (see @@special_version_langs); otherwise
  #  probes generically and extracts the version number in pure Ruby.
  def self.version
    lang = @@language.to_sym
    return special_version(lang).to_s.strip if @@special_version_langs.include?(lang)

    probe = @@version_probe[lang]
    return "" unless probe

    raw = shell_out(probe % { cmd: command })
    extract_version(raw, lang)
  end

  # extract_version(raw, lang) - pulls just the version number/line out of
  #  a language's raw "--version" output. Pure Ruby string/regex work, so
  #  it needs no external text-processing tool (grep/awk/head/cut/...) and
  #  behaves identically regardless of which shell captured `raw`.
  def self.extract_version(raw, lang)
    case lang
    when :awk, :php, :bash, :cpp
      raw.lines.first.to_s.strip
    when :pl
      raw[/v\d\.\d{1,2}\.\d/].to_s
    when :rb
      raw.split[1].to_s
    else
      raw.strip
    end
  end

  # path() - returns path of the language's interpreter executable.
  def self.path
    find_executable(command)
  end

  def self.ostype
    @@ostype[0].capitalize
  end

  def self.cputype
    @@cputype
  end

  # shell_name() - which concrete environment subclass is active, e.g.
  #  "PowerShell", "CommandShell", "PosixShell".
  def self.shell_name
    name.sub(/Script\z/, "")
  end

  # ---------------------------------------------------------------------
  # Template methods - every concrete subclass (CommandShellScript,
  # PowerShellScript, PosixShellScript) must implement these using tools
  # native to its own environment.
  # ---------------------------------------------------------------------

  # find_executable(cmd) - resolves cmd to a full path using this
  #  environment's own executable-lookup facility.
  def self.find_executable(cmd)
    raise NotImplementedError, "#{name} must implement find_executable"
  end

  # null_device() - where to redirect stderr to discard it.
  def self.null_device
    raise NotImplementedError, "#{name} must implement null_device"
  end

  # input_redirect(value) - shell fragment that pipes `value` (plus a
  #  trailing newline) into the next command's stdin, e.g. "echo hi|".
  def self.input_redirect(value)
    raise NotImplementedError, "#{name} must implement input_redirect"
  end

  # special_version(lang) - version string for a language that has no
  #  plain "--version" probe (see @@special_version_langs).
  def self.special_version(lang)
    raise NotImplementedError, "#{name} must implement special_version"
  end

  # line_continuation() - this shell's line-continuation character.
  def self.line_continuation
    raise NotImplementedError, "#{name} must implement line_continuation"
  end

  # posix?() - true if this environment is a genuine POSIX shell (so a
  #  test tagged `requires=posix` should run), false otherwise.
  def self.posix?
    raise NotImplementedError, "#{name} must implement posix?"
  end

  # native_unix?() - true only for a genuinely non-Windows OS (macOS/
  #  Linux native Ruby - i.e. PosixShellScript). NOT the same question as
  #  posix?: Msys2ShellScript answers posix? true (it has real POSIX
  #  tools available for `requires=posix` lessons) while still being a
  #  native Windows Ruby build underneath (see that class's own comment)
  #  - it has Windows's own "powershell" binary, not a POSIX PowerShell
  #  package. Defaults to false rather than being a strict template
  #  method (unlike posix?) since every subclass except PosixShellScript
  #  wants this same answer.
  def self.native_unix?
    false
  end

  # ---------------------------------------------------------------------

  # testbox_tags(file) - parses "# testbox: key=value" / "# testbox:
  #  key="quoted value"" comments from the first few lines of `file` into
  #  a hash, e.g. {"requires" => "posix", "title" => "subshell with
  #  for..in collection"}. Lets a lesson file carry harness metadata
  #  right where a reader of that file will actually see it, instead of a
  #  separate manifest that can drift out of sync.
  def self.testbox_tags(file)
    tags = {}
    # Explicit UTF-8 (with BOM-stripping) so a lesson file's encoding
    #  doesn't depend on the shell's locale - some lesson files carry a
    #  UTF-8 BOM, which isn't valid text under the "C"/US-ASCII locale
    #  Ruby otherwise defaults to.
    File.foreach(file, encoding: "bom|utf-8").first(5).each do |line|
      line.scan(/testbox:\s*(\w+)=(?:"([^"]*)"|(\S+))/) do |key, quoted, bare|
        tags[key] = quoted || bare
      end
    end
    tags
  rescue Errno::ENOENT
    {}
  end

  # requires_posix?(file) - true if `file` is tagged `requires=posix`,
  #  i.e. it's a lesson intentionally demonstrating a POSIX-only
  #  technique (subshell output, etc.) rather than a portability bug to
  #  fix.
  def self.requires_posix?(file)
    testbox_tags(file)["requires"] == "posix"
  end

  # implementation_title(file) - this file's `title=` tag, if any, e.g.
  #  "subshell with for..in collection". Used to label an implementation
  #  in test output when a category has more than one, so it's clear
  #  which technique each result belongs to.
  def self.implementation_title(file)
    testbox_tags(file)["title"]
  end

  # ---------------------------------------------------------------------

  # truncate_precision(str, digits) - truncate the fractional part of every
  #  floating point number embedded in str to at most `digits` characters.
  #  Used to tolerate floating point precision differences across language
  #  runtimes (e.g. cosine/area calculations) when comparing test output.
  def self.truncate_precision(str, digits)
    str.gsub(/(\d+\.\d+)/) do |match|
      whole, frac = match.split(".")
      "#{whole}.#{frac[0, digits]}"
    end
  end

  # normalize_locale_decimal(str) - fold a comma-style decimal separator
  #  (e.g. "22,8") down to the period form ("22.8"), so a number can be
  #  compared across runs regardless of the runtime's locale-dependent
  #  number formatting (e.g. Groovy's printf, which - unlike Ruby/Perl/
  #  awk's - defaults to Locale.getDefault() instead of always using '.').
  #  Only touches digit-comma-digit, so it won't disturb a genuine
  #  comma-separated list (e.g. "bob, ed, steve").
  def self.normalize_locale_decimal(str)
    str.gsub(/(\d),(\d)/, '\1.\2')
  end

  # dates_within_tolerance?(expected, output, days) - true if both
  #  strings contain a "Month DD, YYYY"-style date (the $date$
  #  substitution format - see execute) and those dates are within
  #  `days` calendar days of each other. Used to tolerate a language
  #  runtime that computes "today" in UTC instead of local time (e.g. a
  #  native Windows binary invoked from MSYS2, which doesn't get MSYS2's
  #  /etc/localtime path virtualization), so a run near a local/UTC day
  #  boundary doesn't flip a genuine pass into a fail.
  def self.dates_within_tolerance?(expected, output, days = 1)
    fmt = /\b([A-Z][a-z]+ \d{1,2}, \d{4})\b/
    exp_date, out_date = expected[fmt, 1], output[fmt, 1]
    return false unless exp_date && out_date
    (Date.strptime(exp_date, "%B %d, %Y") - Date.strptime(out_date, "%B %d, %Y")).abs <= days
  end

  # normalize_bool(str) - fold the common truthy representations different
  #  languages print ("true", "True", "1") down to a single canonical form,
  #  so a boolean result can be compared across languages that render
  #  booleans differently (e.g. awk prints 1/0, Python prints True/False).
  def self.normalize_bool(str)
    str.gsub(/\b(?:true|True|1)\b/, "true")
  end

  # normalize_unordered_csv(str) - within each line that has a
  #  "label: a, b, c" shape, sort the comma-separated items after the
  #  colon. Used when a hash/dict's keys or values are printed
  #  comma-separated on one line and enumeration order isn't guaranteed
  #  by the language (e.g. Perl, awk hashes have no defined order).
  def self.normalize_unordered_csv(str)
    str.split("\n").map do |line|
      if line =~ /^([^:]*:\s*)(.*)$/
        prefix, items = $1, $2
        prefix + items.split(",").map(&:strip).sort.join(", ")
      else
        line
      end
    end.join("\n")
  end

  # normalize_unordered_lines(str) - sort every line in str. Used when
  #  each hash/dict entry is printed on its own line and the set of
  #  lines, not their order, is what should be compared.
  def self.normalize_unordered_lines(str)
    str.split("\n").sort.join("\n")
  end

  def self.colorize(text, color_code)
    "#{color_code}#{text}\033[0m"
  end

  def self.red(text);    colorize(text, "\033[31m"); end
  def self.green(text);  colorize(text, "\033[32m"); end
  def self.yellow(text); colorize(text, "\033[33m"); end

  # print_summary() - print the accumulated total/pass/fail/skip tally
  #  for every category run so far in this process.
  def self.print_summary
    puts "==============================================================="
    puts "Summary: Total=#{@@summary[:total]}  " +
         "#{green('Pass')}=#{@@summary[:pass]}  " +
         "#{red('Fail')}=#{@@summary[:fail]}  " +
         "#{yellow('Skip')}=#{@@summary[:skip]}"
  end

  def self.report(results)
    red      = ->(text) { self.red(text) }
    green    = ->(text) { self.green(text) }
    yellow   = ->(text) { self.yellow(text) }
    passfail = ->(text) { text == true  ? green['PASS'] : red['FAIL'] }

    # print expected/actual for a testcase: always on FAIL, and also on a
    #  PASS that only succeeded via tolerance (e.g. "precision"), so the
    #  raw difference is still visible.
    print_diff = ->(testcase) {
      return unless !testcase["test_result"] || testcase["diff"]
      if testcase["test_result"]
        puts "         Expected Output: |#{yellow[testcase["expected"].gsub(/\n/, "\\n")]}|"
        puts "         Actual Output:   |#{yellow[testcase["output"].gsub(/\n/, "\\n")]}| (within tolerance)"
      else
        puts "         Expected Output: |#{green[testcase["expected"].gsub(/\n/, "\\n")]}|"
        puts "         Actual Output:   |#{red[testcase["output"].gsub(/\n/, "\\n")]}|"
      end
    }

    # human-readable lesson name (e.g. "Assign by Index and Length"),
    #  appended to the category code so output is readable without having
    #  to cross-reference the README
    title = self.title(results["category"])
    label = results["category"].capitalize + (title.empty? ? "" : " - #{title}")

    # a category with no implementation file is skipped, not failed, and
    #  not counted toward the total (the language may not support/need it)
    if results["skipped"]
      @@summary[:skip] += 1
      reason = results["skip_reason"] ? " (#{results["skip_reason"]})" : ""
      puts "#{label}: [#{yellow['SKIP']}]#{reason}"
      return
    end

    @@summary[:total] += 1
    @@summary[results["final_result"] ? :pass : :fail] += 1

    # any testcase whose raw output differs from expected, even one that
    #  passed via tolerance, so we still surface the detail below
    any_diff = results["results"].values.flatten.any? { |t| t["diff"] }

    # any testcase whose implementation carries a "title=" tag - when a
    #  category has more than one implementation of the same lesson (see
    #  implementation_title), surface the breakdown even on a clean pass
    #  so it's clear which technique each result demonstrates
    has_titles = results["results"].values.flatten.any? { |t| t["title"] }

    # print test result for category group
    puts "#{label}: [#{passfail[results["final_result"]]}]"

    #puts "DEBUG: #{results["results"]}"

    if ! results["final_result"] || any_diff || has_titles
      if results["results"].empty?
        puts "      - There are no implementations for this category."
      else
        # process each category
        results["results"].each do |category|
          impl_title = category[1][0]["title"]
          impl_label = category[0].capitalize + (impl_title ? " - #{impl_title}" : "")

          # process category with one test
          if category[1].length == 1
            testcase = category[1][0]
            puts "      - #{impl_label}: [#{passfail[testcase["test_result"]]}]"
            print_diff[testcase]
          else
            puts "      - #{impl_label} (#{category.length[1]} testcases):"
            # process category with multiple tests
            category[1].each_with_index do |testcase, count|
              puts "        - Test #{count+1}: [#{passfail[testcase["test_result"]]}]"
              print_diff[testcase]
            end
          end
        end # enumerate HoA structure
      end # empty hash test
    end # overall pass condition
  end

  # ensure_compiled!() - for a compiled language (see @@compiled_languages),
  #  runs `make` in the lesson directory once per test session, before any
  #  test tries to invoke a build artifact that doesn't exist yet. `make`
  #  itself, and the compiler it drives (see command()), are each
  #  verified present and failed loudly and once if missing - the same
  #  "fail once, clearly" reasoning as command()'s own PATH check,
  #  because a broken build would otherwise surface as the exact same
  #  confusing per-test "not recognized"/"no such file" error on every
  #  single test in the directory.
  @@compiled_ok = false
  def self.ensure_compiled!
    return unless @@compiled_languages.include?(@@language.to_sym)
    return if @@compiled_ok

    command # verifies the compiler itself is on PATH (see command())

    if find_executable("make").to_s.empty?
      STDERR.puts "ERROR: Cannot find \"make\" on PATH (needed to build #{@@dirname}/ lessons). " \
                  "Check the setup instructions for this language."
      exit 1
    end

    # a second, separate status header from the one testbox.rake's own
    #  :header task prints - @@compiled_ok means this only runs once per
    #  `rake` invocation (the first test category to execute triggers it;
    #  every later category in the same run skips straight past). `make`
    #  itself is still incremental across separate `rake` runs, so a
    #  second invocation with nothing changed just streams a fast
    #  "Nothing to be done" instead of silently doing nothing as before.
    puts "Compiling #{language_name} lessons (one-time build)..."
    puts "==============================================================="
    success = stream_shell_out("make 2>&1")
    puts "==============================================================="

    unless success
      STDERR.puts "ERROR: `make` failed while building #{@@dirname}/ lessons (see output above)."
      exit 1
    end

    @@compiled_ok = true
  end

  def self.execute(task, list)
    ensure_compiled!
    # testbox.rake finds implementations with a bare Dir.glob("#{task}?.*")
    #  - fine for an interpreted language, where the source file is the
    #  only thing in the directory matching that pattern, but a compiled
    #  language's build artifacts (a00.output.exe, a00.output.cmd, ...)
    #  sit right next to the source and match it too. Restrict to the
    #  real source extension so a generated binary never gets scanned as
    #  if it were a second implementation (testbox_tags's line-by-line
    #  read chokes on non-UTF8 binary bytes) or double-counted.
    list = list.select { |cmd| cmd.end_with?(".#{@@language}") } if @@compiled_languages.include?(@@language.to_sym)
    final_result, message, results, skipped, skip_reason = true, "", {}, false, nil
    # Drop implementations that are intentionally POSIX-only (see
    #  requires_posix?) when we're not running under a POSIX shell. If
    #  that empties the list, this reports as SKIP below - same as any
    #  other category with no implementation for the current platform -
    #  but remember whether POSIX-only filtering is *why*, so report()
    #  can say so instead of leaving it looking like there's just no
    #  implementation at all.
    had_posix_only_implementation = !posix? && list.any? { |cmd| requires_posix?(cmd) }
    list = list.reject { |cmd| requires_posix?(cmd) } unless posix?
    if list.any?
      if taskdata = @@dataset[task]
        # Execute Every Implementation per Feature (0+ implementations)
        list.each do |cmd|
          # Execute Every Test per Implementation (1+ test per feature)
          taskdata.each do |test|
            test_result, redirect, expected, args, redirect, input = false, "", "", "", "", ""
            input_lines = nil
            if test.has_key?("err")
              redirect = "2>&1"
              expected = test['err']
            else
              redirect = "2> #{null_device}"
              expected = test['out']
            end

            if test.has_key?("arg")
              args = test['arg']
            end

            if test.has_key?("in")
              # A test tagged "interactive" only actually runs through
              #  interactive_shell_out if the current language is also in
              #  @@interactive_required_languages - see needs_interactive?.
              #  Those tests feed their input lines one at a time over a
              #  live stdin pipe instead of via a pre-built shell pipe, so
              #  they don't get an input_redirect prefix baked into the
              #  command string.
              if needs_interactive?(test)
                input_lines = test['in'].split("\n")
              else
                input = input_redirect(test['in'])
              end
            end

            # invoked_name is what actually goes on the command line and
            #  into the $cmd$ substitution below - for an interpreted
            #  language that's just `cmd` (the source file itself,
            #  handed to runner as a data argument); for a compiled one
            #  it's the build artifact's own name (see invocation_name),
            #  since that - not the source file - is what a lesson's own
            #  $0/argv[0]/os.Args[0]-style self-name check would report.
            invoked_name = invocation_name(cmd)

            # Explicit relative-path prefix, only for languages that need
            #  it (see @@needs_path_prefix_languages) - both cmd.exe and
            #  a directly-run compiled binary are resolved as *the
            #  program to execute itself* (not a data argument to an
            #  already-resolved interpreter), so each is subject to
            #  NoDefaultCurrentDirectoryInExePath. native_unix?, not
            #  posix?: this is about which path separator the target
            #  program loader wants (/ on real Unix, \ on cmd.exe -
            #  including under Msys2ShellScript, which is posix? true
            #  but still Windows underneath - see native_unix?'s comment).
            #  A compiled language additionally builds into a bin/
            #  subdirectory (see compiled_lang/README.md), so its prefix
            #  includes that too.
            is_compiled = @@compiled_languages.include?(@@language.to_sym)
            if @@needs_path_prefix_languages.include?(@@language.to_sym)
              sep = native_unix? ? "/" : "\\"
              subdir = is_compiled ? "bin#{sep}" : ""
              prefix = ".#{sep}#{subdir}"
            else
              prefix = ""
            end

            # Replacements - replace dynamically generated data. A
            #  compiled language's own argv[0]/os.Args[0]-style self-name
            #  check would report the *whole* invoked path (prefix and
            #  all) since nothing in the program strips it - unlike
            #  batch's j00-style lessons, which explicitly strip any
            #  prefix themselves (see win_scripts/batch/j00.arguments.cmd's
            #  %~nx0), so only compiled languages get prefix folded in
            #  here.
            expected.gsub! /(\$cmd\$)/, "#{is_compiled ? prefix : ""}#{invoked_name}"
            expected.gsub! /(\$date\$)/, "#{(Time.new).strftime("%B %d, %Y")}"

            command = "#{input} #{runner} #{prefix}#{invoked_name} #{args} #{redirect}"
            #puts "DEBUG: RUNNING #{command}"
            output = if needs_interactive?(test)
              interactive_shell_out(command, input_lines)
            else
              shell_out(command)
            end
            #puts "EXPECT: |#{expected}|"
            #puts "OUTPUT: |#{output}|"

            if test.has_key?("precision")
              digits = test["precision"]
              test_result = truncate_precision(expected, digits) ==
                            truncate_precision(output, digits)
            elsif test.has_key?("bool")
              test_result = normalize_bool(expected) == normalize_bool(output)
            elsif test.has_key?("unordered_csv")
              test_result = normalize_unordered_csv(expected) ==
                            normalize_unordered_csv(output)
            elsif test.has_key?("unordered_lines")
              test_result = normalize_unordered_lines(expected) ==
                            normalize_unordered_lines(output)
            elsif test.has_key?("locale_decimal")
              test_result = normalize_locale_decimal(expected) ==
                            normalize_locale_decimal(output)
            elsif test.has_key?("date_tolerance")
              days = test["date_tolerance"] == true ? 1 : test["date_tolerance"]
              test_result = dates_within_tolerance?(expected, output, days)
            else
              test_result = expected == output
            end

            (results[cmd.split(".")[0]] ||=[]) << {
              "command"  => command,
              "output"   => output,
              "expected" => expected,
              "test_result" => test_result,
              # raw strings differ even when test_result passed via tolerance
              "diff" => expected != output,
              # this implementation's "title=" tag, if any (see
              #  implementation_title) - lets report() show which
              #  technique a multi-implementation category's result
              #  belongs to
              "title" => implementation_title(cmd)
            }

            final_result &= test_result


            #puts "DEBUG: #{results}"

          end # taskdata
        end # list.each
      else
        final_result = false
        message = "FAIL"
      end #taskdata = @@dataset[task]
    else
      skipped = true
      skip_reason = "requires a POSIX shell" if had_posix_only_implementation
    end # list.any?
    #puts "Array output: #{outputs}"

    #puts "FINAL RESULT: #{final_result}\n"

    { "category" => task.to_s,
      "language" => language_name,
      "final_result" => final_result,
      "skipped"  => skipped,
      "skip_reason" => skip_reason,
      "results" => results
    }
  end

end

# =============================================
# PosixShellScript - macOS, Linux, and MSYS2/Cygwin Ruby builds, where
# Kernel#` invokes /bin/sh and the full POSIX coreutils set is on PATH.
# =============================================
class PosixShellScript < ScriptBase
  def self.find_executable(cmd)
    `which "#{cmd}"`.chomp
  end

  def self.null_device
    "/dev/null"
  end

  def self.input_redirect(value)
    "printf \"%s\\n\" \"#{value}\" |"
  end

  def self.special_version(lang)
    case lang
    when :tcl
      `echo 'puts [info patchlevel];exit 0' | tclsh`.strip
    when :sh
      raw = `sh --version 2> /dev/null`.lines.first
      raw ? "Shell (sh) = #{raw.strip}" : "Shell (sh) = unknown"
    when :ps1
      # Single-quoted, unlike the Windows subclasses' equivalent - this
      #  runs through Kernel#`'s POSIX /bin/sh, which (unlike cmd.exe)
      #  expands a bare "$PSVersionTable" itself before pwsh ever sees it.
      `pwsh -NoProfile -NonInteractive -Command '$PSVersionTable.PSVersion.ToString()'`.strip
    else
      ""
    end
  end

  def self.line_continuation
    "\\"
  end

  def self.posix?
    true
  end

  def self.native_unix?
    true
  end
end

# =============================================
# CommandShellScript - native (non-MSYS) Windows Ruby, where Kernel#`
# invokes cmd.exe. Uses only cmd.exe builtins/native binaries - no
# posix/GNUWin32 tools required.
# =============================================
class CommandShellScript < ScriptBase
  def self.find_executable(cmd)
    # where.exe prints its own "INFO: Could not find files..." to stderr
    #  on a miss - silence it so command()'s own error message (see
    #  ScriptBase#command) is the only thing on screen when this fails.
    `where "#{cmd}" 2>#{null_device}`.split("\n").first.to_s.chomp
  end

  def self.null_device
    "NUL"
  end

  # input_redirect(value) - cmd.exe can't embed a raw newline in a single
  #  command line the way POSIX shells can inside a quoted string, so a
  #  multi-line value (e.g. "Name\nquit") becomes one `echo` per line. They
  #  run inside a nested `cmd /c "..."` rather than `(...)` grouping -
  #  piping a parenthesized block's output is a known cmd.exe quirk that
  #  silently appends a stray trailing space to it.
  def self.input_redirect(value)
    lines = value.split("\n").map { |line| "echo #{line}" }
    %Q{cmd /c "#{lines.join('&')}"|}
  end

  def self.special_version(lang)
    case lang
    when :cmd
      `ver`[/Version ([\d.]+)/, 1].to_s
    when :ps1
      `powershell -NoProfile -NonInteractive -Command "$PSVersionTable.PSVersion.ToString()"`.strip
    when :js, :vbs
      `cscript 2>&1`[/Windows Script Host Version \S+/].to_s
    when :tcl
      `echo puts [info patchlevel] | tclsh`.strip
    when :sh
      raw = `sh --version 2>&1`.lines.first
      raw ? "Shell (sh) = #{raw.strip}" : "Shell (sh) = unknown"
    else
      ""
    end
  end

  def self.line_continuation
    "^"
  end

  def self.posix?
    false
  end
end

# =============================================
# Msys2ShellScript - MSYS2/UCRT64 Ruby. This is still a native (MinGW)
# Windows Ruby build, so Kernel#` is cmd.exe-backed exactly like
# CommandShellScript - confirmed directly: `` `echo hi 2> /dev/null` ``
# fails ("The system cannot find the path specified"), `` `echo hi 2>
# NUL` `` works. So every shell-mechanics method here is inherited
# unchanged from CommandShellScript. The one real difference is that
# MSYS2's own bin directory is on PATH, giving genuine POSIX tools
# (ls, which, gawk, printf, ...) that cmd.exe can find and run just
# like any other program - so, unlike plain CommandShellScript,
# `requires=posix` lessons genuinely work here.
# =============================================
class Msys2ShellScript < CommandShellScript
  def self.posix?
    true
  end

  # input_redirect(value) - CommandShellScript's version feeds each line
  #  through cmd.exe's builtin `echo`, which always emits CRLF. That's
  #  harmless for a genuine cmd.exe target (its own `set /p` strips the
  #  \r), but every POSIX-shell `read` here keeps it as trailing data
  #  (e.g. name becomes "Name\r"), corrupting string comparisons
  #  (E0/E1), arithmetic (E2), and echoed values (D0) - and can hang a
  #  read-until-sentinel loop (F2) forever since the sentinel never
  #  matches. MSYS2 has a real printf(1) on PATH (see class comment
  #  above), which - unlike the builtin - emits exactly the bytes its
  #  format string asks for, so driving it with one "%s\n" per line
  #  produces genuine LF-terminated input instead. Everything stays on
  #  one cmd.exe command line (repeated %s/args, not an embedded
  #  newline) since cmd.exe can't parse a literal newline mid-command.
  def self.input_redirect(value)
    lines  = value.split("\n")
    format = "%s\\n" * lines.length
    args   = lines.map { |line| "\"#{line}\"" }.join(" ")
    "printf \"#{format}\" #{args} |"
  end
end

# =============================================
# PowerShellScript - native Windows Ruby launched from a PowerShell
# session. Test commands still run the same way as CommandShellScript
# (Kernel#` is always cmd.exe-backed on native Windows Ruby, regardless of
# the parent shell), but this class's own auxiliary lookups (finding an
# executable, probing a shell/host's version) are explicitly routed
# through powershell.exe so they can use PowerShell cmdlets instead of
# posix/GNUWin32 tools.
# =============================================
class PowerShellScript < ScriptBase
  # pwsh(command_str) - runs a single, harness-authored PowerShell
  #  expression (never raw test data) via an explicit powershell.exe call.
  def self.pwsh(command_str)
    `powershell -NoProfile -NonInteractive -Command "#{command_str}"`.strip
  end

  def self.find_executable(cmd)
    pwsh("(Get-Command #{cmd}).Source")
  end

  def self.null_device
    "NUL"
  end

  # See CommandShellScript#input_redirect - execution still runs through
  #  cmd.exe here too, so the same nested-`cmd /c` trick applies.
  def self.input_redirect(value)
    lines = value.split("\n").map { |line| "echo #{line}" }
    %Q{cmd /c "#{lines.join('&')}"|}
  end

  def self.special_version(lang)
    case lang
    when :cmd
      pwsh("[System.Environment]::OSVersion.Version.ToString()")
    when :ps1
      pwsh("$PSVersionTable.PSVersion.ToString()")
    when :js, :vbs
      `cscript 2>&1`[/Windows Script Host Version \S+/].to_s
    when :tcl
      `echo puts [info patchlevel] | tclsh`.strip
    when :sh
      raw = `sh --version 2>&1`.lines.first
      raw ? "Shell (sh) = #{raw.strip}" : "Shell (sh) = unknown"
    else
      ""
    end
  end

  def self.line_continuation
    "`"
  end

  def self.posix?
    false
  end
end

# =============================================
# Windows shell detection - used only to choose between CommandShellScript
# and PowerShellScript below. Environment variables can't tell PowerShell
# and cmd.exe apart here: `rake` is rake.bat, and Windows always
# interposes a transient cmd.exe to interpret a .bat file, which sets the
# same env vars (PSModulePath, PROMPT, ...) a real cmd.exe session would.
#
# What *does* differ is that transient cmd.exe's own command line - it's
# always started as `cmd /c <command>`, whereas a genuine interactive
# cmd.exe session isn't. So instead of trusting cmd.exe's mere presence
# as our parent, walk up past any cmd.exe started with /c until we hit
# either a non-wrapper cmd.exe (a real session) or a powershell/pwsh
# ancestor.
# =============================================
def win_process_info(pid)
  out = IO.popen(['powershell.exe', '-NoProfile', '-Command',
    "Get-CimInstance Win32_Process -Filter \"ProcessId=#{pid}\" | " \
    "Select-Object Name,CommandLine,ParentProcessId | ConvertTo-Json -Compress"
  ]) { |io| io.read }.strip
  return nil if out.empty?
  JSON.parse(out)
rescue StandardError
  nil
end

def windows_host_shell(pid)
  loop do
    info = win_process_info(pid)
    return nil unless info

    name = info['Name'].to_s.downcase
    if name.include?('powershell') || name == 'pwsh.exe'
      return :powershell
    elsif name == 'cmd.exe'
      if info['CommandLine'].to_s =~ %r{/c\b}i
        pid = info['ParentProcessId']
        next
      else
        return :cmd
      end
    else
      return nil
    end
  end
end

# =============================================
# Bind Script to whichever concrete environment subclass matches how this
# process is actually running. testbox.rake only ever refers to `Script`.
#
# MSYS2/UCRT64 Ruby reports RUBY_PLATFORM as "x64-mingw-ucrt" - the same
# "mingw" family as native Windows Ruby - so that check alone can't tell
# them apart. ENV['MSYSTEM'] (e.g. "MINGW64", "UCRT64") is set only by
# MSYS2's own shell startup, never by a plain cmd.exe/PowerShell session
# (unlike PSModulePath/PROMPT, which turned out to leak into both), so it
# takes priority. But MSYS2 Ruby is still cmd.exe-backed for Kernel#`
# (confirmed directly - see Msys2ShellScript), so it needs its own class,
# not PosixShellScript outright.
# =============================================
Script = if ENV['MSYSTEM']
  Msys2ShellScript
elsif RUBY_PLATFORM =~ /mingw|mswin/i
  windows_host_shell(Process.ppid) == :powershell ? PowerShellScript : CommandShellScript
else
  PosixShellScript
end
