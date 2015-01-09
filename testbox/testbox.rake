
task :default do
  puts "Environment:      #{Script.ostype}"
  puts "Language Target:  #{`command -v #{Script.path}`}"
  puts "Language Version: #{Script.version}"
  puts "==============================================================="
  # Comenting Out Interactive Scripts for now

  #Rake::Task["output"].invoke
  #Rake::Task["variables"].invoke
  #Rake::Task["arithmetic"].invoke
  #Rake::Task["input"].invoke
  #Rake::Task["branch"].invoke
  #Rake::Task["loop"].invoke
  #Rake::Task["array"].invoke
  #Rake::Task["associative"].invoke
  #Rake::Task["subroutine"].invoke
  #Rake::Task["arguments"].invoke
  #Rake::Task["parameters"].invoke
  Rake::Task["exit"].invoke
  #Rake::Task["function"].invoke

end

# =============================================
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
# Each of these tasks will have to evaluate the available excutable files
# available then execute them. and report their results.
#
# If multiple files in one category, run them all, report collective result.
# If no files in one category, report that this feature is not supported.
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
    :ps1    => "powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File",
    :cmd    => "cmd /c",
  }

  @@versions = {
    :awk    => "gawk --version | head -1",
    :groovy => "groovy --version",
    :pl     => 'echo Perl $(perl --version | grep -oE \'v\d\.\d{1,2}\.\d\')',
    :php    => 'php --version | head -1',
    :py     => "python --version",
    :rb     => "ruby --version",
    :tcl    => 'echo TCL $(echo \'puts [info patchlevel];exit 0\' | tclsh)',
    :bash   => "bash --version | head -1",
    :sh     => 'echo Shell (sh) = $(sh --version 2> /dev/null | head -1 || echo unknown)',
    :csh    => "csh --version",
    :ksh    => "ksh --version",
    :js     => "cscript | findstr Windows",
    :vbs    => "cscript | findstr Windows",
    :ps1    => "powershell -command '[string]$PSVersionTable.PSVersion.Major + \".\" + [string]$PSVersionTable.PSVersion.Minor'",
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

  @@ostype   = RUBY_PLATFORM.split('-')[1].scan(/[a-z]+/)
  @@language = Dir.glob('a00.*')[0].split('.')[-1]
  @@jsonfile = "../../testbox/expected.json"

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
    `#{@@versions[@@language.to_sym]}`
  end

  def self.path
    `command -v #{self.runner}`
  end

  def self.ostype
    @@ostype[0].capitalize
  end

  def self.report
    # Article for colorizaton
    # http://kpumuk.info/ruby-on-rails/colorizing-console-ruby-script-output/
  end

  def self.execute(task, list)
    final_result, message, results = true, "", {}
    if list.any?
      if taskdata = @@dataset[task]
        # Execute Every Implementation per Feature (0+ implementations)
        list.each do |cmd|
          # Execute Every Test per Implementation (1+ test per feature)
          taskdata.each do |test|
            test_result, redirect, expected, args = false, "", "", ""
            if test.has_key?("err")
              redirect = "2>&1"
              expected = test['err']
            else
              expected = test['out']
            end

            if test.has_key?("arg")
              args = test['arg']
            end
            puts "EXPECT: |#{expected}|"
            command = "#{Script.runner} #{cmd} #{args} #{redirect}"
            puts "RUNNING #{command}"
            output = `#{command}`.chomp
            #output = `#{Script.runner} #{cmd} #{redirect}`
            test_result = expected == output

            (results[cmd.split(".")[0]] ||=[]) << {
              "command" => command,
              "output" => output,
              "expected" => expected
            }

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
      "passfail" => final_result  ? 'PASS' : 'FAIL',
      "notes"    => notes,
      "results" => results
    }
  end

end


# For Future
# sh %Q{grep pattern file} do |ok, res|
#   if ! ok
#     puts "pattern not found (status = #{res.exitstatus})"
#   end
# end

# Return Result if list is empty
# Return Result of error if failure to run command
# Return Result of output or stderr


desc 'Output to Console (stdout, stderr)'
task :output do
  Rake::Task["a0"].invoke
  Rake::Task["a1"].invoke
  Rake::Task["a2"].invoke
end


desc 'Standard Ouput'
task :a0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  #puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FAIL'}"
  puts result

end

desc 'Standard Error'
task :a1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  #puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  puts result

end

desc 'Output Here-String (or Multiline String)'
task :a2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)

  puts result
end

# ==============================================

desc 'Variables'
task :variables do
  Rake::Task["b0"].invoke
  Rake::Task["b1"].invoke
  Rake::Task["b2"].invoke
  Rake::Task["b3"].invoke
end

desc 'String Concatenation'
task :b0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'String Concatenation'
task :b1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'String Formatting'
task :b2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Here-String (Multiline String)'
task :b3 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================


desc 'Basic Arirthmetic'
task :arithmetic do
  Rake::Task["c0"].invoke
  Rake::Task["c1"].invoke
  Rake::Task["c2"].invoke
  Rake::Task["c3"].invoke
end


desc 'Multiplication'
task :c0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Boolean Logic'
task :c1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Exponential'
task :c2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Math Function (Triganometry)'
task :c3 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================

desc 'User Input'
task :input do
  Rake::Task["d0"].invoke
  Rake::Task["d1"].invoke
end

desc 'Line Input'
task :d0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Character Input'
task :d1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================


desc 'Branching'
task :branch do
  Rake::Task["e0"].invoke
  Rake::Task["e1"].invoke
  Rake::Task["e2"].invoke
  Rake::Task["e3"].invoke
  Rake::Task["e4"].invoke
  Rake::Task["e5"].invoke
  Rake::Task["e6"].invoke
end

desc 'String Evaluation (Yes/No)'
task :e0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Ternary (or single-line)'
task :e1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Number Range'
task :e2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Number Match'
task :e3 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Multiway with Number'
task :e4 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Multiway with String Pattern'
task :e5 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'String Pattern'
task :e6 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================

desc 'Looping'
task :loop do
  Rake::Task["f0"].invoke
  Rake::Task["f1"].invoke
  Rake::Task["f2"].invoke
  Rake::Task["f3"].invoke
  Rake::Task["f4"].invoke
end

desc 'Collection Loop'
task :f0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Count Loop'
task :f1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Conditional Loop'
task :f2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Spin Loop'
task :f3 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Skipping a Loop Iteration'
task :f4 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================

desc 'Arrays (Lists)'
task :array do
  Rake::Task["g0"].invoke
  Rake::Task["g1"].invoke
  Rake::Task["g2"].invoke
end

desc 'Array Index Assignment and Length'
task :g0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Array List Assignment and Enumeration by Item'
task :g1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Array List Assignment and Enumeration by Item'
task :g2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================


desc 'Associative Arrays (Hash, Map, Dictionary)'
task :associative do
  Rake::Task["h0"].invoke
  Rake::Task["h1"].invoke
end


desc 'Association Array Assignment by Key'
task :h0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end


desc 'Association Array Assignment by List and Appending'
task :h1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================


desc 'Subroutines (Procedures)'
task :subroutine do
  Rake::Task["i0"].invoke
  Rake::Task["i1"].invoke
  Rake::Task["i2"].invoke
end


desc 'Creating and Calling'
task :i0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Global Variables'
task :i1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Local Variables'
task :i2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================


desc 'Arguments from Command-Line'
task :arguments do
  Rake::Task["j0"].invoke
  Rake::Task["j1"].invoke
  Rake::Task["j2"].invoke
end

desc 'Usage Statement, Script Name, Argument Count'
task :j0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Enumerate Arguments in Order'
task :j1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Enumerate Arguments in Reverse Order'
task :j2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================


desc 'Parameters to Subroutines'
task :parameters do
  Rake::Task["k0"].invoke
  Rake::Task["k1"].invoke
end

desc 'Passing a Single Parameter'
task :k0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Passing Variable Number of Parameters'
task :k1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================

desc 'Exit'
task :exit do
  Rake::Task["l0"].invoke
end

## NOTE THIS SHOULD HAVE A POS AND NEG TEST

desc 'Reporting Status Code'
task :l0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  puts result
end

# ==============================================


desc 'Functions and Returning Values'
task :function do
  Rake::Task["m0"].invoke
  Rake::Task["m1"].invoke
  Rake::Task["m2"].invoke
end

desc 'Returning a Number'
task :m0 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

desc 'Returning a String'
task :m1 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  puts result
end

desc 'Returning an Array'
task :m2 do |t|
  list   = Dir.glob("#{t.to_s}?.*")
  if list.any?
    result = Script.execute(t.to_s, list)
    puts "Feature #{t.to_s} result = #{result  ? 'PASS' : 'FALSE'}"
  else
    puts "NOTE: This feature #{t.to_s} is not supported by #{Script.language_name}."
  end
end

# ==============================================
