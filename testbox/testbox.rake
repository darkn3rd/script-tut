
task :default do
  puts "Environment:      #{Script.ostype}"
  puts "Language Target:  #{`command -v #{Script.path}`}"
  puts "Language Version: #{Script.version}"
  puts "==============================================================="
  # Comenting Out Interactive Scripts for now

  Rake::Task["output"].invoke
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
  #Rake::Task["exit"].invoke
  #Rake::Task["function"].invoke

end

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
    :sh     => "sh",
    :js     => "cscript //Nologo",
    :vbs    => "cscript //Nologo",
    :ps1    => "powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File",
    :cmd    => "cmd /c",
    :bat    => "cmd /c"
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

  @@ostype   = RUBY_PLATFORM.split('-')[1].scan(/[a-z]+/)
  @@language = Dir.glob('a00.*')[0].split('.')[-1]


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

  attr_accessor :ostype, :shell, :lang
end

desc 'Executes A List of Scripts'
task :execute, [:list] do |t, args|
  require 'json'

  json_file = "../../testbox/expected.json"
  if File.exists?(json_file)
    root = JSON.parse(File.read(json_file))
  else
    STDERR.puts "ERROR: Cannot Find JSON File"
    exit 1
  end

  args["list"].each do |cmd|
    sh "#{Script.runner} #{cmd}"
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable

end

desc 'Standard Error'
task :a1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Output Here-String (or Multiline String)'
task :a2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'String Concatenation'
task :b1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'String Formatting'
task :b2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Here-String (Multiline String)'
task :b3 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Boolean Logic'
task :c1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Exponential'
task :c2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Math Function (Triganometry)'
task :c3 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================

desc 'User Input'
task :input do
  Rake::Task["d0"].invoke
  Rake::Task["d1"].invoke
end

desc 'Line Input'
task :d0 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Character Input'
task :d1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Ternary (or single-line)'
task :e1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Number Range'
task :e2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Number Match'
task :e3 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Multiway with Number'
task :e4 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Multiway with String Pattern'
task :e5 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'String Pattern'
task :e6 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Count Loop'
task :f1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Conditional Loop'
task :f2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Spin Loop'
task :f3 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Skipping a Loop Iteration'
task :f4 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Array List Assignment and Enumeration by Item'
task :g1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Array List Assignment and Enumeration by Item'
task :g2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Associative Arrays (Hash, Map, Dictionary)'
task :associative do
  Rake::Task["h0"].invoke
  Rake::Task["h1"].invoke
end


desc 'Association Array Assignment by Key'
task :h0 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end


desc 'Association Array Assignment by List and Appending'
task :h1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Global Variables'
task :i1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Local Variables'
task :i2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Enumerate Arguments in Order'
task :j1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Enumerate Arguments in Reverse Order'
task :j2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Parameters to Subroutines'
task :parameters do
  Rake::Task["k0"].invoke
  Rake::Task["k1"].invoke
end

desc 'Passing a Single Parameter'
task :k0 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Passing Variable Number of Parameters'
task :k1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================

desc 'Exit'
task :exit do
  Rake::Task["l0"].invoke
end

## NOTE THIS SHOULD HAVE A POS AND NEG TEST

desc 'Reporting Status Code'
task :l0 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
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
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Returning a String'
task :m1 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Returning an Array'
task :m2 do |t|
  list = Dir.glob("#{t.to_s}?.*")
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================
