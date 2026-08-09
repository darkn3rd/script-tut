#!/usr/bin/env ruby
# compile_check.rb - attempts to build every lessons/compiled_lang area
#  (cpp, cs, go, java, rust) via its own Makefile/Makefile.win, and
#  reports a Success/Failure summary alongside each language's own
#  resolved compiler and version - reusing verify_commands.rb's own
#  detection (AREAS, resolve_language) rather than re-implementing it,
#  since that's already been hardened across MSYS2/Cygwin/WSL1/native
#  Windows/macOS in this same project. Complementary to
#  verify_commands.rb's own "is the tooling present at all" check - this
#  one actually tries to build something with it.
#
#  Usage: ruby compile_check.rb

require_relative 'verify_commands'

# LANG_DIRS - AREAS' own "Compiled Languages" display name -> the
#  matching lessons/compiled_lang/<dir> subdirectory - not derivable
#  from AREAS itself, since verify_commands.rb has no reason to know
#  about this project's lesson directory layout.
LANG_DIRS = {
  'C++' => 'cpp',
  'C#' => 'cs',
  'Go' => 'go',
  'Java' => 'java',
  'Rust' => 'rust'
}.freeze

COMPILED_LANG_ROOT = File.expand_path('../../lessons/compiled_lang', __dir__)

# build_lesson(language_name, dir_name) - runs `make`/`make -f
#  Makefile.win` (see ../../lessons/compiled_lang/README.md's own
#  "Makefile" vs "Makefile.win" convention) inside dir_name. Returns
#  {success:, output:} - `output` is captured in full (not streamed)
#  so a failure can be shown, in full, in the summary table's own
#  "Failures:" section below - see compile_check's own comment for why
#  this doesn't stream live the way testbox/Script.rb's
#  stream_shell_out does: five of these run concurrently now, and
#  interleaving five processes' own line-by-line output would be
#  unreadable, not just noisy.
#  Which Makefile to use follows the same native_windows_ruby? line
#  verify_commands.rb already draws everywhere else - a genuine
#  cmd.exe/PowerShell-launched Ruby uses Makefile.win, every POSIX
#  environment (MSYS2, Cygwin, WSL1, macOS, Linux) uses the plain
#  Makefile, matching Makefile.win's own "SHELL := cmd.exe" pin (that
#  file assumes cmd.exe is doing the invoking, not just building).
#  stdin redirected from NULL_DEVICE for the same reason
#  probe_version's own subprocess calls already are - a build step
#  hanging on unexpected interactive input would freeze this whole
#  script, not just fail one language.
#  chdir: dir, not Dir.chdir(dir) { ... } - Dir.chdir changes the
#  *whole process's* cwd, which every thread shares; two languages
#  building concurrently would each try to chdir the same process at
#  once (Ruby itself raises "conflicting chdir during another chdir
#  block" the moment a second thread attempts it). Passing chdir: as a
#  Process.spawn-family option instead scopes the working directory to
#  just that one child process, so five of these can run in true
#  parallel with no shared mutable state at all.
def build_lesson(language_name, dir_name)
  dir = File.join(COMPILED_LANG_ROOT, dir_name)
  return { success: false, output: "directory not found: #{dir}" } unless Dir.exist?(dir)

  make = find_on_path('make') || find_on_path('mingw32-make')
  return { success: false, output: 'make not found on PATH' } unless make

  makefile = native_windows_ruby? ? 'Makefile.win' : 'Makefile'
  # make clean first - target/ and bin/ are a shared, persistent build
  #  cache on disk, not something this one run owns exclusively: the
  #  same lessons/compiled_lang tree is reachable (and built) from
  #  multiple environments (native Windows, WSL1, WSL2, MSYS2, ...) on
  #  a shared /mnt/c checkout, and an object file from one
  #  environment's toolchain is binary-incompatible with another's -
  #  confirmed directly: a stale Windows/MinGW-format target/*.o,
  #  left over from a native-Windows build, crashed Ubuntu's own `ld`
  #  rather than failing cleanly when WSL2's make trusted its
  #  timestamp and skipped recompiling it. This script's whole job is
  #  to verify the toolchain actually works, not to build fast - it
  #  must never let a leftover artifact from a different environment
  #  stand in for that check.
  system("\"#{make}\" -f #{makefile} clean < #{NULL_DEVICE} > #{NULL_DEVICE} 2>&1", chdir: dir)
  # $? is thread-local in Ruby - each thread's own $? only ever
  #  reflects children *that thread* spawned, so reading it right after
  #  this IO.popen is safe even with four other threads doing the same
  #  thing concurrently.
  output = IO.popen("\"#{make}\" -f #{makefile} < #{NULL_DEVICE} 2>&1", chdir: dir, &:read)
  success = $?.success?
  { success: success, output: output }
end

# compile_check - builds every language concurrently (one Thread per
#  language - there are only ever five of these, so no pool/queue is
#  needed), printing a one-line "done"/"FAILED" the moment each
#  finishes (mutex-guarded so two threads finishing at once can't
#  interleave mid-line), then the full Status/Language/Compiler/
#  Version table together at the end once every result is in. A slow
#  build (C#'s native AOT step especially) no longer blocks every
#  other language from even starting, unlike the old one-at-a-time
#  sequential run - confirmed directly this is the actual win here,
#  since the five languages share no build state with each other at
#  all (see build_lesson's own chdir: comment for why that's safe).
def compile_check
  $stdout.sync = true
  prefetch_package_info!
  languages = AREAS.find { |area| area[:name] == 'Compiled Languages' }.fetch(:languages)

  puts "Compiling #{languages.length} languages in parallel (#{languages.map { |l| l[:name] }.join(', ')})..."
  print_mutex = Mutex.new
  threads = languages.map do |lang|
    Thread.new do
      entry = resolve_language(lang)
      build = build_lesson(lang[:name], LANG_DIRS.fetch(lang[:name]))
      print_mutex.synchronize { puts "  #{build[:success] ? 'done  ' : 'FAILED'}: #{lang[:name]}" }
      { lang: lang, entry: entry, build: build }
    end
  end
  # .value, not .join then a separate read - re-raises any exception a
  #  thread hit instead of silently swallowing it, matching what a
  #  plain sequential call would already have done.
  results = threads.map(&:value)
  puts

  # Column widths sized to the longest actual value in each column
  #  (plus the header itself), not a fixed guess - confirmed directly a
  #  fixed guess breaks alignment the same way it did in
  #  verify_commands.rb's own table_row: "java-17-amazon-corretto-jdk:amd64"
  #  routinely runs past any reasonable fixed "Compiler" width.
  rows = results.map do |r|
    [r[:build][:success] ? 'Success' : 'Failure', r[:lang][:name], r[:entry][:resolved_binary] || '-', r[:entry][:version] || '-']
  end
  headers = %w[Status Language Compiler Version]
  widths = (0..2).map { |i| ([headers[i]] + rows.map { |row| row[i] }).map(&:length).max }

  puts format("%-#{widths[0]}s %-#{widths[1]}s %-#{widths[2]}s %s", *headers)
  failures = []
  results.each_with_index do |r, i|
    puts format("%-#{widths[0]}s %-#{widths[1]}s %-#{widths[2]}s %s", *rows[i])
    failures << { name: r[:lang][:name], output: r[:build][:output] } unless r[:build][:success]
  end
  return if failures.empty?

  puts
  puts 'Failures:'
  failures.each do |f|
    puts "#{f[:name]}:"
    f[:output].to_s.each_line { |line| puts "  #{line}" }
  end
end

compile_check if __FILE__ == $PROGRAM_NAME
