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


class Script
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

  # commands required to retrieve version
  @@nix_version = {
    :awk    => "gawk --version | head -1",
    :groovy => "groovy --version",
    :pl     => 'perl --version | grep -oE \'v[0-9]\.[0-9]{1,2}\.[0-9]\'',
    :php    => 'php --version | head -1',
    :py     => "%{cmd} --version 2>&1",
    :rb     => 'ruby --version | gawk \'{ print $2 }\'',
    :tcl    => 'echo TCL $(echo \'puts [info patchlevel];exit 0\' | tclsh)',
    :bash   => "bash --version | head -1",
    :sh     => 'echo Shell \(sh\) = $(sh --version 2> /dev/null | head -1 || echo unknown)',
    :csh    => "csh --version",
    :ksh    => "ksh --version",
  }

  # commands required to retrieve version (battle tested on Windows cmd.exe)
  @@win_version = {
    :awk    => "gawk --version | head -1",
    :groovy => "groovy --version",
    :pl     => 'perl --version | grep -oE \'v[0-9]\.[0-9]{1,2}\.[0-9]\'',
    :php    => 'php --version | head -1',
    :py     => "%{cmd} --version 2>&1",
    :rb     => 'ruby --version | gawk "{ print $2 }"',
    :tcl    => 'echo TCL $(echo \'puts [info patchlevel];exit 0\' | tclsh)',
    :bash   => "bash --version | head -1",
    :sh     => 'echo Shell \(sh\) = $(sh --version 2> /dev/null | head -1 || echo unknown)',
    :csh    => "csh --version",
    :ksh    => "ksh --version",
    :js     => "cscript | grep -o \"Windows Script Host Version ...\"",
    :vbs     => "cscript | grep -o \"Windows Script Host Version ...\"",
    # bad mojo
    #:vbs    => "cscript | grep -o \"Windows Script Host Version ...\" | sed -E \"s/(.*)Version\s(.*)/\1\2/\"",
    :ps1    => 'powershell -command [string]$PSVersionTable.PSVersion.Major + \".\" + [string]$PSVersionTable.PSVersion.Minor',
    :cmd    => "echo exit | cmd | findstr Windows | tr -s \"[[:space:]]\" : | cut -d: -f4"
  }

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
    :cmd    => "Batch"
  }

  # Some languages have multiple, incompatible major versions that share a
  # file extension (e.g. python2/ and python3/ both use *.py). When the
  # directory name matches a key here, it overrides the extension-derived
  # command so each directory runs with its own interpreter binary.
  @@command_override = {
    "python2" => "python2",
    "python3" => "python3"
  }

  @@ostype    = RUBY_PLATFORM.split('-')[1].scan(/[a-z]+/)
  @@cputype   = RUBY_PLATFORM.split('-')[0]
  @@language  = Dir.glob('a00.*')[0].split('.')[-1]
  @@dirname   = File.basename(Dir.pwd)
  @@jsonfile  = "../../testbox/expected.json"

  # tally of category-level results across a run, printed by print_summary
  @@summary = { :total => 0, :pass => 0, :fail => 0, :skip => 0 }

  # Process JSON files and configure @@dataset
  require 'json'
  if File.exist?(@@jsonfile)
    @@dataset = JSON.parse(File.read(@@jsonfile))
  else
    STDERR.puts "ERROR: Cannot Find JSON File"
    exit 1
  end

  def self.language_name
    @@language_name[@@language.to_sym]
  end

  def self.data(reference)
    @@dataset[reference]
  end


  # command() - returns the interpreter binary to invoke, preferring a
  #  directory-specific override (see @@command_override) over the
  #  extension-derived default.
  def self.command
    @@command_override[@@dirname] || @@command[@@language.to_sym]
  end

  def self.runner
    "#{Script.command} #{@@option[@@language.to_sym]}"
  end

  def self.version
    version_cmd = if @@ostype[0] == "mingw"
      @@win_version[@@language.to_sym]
    else
      @@nix_version[@@language.to_sym]
    end
    `#{version_cmd % {cmd: Script.command}}`.chomp
  end

  # path() - returns path of executable
  #  REQUIREMENTS: which
  def self.path
      `which "#{Script.command}"`.chomp
  end

  def self.ostype
    @@ostype[0].capitalize
  end

  def self.cputype
    @@cputype
  end

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

  def self.red(text);    Script.colorize(text, "\033[31m"); end
  def self.green(text);  Script.colorize(text, "\033[32m"); end
  def self.yellow(text); Script.colorize(text, "\033[33m"); end

  # print_summary() - print the accumulated total/pass/fail/skip tally
  #  for every category run so far in this process.
  def self.print_summary
    puts "==============================================================="
    puts "Summary: Total=#{@@summary[:total]}  " +
         "#{Script.green('Pass')}=#{@@summary[:pass]}  " +
         "#{Script.red('Fail')}=#{@@summary[:fail]}  " +
         "#{Script.yellow('Skip')}=#{@@summary[:skip]}"
  end

  def self.report(results)
    red      = ->(text) { Script.red(text) }
    green    = ->(text) { Script.green(text) }
    yellow   = ->(text) { Script.yellow(text) }
    passfail = ->(text) { text == true  ? green['PASS'] : red['FAIL'] }

    # print expected/actual for a testcase: always on FAIL, and also on a
    #  PASS that only succeeded via tolerance (e.g. "precision"), so the
    #  raw difference is still visible.
    print_diff = ->(testcase) {
      return unless !testcase["test_result"] || testcase["diff"]
      if testcase["test_result"]
        puts "       Expected Output: |#{yellow[testcase["expected"].gsub(/\n/, "\\n")]}|"
        puts "       Actual Output:   |#{yellow[testcase["output"].gsub(/\n/, "\\n")]}| (within tolerance)"
      else
        puts "       Expected Output: |#{green[testcase["expected"].gsub(/\n/, "\\n")]}|"
        puts "       Actual Output:   |#{red[testcase["output"].gsub(/\n/, "\\n")]}|"
      end
    }

    # a category with no implementation file is skipped, not failed, and
    #  not counted toward the total (the language may not support/need it)
    if results["skipped"]
      @@summary[:skip] += 1
      puts "#{results["category"].capitalize}: [#{yellow['SKIP']}]"
      puts "    - #{results["notes"]}"
      return
    end

    @@summary[:total] += 1
    @@summary[results["final_result"] ? :pass : :fail] += 1

    # any testcase whose raw output differs from expected, even one that
    #  passed via tolerance, so we still surface the detail below
    any_diff = results["results"].values.flatten.any? { |t| t["diff"] }

    # print test result for category group
    puts "#{results["category"].capitalize}: [#{passfail[results["final_result"]]}]"

    #puts "DEBUG: #{results["results"]}"

    if ! results["final_result"] || any_diff
      if results["results"].empty?
        puts "    - There are no implementations for this category."
      else
        # process each category
        results["results"].each do |category|
          # process category with one test
          if category[1].length == 1
            testcase = category[1][0]
            puts "    - #{category[0].capitalize}: [#{passfail[testcase["test_result"]]}]"
            print_diff[testcase]
          else
            puts "    - #{category[0].capitalize} (#{category.length[1]} testcases):"
            # process category with multiple tests
            category[1].each_with_index do |testcase, count|
              puts "      - Test #{count+1}: [#{passfail[testcase["test_result"]]}]"
              print_diff[testcase]
            end
          end
        end # enumerate HoA structure
      end # empty hash test
    end # overall pass condition
  end

  def self.execute(task, list)
    final_result, message, results, skipped = true, "", {}, false
    if list.any?
      if taskdata = @@dataset[task]
        # Execute Every Implementation per Feature (0+ implementations)
        list.each do |cmd|
          # Execute Every Test per Implementation (1+ test per feature)
          taskdata.each do |test|
            test_result, redirect, expected, args, redirect, input = false, "", "", "", "", ""
            if test.has_key?("err")
              redirect = "2>&1"
              expected = test['err']
            else
              if @@ostype[0] == "mingw"
                redirect = "2> NUL"
              else
                redirect = "2> /dev/null"
              end
              expected = test['out']
            end

            if test.has_key?("arg")
              args = test['arg']
            end

            if test.has_key?("in")
              input = "printf \"%s\\n\" \"#{test['in']}\" |"
            end

            # Replacements - replace dynamically generated data
            expected.gsub! /(\$cmd\$)/, "#{cmd}"
            expected.gsub! /(\$date\$)/, "#{(Time.new).strftime("%B %d, %Y")}"

            command = "#{input} #{Script.runner} #{cmd} #{args} #{redirect}"
            #puts "DEBUG: RUNNING #{command}"
            output = `#{command}`
            #puts "EXPECT: |#{expected}|"
            #puts "OUTPUT: |#{output}|"

            if test.has_key?("precision")
              digits = test["precision"]
              test_result = Script.truncate_precision(expected, digits) ==
                            Script.truncate_precision(output, digits)
            elsif test.has_key?("bool")
              test_result = Script.normalize_bool(expected) == Script.normalize_bool(output)
            elsif test.has_key?("unordered_csv")
              test_result = Script.normalize_unordered_csv(expected) ==
                            Script.normalize_unordered_csv(output)
            elsif test.has_key?("unordered_lines")
              test_result = Script.normalize_unordered_lines(expected) ==
                            Script.normalize_unordered_lines(output)
            else
              test_result = expected == output
            end

            (results[cmd.split(".")[0]] ||=[]) << {
              "command"  => command,
              "output"   => output,
              "expected" => expected,
              "test_result" => test_result,
              # raw strings differ even when test_result passed via tolerance
              "diff" => expected != output
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
      notes = "No implementation file found for this category; skipping."
    end # list.any?
    #puts "Array output: #{outputs}"

    #puts "FINAL RESULT: #{final_result}\n"

    { "category" => task.to_s,
      "language" => Script.language_name,
      "final_result" => final_result,
      "skipped"  => skipped,
      "notes"    => notes,
      "results" => results
    }
  end

end
