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
#  "Makefile" vs "Makefile.win" convention) inside dir_name, streaming
#  its output live as it runs - same "Compiling <Language> lessons
#  (one-time build)..." + streamed output + separator shape as
#  testbox/Script.rb's own ensure_compiled!/stream_shell_out, so a slow
#  build (C#'s native AOT step especially) is visibly still working
#  instead of leaving this script sitting in total silence for however
#  long the build takes. Returns {success:, output:} - `output` is
#  still captured (not just streamed) so a failure can be shown again,
#  in full, in the summary table's own "Failures:" section below.
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
def build_lesson(language_name, dir_name)
  dir = File.join(COMPILED_LANG_ROOT, dir_name)
  return { success: false, output: "directory not found: #{dir}" } unless Dir.exist?(dir)

  make = find_on_path('make') || find_on_path('mingw32-make')
  return { success: false, output: 'make not found on PATH' } unless make

  makefile = native_windows_ruby? ? 'Makefile.win' : 'Makefile'
  puts "Compiling #{language_name} lessons..."
  puts '-' * 63
  output = String.new
  Dir.chdir(dir) do
    IO.popen("\"#{make}\" -f #{makefile} < #{NULL_DEVICE} 2>&1") do |io|
      io.each_line do |line|
        print line
        output << line
      end
    end
  end
  success = $?.success?
  puts '=' * 63
  puts
  { success: success, output: output }
end

# compile_check - builds every language one at a time, each with its own
#  live-streamed "Compiling..." progress (see build_lesson) so a long
#  build is never silent, then prints the full Status/Language/Compiler/
#  Version table together at the end, once every result is in - keeping
#  the summary as one clean block instead of interleaving table rows
#  with each build's own scrolling output.
def compile_check
  $stdout.sync = true
  prefetch_package_info!
  languages = AREAS.find { |area| area[:name] == 'Compiled Languages' }.fetch(:languages)

  results = languages.map do |lang|
    entry = resolve_language(lang)
    build = build_lesson(lang[:name], LANG_DIRS.fetch(lang[:name]))
    { lang: lang, entry: entry, build: build }
  end

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
