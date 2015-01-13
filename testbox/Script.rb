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
  @@command = {
    :awk    => "gawk -f",
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
    :js     => "cscript //Nologo",
    :vbs    => "cscript //Nologo",
    :ps1    => 'powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File',
    :cmd    => "cmd /c",
  }

  @@nix_version = {
    :awk    => "gawk --version | head -1",
    :groovy => "groovy --version",
    :pl     => 'perl --version | grep -oE \'v\d\.\d{1,2}\.\d\'',
    :php    => 'php --version | head -1',
    :py     => "python --version 2>&1",
    :rb     => 'ruby --version | gawk \'{ print $2 }\'',
    :tcl    => 'echo TCL $(echo \'puts [info patchlevel];exit 0\' | tclsh)',
    :bash   => "bash --version | head -1",
    :sh     => 'echo Shell \(sh\) = $(sh --version 2> /dev/null | head -1 || echo unknown)',
    :csh    => "csh --version",
    :ksh    => "ksh --version",
  }

  @@win_version = {
    :awk    => "gawk --version | head -1",
    :groovy => "groovy --version",
    :pl     => 'perl --version | grep -oE \'v\d\.\d{1,2}\.\d\'',
    :php    => 'php --version | head -1',
    :py     => "python --version 2>&1",
    :rb     => 'ruby --version | gawk \'{ print $2 }\'',
    :tcl    => 'echo TCL $(echo \'puts [info patchlevel];exit 0\' | tclsh)',
    :bash   => "bash --version | head -1",
    :sh     => 'echo Shell \(sh\) = $(sh --version 2> /dev/null | head -1 || echo unknown)',
    :csh    => "csh --version",
    :ksh    => "ksh --version",
    :js     => "cscript | findstr Windows",
    :vbs    => "cscript | findstr Windows",
    :ps1    => 'powershell -command \'[string]$PSVersionTable.PSVersion.Major + \".\" + [string]$PSVersionTable.PSVersion.Minor\'',
    :cmd    => "echo exit | cmd | findstr Windows",
  }

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

  @@ostype    = RUBY_PLATFORM.split('-')[1].scan(/[a-z]+/)
  @@cputype   = RUBY_PLATFORM.split('-')[0]
  @@language  = Dir.glob('a00.*')[0].split('.')[-1]
  @@jsonfile  = "../../testbox/expected.json"

  require 'json'
  if File.exists?(@@jsonfile)
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

  def self.runner
    @@command[@@language.to_sym]
  end

  def self.version
    if @@ostype[0] == "mingw"
      `#{@@win_version[@@language.to_sym]}`.chomp
    else
      `#{@@nix_version[@@language.to_sym]}`.chomp
    end
  end

  def self.path
    # Test for Windows Scenarios
    if @@ostype[0] == "mingw"
      scriptexec = self.runner
      if scriptexec =~ /gawk/i
        scriptexec = "GnuWin32"
      end

      # Method to Search Windows PATH
      scriptpath = `echo %PATH%`.split(';').select { |line|
        line =~ /#{scriptexec}/i
      }[0]

      # Append Script Executable to
      if scriptpath =~ /\\$/
        "#{scriptpath}#{scriptexec}"
      else
        "#{scriptpath}\\#{scriptexec}"
      end
    else
      `command -v "#{self.runner}"`.chomp
    end
  end

  def self.ostype
    @@ostype[0].capitalize
  end

  def self.cputype
    @@cputype
  end

  def self.report(results)
    colorize = ->(text, color_code) { "#{color_code}#{text}\033[0m" }
    red      = ->(text) { colorize[text, "\033[31m"] }
    green    = ->(text) { colorize[text, "\033[32m"] }
    passfail = ->(text) { text == true  ? green['PASS'] : red['FAIL'] }

    # print test result for category group
    puts "#{results["category"].capitalize}: [#{passfail[results["final_result"]]}]"

    #puts "DEBUG: #{results["results"]}"

    if ! results["final_result"]
      if results["results"].empty?
        puts "    - There are no implementations for this category."
      else
        # process each category
        results["results"].each do |category|
          # process category with one test
          if category[1].length == 1
            testcase = category[1][0]
            puts "    - #{category[0].capitalize}: [#{passfail[testcase["test_result"]]}]"
            # if FAIL, print expected/actual output
            if ! testcase["test_result"]
              puts "       Expected Output: |#{green[testcase["expected"].gsub(/\n/, "\\n")]}|"
              puts "       Actual Output:   |#{red[testcase["output"].gsub(/\n/, "\\n")]}|"
            end
          else
            puts "    - #{category[0].capitalize} (#{category.length[1]} testcases):"
            # process category with multiple tests
            category[1].each_with_index do |testcase, count|
              puts "      - Test #{count+1}: [#{passfail[testcase["test_result"]]}]"
              # if FAIL, print expected/actual output
              if ! testcase["test_result"]
                puts "       Expected Output: |#{green[testcase["expected"].gsub(/\n/, "\\n")]}|"
                puts "       Actual Output:   |#{red[testcase["output"].gsub(/\n/, "\\n")]}|"
              end
            end
          end
        end # enumerate HoA structure
      end # empty hash test
    end # overall pass condition
  end

  def self.execute(task, list)
    final_result, message, results = true, "", {}
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
              redirect = "2> /dev/null"
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
            #puts "RUNNING(#{`which perl`}) #{command}"
            output = `#{command}`
            #output = `#{Script.runner} #{cmd} #{redirect}`
            #puts "EXPECT: |#{expected}|"
            #puts "OUTPUT: |#{output}|"

            test_result = expected == output

            (results[cmd.split(".")[0]] ||=[]) << {
              "command"  => command,
              "output"   => output,
              "expected" => expected,
              "test_result" => test_result
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
      final_result = false
      notes = "Feature not implemented or not supported."
    end # list.any?
    #puts "Array output: #{outputs}"

    #puts "FINAL RESULT: #{final_result}\n"

    { "category" => task.to_s,
      "language" => Script.language_name,
      "final_result" => final_result,
      "notes"    => notes,
      "results" => results
    }
  end

end
