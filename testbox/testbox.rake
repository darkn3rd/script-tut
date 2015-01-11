#!/usr/bin/ruby
require '../../testbox/Script'  # include Script.rb

task :default do
  Rake::Task["header"].invoke
  Rake::Task["output"].invoke
  Rake::Task["variables"].invoke
  Rake::Task["arithmetic"].invoke
  Rake::Task["input"].invoke
  Rake::Task["branch"].invoke
  Rake::Task["loop"].invoke
  Rake::Task["array"].invoke
  Rake::Task["associative"].invoke
  Rake::Task["subroutine"].invoke
  Rake::Task["arguments"].invoke
  Rake::Task["parameters"].invoke
  Rake::Task["exit"].invoke
  Rake::Task["function"].invoke
end

task :header do
  puts "Environment:      #{Script.ostype} (#{Script.cputype})"
  puts "Language Target:  #{Script.language_name} (#{`command -v #{Script.path}`.chomp})"
  puts "Language Version: #{Script.version}"
  puts "==============================================================="
end

# For Future
# sh %Q{grep pattern file} do |ok, res|
#   if ! ok
#     puts "pattern not found (status = #{res.exitstatus})"
#   end
# end

desc 'Output to Console (stdout, stderr)'
task :output do
  Rake::Task["header"].invoke
  Rake::Task["a0"].invoke
  Rake::Task["a1"].invoke
  Rake::Task["a2"].invoke
end

desc 'Standard Ouput'
task :a0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Standard Error'
task :a1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Output Here-String (or Multiline String)'
task :a2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Variables'
task :variables do
  Rake::Task["header"].invoke
  Rake::Task["b0"].invoke
  Rake::Task["b1"].invoke
  Rake::Task["b2"].invoke
  Rake::Task["b3"].invoke
end

desc 'String Concatenation'
task :b0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'String Concatenation'
task :b1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'String Formatting'
task :b2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Here-String (Multiline String)'
task :b3 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Basic Arirthmetic'
task :arithmetic do
  Rake::Task["header"].invoke
  Rake::Task["c0"].invoke
  Rake::Task["c1"].invoke
  Rake::Task["c2"].invoke
  Rake::Task["c3"].invoke
end

desc 'Multiplication'
task :c0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Boolean Logic'
task :c1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Exponential'
task :c2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Math Function (Triganometry)'
task :c3 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'User Input'
task :input do
  Rake::Task["header"].invoke
  Rake::Task["d0"].invoke
  Rake::Task["d1"].invoke
end

desc 'Line Input'
task :d0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Character Input'
task :d1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Branching'
task :branch do
  Rake::Task["header"].invoke
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
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Ternary (or single-line)'
task :e1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Number Range'
task :e2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Number Match'
task :e3 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Multiway with Number'
task :e4 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Multiway with String Pattern'
task :e5 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'String Pattern'
task :e6 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Looping'
task :loop do
  Rake::Task["header"].invoke
  Rake::Task["f0"].invoke
  Rake::Task["f1"].invoke
  Rake::Task["f2"].invoke
  Rake::Task["f3"].invoke
  Rake::Task["f4"].invoke
end

desc 'Collection Loop'
task :f0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Count Loop'
task :f1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Conditional Loop'
task :f2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Spin Loop'
task :f3 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Skipping a Loop Iteration'
task :f4 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Arrays (Lists)'
task :array do
  Rake::Task["header"].invoke
  Rake::Task["g0"].invoke
  Rake::Task["g1"].invoke
  Rake::Task["g2"].invoke
end

desc 'Array Index Assignment and Length'
task :g0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Array List Assignment and Enumeration by Item'
task :g1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Array List Assignment and Enumeration by Item'
task :g2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Associative Arrays (Hash, Map, Dictionary)'
task :associative do
  Rake::Task["header"].invoke
  Rake::Task["h0"].invoke
  Rake::Task["h1"].invoke
end

desc 'Association Array Assignment by Key'
task :h0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end


desc 'Association Array Assignment by List and Appending'
task :h1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Subroutines (Procedures)'
task :subroutine do
  Rake::Task["header"].invoke
  Rake::Task["i0"].invoke
  Rake::Task["i1"].invoke
  Rake::Task["i2"].invoke
end

desc 'Creating and Calling'
task :i0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Global Variables'
task :i1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Local Variables'
task :i2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Arguments from Command-Line'
task :arguments do
  Rake::Task["header"].invoke
  Rake::Task["j0"].invoke
  Rake::Task["j1"].invoke
  Rake::Task["j2"].invoke
end

desc 'Usage Statement, Script Name, Argument Count'
task :j0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Enumerate Arguments in Order'
task :j1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Enumerate Arguments in Reverse Order'
task :j2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Parameters to Subroutines'
task :parameters do
  Rake::Task["header"].invoke
  Rake::Task["k0"].invoke
  Rake::Task["k1"].invoke
end

desc 'Passing a Single Parameter'
task :k0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Passing Variable Number of Parameters'
task :k1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Exit'
task :exit do
  Rake::Task["header"].invoke
  Rake::Task["l0"].invoke
end

## NOTE THIS SHOULD HAVE A POS AND NEG TEST

desc 'Reporting Status Code'
task :l0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

# ==============================================
desc 'Functions and Returning Values'
task :function do
  Rake::Task["header"].invoke
  Rake::Task["m0"].invoke
  Rake::Task["m1"].invoke
  Rake::Task["m2"].invoke
end

desc 'Returning a Number'
task :m0 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end

desc 'Returning a String'
task :m1 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  puts result
end

desc 'Returning an Array'
task :m2 do |t|
  Rake::Task["header"].invoke
  list   = Dir.glob("#{t.to_s}?.*")
  result = Script.execute(t.to_s, list)
  Script.report(result)
end
