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

# build_lesson(dir_name) - runs `make`/`make -f Makefile.win` (see
#  ../../lessons/compiled_lang/README.md's own "Makefile" vs
#  "Makefile.win" convention) inside dir_name, returning
#  {success:, output:}. Which file to use follows the same
#  native_windows_ruby? line verify_commands.rb already draws
#  everywhere else - a genuine cmd.exe/PowerShell-launched Ruby uses
#  Makefile.win, every POSIX environment (MSYS2, Cygwin, WSL1, macOS,
#  Linux) uses the plain Makefile, matching Makefile.win's own
#  "SHELL := cmd.exe" pin (that file assumes cmd.exe is doing the
#  invoking, not just building). stdin redirected from NULL_DEVICE for
#  the same reason probe_version's own subprocess calls already are -
#  a build step hanging on unexpected interactive input would freeze
#  this whole script, not just fail one language.
def build_lesson(dir_name)
  dir = File.join(COMPILED_LANG_ROOT, dir_name)
  return { success: false, output: "directory not found: #{dir}" } unless Dir.exist?(dir)

  make = find_on_path('make') || find_on_path('mingw32-make')
  return { success: false, output: 'make not found on PATH' } unless make

  makefile = native_windows_ruby? ? 'Makefile.win' : 'Makefile'
  Dir.chdir(dir) do
    output = `"#{make}" -f #{makefile} < #{NULL_DEVICE} 2>&1`
    { success: $?.success?, output: output }
  end
end

# compile_check - prints each language's summary row as soon as its own
#  build finishes, rather than collecting every result silently and
#  printing only at the very end - confirmed directly this matters: a
#  real build (C#'s native AOT step especially) can take long enough
#  that a fully-batched "print nothing until done" design leaves no way
#  to tell a slow build apart from a hung one.
def compile_check
  $stdout.sync = true
  prefetch_package_info!
  languages = AREAS.find { |area| area[:name] == 'Compiled Languages' }.fetch(:languages)

  puts format('%-8s %-8s %-24s %s', 'Status', 'Language', 'Compiler', 'Version')
  failures = []
  languages.each do |lang|
    entry = resolve_language(lang)
    build = build_lesson(LANG_DIRS.fetch(lang[:name]))
    status = build[:success] ? 'Success' : 'Failure'
    puts format('%-8s %-8s %-24s %s', status, lang[:name], entry[:resolved_binary] || '-', entry[:version] || '-')
    failures << { name: lang[:name], output: build[:output] } unless build[:success]
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
