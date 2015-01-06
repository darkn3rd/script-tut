
task :default do
  puts "Environment:     #{Script.ostype}"
  puts "Target Language: #{Script.version}"
  puts "==============================================================="
  # Comenting Out Interactive Scripts for now

  Rake::Task["output"].invoke
  Rake::Task["variables"].invoke
  Rake::Task["arithmetic"].invoke
  #Rake::Task["input"].invoke
  #Rake::Task["branch"].invoke
  #Rake::Task["loop"].invoke
  Rake::Task["array"].invoke
  Rake::Task["associative"].invoke
  Rake::Task["subroutine"].invoke
  #Rake::Task["arguments"].invoke
  #Rake::Task["parameters"].invoke
  #Rake::Task["exit"].invoke
  Rake::Task["function"].invoke


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
    :pl     => "perl --version | grep -oE 'perl.*\)'",
    :php    => "php --version | head -1",
    :py     => "python --version",
    :rb     => "ruby --version",
    :bash   => "bash --version | head -1",
    :csh    => "csh --version",
    :ksh    => "ksh --version",
    :js     => "cscript | findstr Windows",
    :vbs    => "cscript | findstr Windows",
    :ps1    => "powershell -command '[string]$PSVersionTable.PSVersion.Major + \".\" + [string]$PSVersionTable.PSVersion.Minor'",
    :cmd    => "echo exit | cmd | findstr Windows",
  }

  @@ostype   = RUBY_PLATFORM.split('-')[1].scan(/[a-z]+/)

  def self.runner
    @@command[Dir.glob('a00.*')[0].split('.')[-1].to_sym]
  end

  def self.version
    `#{@@versions[Dir.glob('a00.*')[0].split('.')[-1].to_sym]}`
  end

  def self.ostype
    @@ostype[0].capitalize
  end

  attr_accessor :ostype, :shell, :lang
end

desc 'Executes A List of Scripts'
task :execute, [:list] do |t, args|
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
  Rake::Task["stderr"].invoke
  Rake::Task["stdout"].invoke
  Rake::Task["multiline"].invoke
end


desc 'Standard Ouput'
task :stdout do
  list = Dir.glob('a0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable

end

desc 'Standard Error'
task :stderr do
  list = Dir.glob('a1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Output Here-String (or Multiline String)'
task :multiline do
  list = Dir.glob('a2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================

desc 'Variables'
task :variables do
  Rake::Task["concatenation"].invoke
  Rake::Task["interpolation"].invoke
  Rake::Task["formatting"].invoke
  Rake::Task["herestring"].invoke
end

desc 'String Concatenation'
task :concatenation do
  list = Dir.glob('b0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'String Concatenation'
task :interpolation do
  list = Dir.glob('b1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'String Formatting'
task :formatting do
  list = Dir.glob('b2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Here-String (Multiline String)'
task :herestring do
  list = Dir.glob('b3?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Basic Arirthmetic'
task :arithmetic do
  Rake::Task["multiplication"].invoke
  Rake::Task["boolean"].invoke
  Rake::Task["exponential"].invoke
  Rake::Task["mathfunction"].invoke
end


desc 'Multiplication'
task :multiplication do
  list = Dir.glob('c0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Boolean Logic'
task :boolean do
  list = Dir.glob('c1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Exponential'
task :exponential do
  list = Dir.glob('c2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Math Function (Triganometry)'
task :mathfunction do
  list = Dir.glob('c3?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================

desc 'User Input'
task :input do
  Rake::Task["line"].invoke
  Rake::Task["char"].invoke
end

desc 'Line Input'
task :line do
  list = Dir.glob('d0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Character Input'
task :char do
  list = Dir.glob('d1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Branching'
task :branch do
  Rake::Task["stringeval"].invoke
  Rake::Task["ternary"].invoke
  Rake::Task["numrange"].invoke
  Rake::Task["nummatch"].invoke
  Rake::Task["multinum"].invoke
  Rake::Task["multipattern"].invoke
  Rake::Task["singlepattern"].invoke
end

desc 'String Evaluation (Yes/No)'
task :stringeval do
  list = Dir.glob('e0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Ternary (or single-line)'
task :ternary do
  list = Dir.glob('e1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Number Range'
task :numrange do
  list = Dir.glob('e2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Number Match'
task :nummatch do
  list = Dir.glob('e3?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Multiway with Number'
task :multinum do
  list = Dir.glob('e4?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Multiway with String Pattern'
task :multipattern do
  list = Dir.glob('e5?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'String Pattern'
task :singlepattern do
  list = Dir.glob('e6?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================

desc 'Looping'
task :loop do
  Rake::Task["collection"].invoke
  Rake::Task["count"].invoke
  Rake::Task["conditional"].invoke
  Rake::Task["spin"].invoke
  Rake::Task["skipping"].invoke
end

desc 'Collection Loop'
task :collection do
  list = Dir.glob('f0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Count Loop'
task :count do
  list = Dir.glob('f1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Conditional Loop'
task :conditional do
  list = Dir.glob('f2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Spin Loop'
task :spin do
  list = Dir.glob('f3?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Skipping a Loop Iteration'
task :skipping do
  list = Dir.glob('f4?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================

desc 'Arrays (Lists)'
task :array do
  Rake::Task["indexlength"].invoke
  Rake::Task["enumitem"].invoke
  Rake::Task["enumindex"].invoke
end

desc 'Array Index Assignment and Length'
task :indexlength do
  list = Dir.glob('g0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Array List Assignment and Enumeration by Item'
task :enumitem do
  list = Dir.glob('g1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Array List Assignment and Enumeration by Item'
task :enumindex do
  list = Dir.glob('g2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Associative Arrays (Hash, Map, Dictionary)'
task :associative do
  Rake::Task["keyassign"].invoke
  Rake::Task["listassign"].invoke
end


desc 'Association Array Assignment by Key'
task :keyassign do
  list = Dir.glob('h0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end


desc 'Association Array Assignment by List and Appending'
task :listassign do
  list = Dir.glob('h1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Subroutines (Procedures)'
task :subroutine do
  Rake::Task["createcall"].invoke
  Rake::Task["scopeglobal"].invoke
  Rake::Task["scopelocal"].invoke
end


desc 'Creating and Calling'
task :createcall do
  list = Dir.glob('i0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Global Variables'
task :scopeglobal do
  list = Dir.glob('i1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Local Variables'
task :scopelocal do
  list = Dir.glob('i2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Arguments from Command-Line'
task :arguments do
  Rake::Task["usage"].invoke
  Rake::Task["forward"].invoke
  Rake::Task["reverse"].invoke
end

desc 'Usage Statement, Script Name, Argument Count'
task :usage do
  list = Dir.glob('j0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Enumerate Arguments in Order'
task :forward do
  list = Dir.glob('j1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Enumerate Arguments in Reverse Order'
task :reverse do
  list = Dir.glob('j2?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Parameters to Subroutines'
task :parameters do
  Rake::Task["single"].invoke
  Rake::Task["dynamic"].invoke
end

desc 'Passing a Single Parameter'
task :single do
  list = Dir.glob('k0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Passing Variable Number of Parameters'
task :dynamic do
  list = Dir.glob('k1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================

desc 'Exit'
task :exit do
  Rake::Task["statuscode"].invoke
end

## NOTE THIS SHOULD HAVE A POS AND NEG TEST

desc 'Reporting Status Code'
task :statuscode do
  list = Dir.glob('l0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================


desc 'Functions and Returning Values'
task :function do
  Rake::Task["rtsnumber"].invoke
  Rake::Task["rtsstring"].invoke
  Rake::Task["rtsarray"].invoke
end

desc 'Returning a Number'
task :rtsnumber do
  list = Dir.glob('m0?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Returning a String'
task :rtsstring do
  list = Dir.glob('m1?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

desc 'Returning an Array'
task :rtsarray do
  list = Dir.glob('m3?.*')
  Rake::Task[:execute].invoke(list)
  Rake::Task[:execute].reenable
end

# ==============================================
