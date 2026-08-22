#!/usr/bin/env ruby
# integration_test.rb - end-to-end proof a generated install script
#  actually works, not just that its own step list is structurally
#  correct (see ../../test_generate_install_script.rb for that layer).
#  One scenario per run:
#    1. generate the install script (generate_install_script.rb, same
#       CLI a human would run - see scenarios.rb)
#    2. vagrant up --no-provision / vagrant provision against a real VM,
#       with TEST_PATH pointed at that scenario's own generated script
#    3. vagrant ssh in and run verify_commands.rb --format json,
#       redirected straight into the live GUEST_ROOT mount (not
#       captured over SSH's own stdout - see fetch_actual_report)
#    4. compare that against this scenario's own expected/<letter>.
#       <slug>.json baseline, flattened to {"language" / "language >
#       tool" => status}
#    5. report PASS/FAIL per item (text/json/yaml, optionally --junit
#       too), exit 1 on any FAIL
#    6. vagrant destroy, so the next run starts from a clean VM
#
#  Usage:
#    ruby integration_test.rb <A-E> [--record] [--no-destroy]
#      [--format text|json|yaml] [--junit PATH]
#
#  --record captures the *actual* report as the new expected/<letter>.
#  <slug>.json baseline instead of comparing against it - run this once
#  per scenario to establish (or intentionally update) what "correct"
#  means; nothing here hand-authors an expected baseline from theory,
#  only from a real run.
#
#  Every subprocess below is invoked with Ruby's own array-argument form
#  (system(*argv)/Open3.capture3(*argv)), never a single interpolated
#  command string - that bypasses any host shell (cmd.exe on plain
#  Windows, sh/bash under Git Bash) entirely, sidestepping the exact
#  class of quoting mismatch (single quotes mean nothing to cmd.exe,
#  $(...) isn't POSIX-portable, ...) this whole session already hit
#  more than once elsewhere.

require 'json'
require 'yaml'
require 'optparse'
require 'fileutils'
require 'open3'
require_relative 'scenarios'

ROOT = File.expand_path('../../../..', __dir__)
SCRIPTS_DIR = File.join(ROOT, 'scriptbox', 'scripts')
GENERATED_DIR = File.join(ROOT, 'scriptbox', 'generated')
VAGRANT_DIR = File.join(ROOT, 'configbox', 'bubblegum', 'hosts', 'virtualbox', 'ubuntu22')
EXPECTED_DIR = File.join(__dir__, 'expected')
ACTUAL_DIR = File.join(__dir__, 'actual')

# GUEST_ROOT - the Vagrantfile's own explicit synced_folder, mapping
#  this whole repo (ROOT) to /var/script-tut inside the guest -
#  distinct from Vagrant's own automatic default synced folder at
#  /vagrant, which only covers the Vagrantfile's own directory
#  (configbox/bubblegum/hosts/virtualbox/ubuntu22), too narrow to reach
#  scriptbox/. Since it's a live, bidirectional mount, the guest can
#  write its own report straight into ACTUAL_DIR - no need to capture
#  and parse it over SSH's own stdout at all.
GUEST_ROOT = '/var/script-tut'

# guest_path(host_path) - host_path's own equivalent under GUEST_ROOT -
#  host_path must be somewhere under ROOT for this to make sense.
def guest_path(host_path)
  relative = host_path.delete_prefix("#{ROOT}/")
  "#{GUEST_ROOT}/#{relative}"
end

# name_for(letter) - the shared "<letter>.<slug>" stem every artifact
#  for one scenario is named after: the generated script
#  (scriptbox/generated/<letter>.<slug>.sh), and this run's own
#  expected/actual JSON (expected/<letter>.<slug>.json, actual/
#  <letter>.<slug>.json) - a named input has a named result sitting
#  right next to it, not a same-named file overwritten by whichever
#  scenario ran most recently.
def name_for(letter)
  "#{letter.downcase}.#{SCENARIOS[letter][:slug]}"
end

# run!(*argv, chdir:, env:) - a real command, streamed live (not
#  captured) so a slow vagrant up/provision is visible while it runs,
#  not a silent multi-minute pause. Raises only on a genuine failure
#  (non-zero exit); the caller decides what that means for the overall
#  test.
def run!(*argv, chdir: ROOT, env: {})
  puts "+ (#{chdir}) #{env.map { |k, v| "#{k}=#{v} " }.join}#{argv.join(' ')}"
  system(env, *argv, chdir: chdir) || raise("command failed (exit #{$?.exitstatus}): #{argv.join(' ')}")
end

def generate_script(scenario, letter)
  script_path = File.join(GENERATED_DIR, "#{name_for(letter)}.sh")
  argv = ['ruby', 'generate_install_script.rb', '../config/ubuntu2204.yml', SELECTOR, '--output', script_path]
  argv += ['--select', scenario[:select].join(',')] unless scenario[:select].empty?
  argv += ['--exclude', scenario[:exclude].join(',')] unless scenario[:exclude].empty?
  run!(*argv, chdir: SCRIPTS_DIR)
  script_path
end

def vagrant_up_and_provision(script_path)
  env = { 'TEST_PATH' => script_path }
  run!('vagrant', 'up', '--no-provision', chdir: VAGRANT_DIR, env: env)
  run!('vagrant', 'provision', chdir: VAGRANT_DIR, env: env)
end

def vagrant_destroy
  run!('vagrant', 'destroy', '-f', chdir: VAGRANT_DIR)
end

def raw_actual_path(letter)
  File.join(ACTUAL_DIR, "#{name_for(letter)}.raw.json")
end

# fetch_actual_report(letter) - the guest writes its own report
#  straight into ACTUAL_DIR via the live GUEST_ROOT mount (redirected
#  guest-side, not captured over SSH's own stdout) - raw_actual_path is
#  ACTUAL_DIR's own directory, already created before this runs, so no
#  separate guest-side mkdir is needed; the shared folder makes it
#  visible there immediately.
#
#  `bash -ic` (interactive, not `-l` login) is still what actually runs
#  verify_commands.rb - confirmed directly, twice: per-user-PATH tools
#  (cpanm via local::lib, groovy via sdkman) only get their PATH
#  additions from .bashrc, which Ubuntu's own default .bashrc refuses to
#  run at all unless the shell is interactive (its own `case $- in *i*)
#  ;; *) return;; esac` guard) - login alone (bash -lc) isn't enough,
#  even though .profile does source .bashrc, because bash -lc is login
#  but *not* interactive. -ic forces interactive without also needing a
#  real login shell. Tried a real allocated TTY too (raw `ssh -t` via
#  `vagrant ssh-config`, not just vagrant's own `-c`) hoping it would
#  avoid the harmless "cannot set terminal process group"/"no job
#  control" warnings bash -ic prints with no real TTY attached -
#  confirmed directly it doesn't change anything; bash -ic on a
#  single-command, non-login exec prints them either way. No longer
#  worth caring about now that stdout isn't the payload channel at all.
def fetch_actual_report(letter)
  FileUtils.mkdir_p(ACTUAL_DIR)
  target = guest_path(raw_actual_path(letter))
  cmd = "/var/script-tut/scriptbox/scripts/verify_commands.rb --format json > #{target}"
  argv = ['vagrant', 'ssh', '-c', "bash -ic \"#{cmd}\""]
  Dir.chdir(VAGRANT_DIR) do
    _stdout, stderr, status = Open3.capture3(*argv)
    raise "vagrant ssh failed (exit #{status.exitstatus}): #{stderr}" unless status.success?
  end
  JSON.parse(File.read(raw_actual_path(letter)), symbolize_names: true)
end

# status_text(entry) - the same OK/MISSING/N/A rule verify_commands.rb's
#  own status_text implements, simplified for this harness's own fixed
#  context: the guest under test is always the Ubuntu VM (never
#  Windows), so platform_inapplicable? only ever depends on
#  windows_only - unix_only can never itself make a Linux guest
#  inapplicable. Not required from verify_commands.rb directly - that
#  file is meant to run *inside* the guest, not on the host driving
#  these tests.
def status_text(entry)
  return 'OK' if entry[:found]
  return 'N/A' if entry[:windows_only]

  'MISSING'
end

# flatten_report(report) - {"Language" => status, "Language > tool" =>
#  status}, one flat hash regardless of which area a language lives in
#  - a tool name alone (e.g. "make") isn't unique across languages (C++
#  and Java both depend on it), so it's always qualified by its own
#  language.
def flatten_report(report)
  flat = {}
  report[:areas].each do |area|
    area[:languages].each do |lang|
      flat[lang[:name]] = status_text(lang)
      lang[:tools].each do |tool|
        flat["#{lang[:name]} > #{tool[:name]}"] = status_text(tool)
      end
    end
  end
  flat
end

def expected_path(letter)
  File.join(EXPECTED_DIR, "#{name_for(letter)}.json")
end

def actual_path(letter)
  File.join(ACTUAL_DIR, "#{name_for(letter)}.json")
end

def load_expected(letter)
  path = expected_path(letter)
  unless File.exist?(path)
    warn "no expected baseline at #{path} - run with --record first"
    exit 1
  end
  JSON.parse(File.read(path))
end

def save_expected(letter, flat)
  FileUtils.mkdir_p(EXPECTED_DIR)
  File.write(expected_path(letter), JSON.pretty_generate(flat))
  puts "wrote #{expected_path(letter)}"
end

# save_actual - written every run, --record or not, so there's always a
#  real artifact of "what actually happened last time" sitting right
#  next to the expected baseline it was (or wasn't) compared against -
#  useful on its own for debugging a FAIL without re-running anything.
def save_actual(letter, flat)
  FileUtils.mkdir_p(ACTUAL_DIR)
  File.write(actual_path(letter), JSON.pretty_generate(flat))
  puts "wrote #{actual_path(letter)}"
end

# compare(expected, actual) - PASS/FAIL per item expected knows about.
#  An item actual has that expected doesn't (a tool the manifest grew
#  since the baseline was recorded) is reported separately as
#  unexpected, not silently ignored or treated as a FAIL - expected
#  just doesn't have an opinion on it yet.
def compare(expected, actual)
  results = expected.map do |name, exp_status|
    act_status = actual[name]
    { name: name, expected: exp_status, actual: act_status || 'MISSING (not reported)', pass: act_status == exp_status }
  end
  unexpected = actual.keys.map(&:to_s) - expected.keys
  [results, unexpected]
end

def render_text(scenario_letter, results, unexpected)
  lines = ["Scenario #{scenario_letter} results:", '']
  width = results.map { |r| r[:name].length }.max || 0
  results.each do |r|
    mark = r[:pass] ? 'PASS' : 'FAIL'
    lines << format("  [%-4s] %-#{width}s expected=%-8s actual=%s", mark, r[:name], r[:expected], r[:actual])
  end
  unless unexpected.empty?
    lines << ''
    lines << 'UNEXPECTED (present in actual, not in expected baseline):'
    unexpected.each { |name| lines << "  - #{name}" }
  end
  fails = results.count { |r| !r[:pass] }
  lines << ''
  lines << "#{results.length - fails}/#{results.length} passed, #{fails} failed"
  lines.join("\n")
end

def xml_escape(str)
  str.to_s.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;').gsub('"', '&quot;')
end

def render_junit(scenario_letter, results)
  fails = results.count { |r| !r[:pass] }
  cases = results.map do |r|
    if r[:pass]
      %(    <testcase name="#{xml_escape(r[:name])}" classname="scenario_#{scenario_letter}" />)
    else
      <<~XML.chomp
            <testcase name="#{xml_escape(r[:name])}" classname="scenario_#{scenario_letter}">
              <failure message="expected #{xml_escape(r[:expected])}, got #{xml_escape(r[:actual])}" />
            </testcase>
      XML
    end
  end
  <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <testsuite name="scenario_#{scenario_letter}" tests="#{results.length}" failures="#{fails}">
    #{cases.join("\n")}
    </testsuite>
  XML
end

if __FILE__ == $PROGRAM_NAME
  options = { format: 'text', record: false, destroy: true, junit: nil }
  OptionParser.new do |opts|
    opts.banner = "usage: #{$PROGRAM_NAME} <#{SCENARIOS.keys.join('|')}> [options]"
    opts.on('--record', 'capture actual output as the new expected baseline') { options[:record] = true }
    opts.on('--no-destroy', 'skip vagrant destroy at the end (leave the VM up for inspection)') { options[:destroy] = false }
    opts.on('--format FORMAT', %w[text json yaml], 'text (default), json, or yaml') { |v| options[:format] = v }
    opts.on('--junit PATH', 'also write a JUnit XML report to PATH') { |v| options[:junit] = v }
  end.parse!(ARGV)

  letter = ARGV[0]&.upcase
  scenario = SCENARIOS[letter]
  unless scenario
    warn "usage: #{$PROGRAM_NAME} <#{SCENARIOS.keys.join('|')}> [--record] [--no-destroy] [--format text|json|yaml] [--junit PATH]"
    exit 1
  end

  puts "=== Scenario #{letter}: #{scenario[:label]} (#{name_for(letter)}) ==="
  script_path = generate_script(scenario, letter)
  vagrant_up_and_provision(script_path)
  actual = flatten_report(fetch_actual_report(letter))
  save_actual(letter, actual)

  if options[:record]
    save_expected(letter, actual)
    vagrant_destroy if options[:destroy]
    exit 0
  end

  expected = load_expected(letter)
  results, unexpected = compare(expected, actual)

  case options[:format]
  when 'json'
    puts JSON.pretty_generate(results)
  when 'yaml'
    puts YAML.dump(JSON.parse(JSON.generate(results)))
  else
    puts render_text(letter, results, unexpected)
  end

  File.write(options[:junit], render_junit(letter, results)) if options[:junit]

  vagrant_destroy if options[:destroy]

  exit(results.all? { |r| r[:pass] } ? 0 : 1)
end
