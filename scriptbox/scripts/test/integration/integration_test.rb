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
#       <slug>.json baseline, nested by area then language (see
#       nested_report/AREA_KEYS/LANGUAGE_KEYS) - {"win_scripts" =>
#       {"powershell" => {"powershell" => status, "needs" => {"psake"
#       => status}}}, "gen_scripts" => {"awk" => status, ...}, ...}
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

# effective_config(scenario, options) - scenario's own selector/select/
#  exclude, each overridden individually by whichever of --selector/
#  --select/--exclude was actually passed on the command line (nil in
#  `options` for any that weren't - see the OptionParser block below,
#  which leaves them nil rather than defaulting to [] precisely so
#  "not passed" and "passed as an empty value" stay distinguishable
#  here). Exists so a scenario letter is a starting point, not a wall -
#  hardcoding select/exclude/selector with no way to override any of
#  them from the command line was exactly the "have to edit the test's
#  own code, or reach for another tool" complaint this fixes; a named
#  scenario still gives every run a sensible, visible default (see
#  scenarios.rb's own file-level comment), it just doesn't have the
#  only say any more.
def effective_config(scenario, options)
  {
    selector: options[:selector] || scenario[:selector],
    select: options[:select] || scenario[:select],
    exclude: options[:exclude] || scenario[:exclude]
  }
end

def generate_script(config, letter)
  script_path = File.join(GENERATED_DIR, "#{name_for(letter)}.sh")
  argv = ['ruby', 'generate_install_script.rb', '../config/ubuntu2204.yml']
  # nil/empty selector - see scenarios.rb's own 'ZZZ' entry - means no
  #  SECTION argument at all (generate_install_script.rb's own default:
  #  the whole manifest), not an empty string handed to it as one.
  argv << config[:selector] if config[:selector] && !config[:selector].empty?
  argv += ['--output', script_path]
  argv += ['--select', config[:select].join(',')] unless config[:select].empty?
  argv += ['--exclude', config[:exclude].join(',')] unless config[:exclude].empty?
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

# AREA_KEYS/LANGUAGE_KEYS - verify_commands.rb's own human-readable
#  AREAS names ("Windows Scripts", "Bourne Again Shell (bash)") mapped
#  to the short, lowercase keys nested_report actually writes - lining
#  up with scriptbox/config/*.yml's own directory/section names
#  (win_scripts, gen_scripts.{awk,groovy,perl,...}, shell_scripts.
#  {bash,csh,ksh,posix,zsh}, compiled_lang.{cs,go,java,rust}) wherever
#  the manifest actually has a matching section - not a mechanical
#  slugify (verify_commands.rb's own "C Shell (tcsh)"/"POSIX Shell
#  (dash/sh)"/"C++"/"C#" have no single automatic rule that gets all
#  four right at once), an explicit table instead, same reasoning
#  area/language names get one instead of a guess anywhere else in this
#  pipeline (e.g. resolve_order.rb's own parse_version_constraint).
#  Four entries here (Batch, PowerShell, WSH JScript, WSH VBScript,
#  and C++) have no manifest section of their own to match at all
#  (Batch/WSH are Windows-builtin, nothing to install; C++ comes from
#  build-essential, not its own compiled_lang subsection) - given a
#  short, readable key anyway rather than left out.
AREA_KEYS = {
  'Windows Scripts' => 'win_scripts',
  'Shell Scripts' => 'shell_scripts',
  'General Scripts' => 'gen_scripts',
  'Compiled Languages' => 'compiled_lang'
}.freeze

LANGUAGE_KEYS = {
  'Batch' => 'batch',
  'PowerShell' => 'powershell',
  'WSH JScript' => 'wsh.jscript',
  'WSH VBScript' => 'wsh.vbscript',
  'Bourne Again Shell (bash)' => 'bash',
  'C Shell (tcsh)' => 'csh',
  'Korn Shell (ksh)' => 'ksh',
  'POSIX Shell (dash/sh)' => 'posix',
  'Z Shell (zsh)' => 'zsh',
  'AWK' => 'awk',
  'Groovy' => 'groovy',
  'Perl' => 'perl',
  'PHP' => 'php',
  'Python2' => 'python2',
  'Python3' => 'python3',
  'Ruby' => 'ruby',
  'TCL' => 'tcl',
  'C++' => 'cpp',
  'C#' => 'cs',
  'Go' => 'go',
  'Java' => 'java',
  'Rust' => 'rust'
}.freeze

# area_key/language_key - raise on an unmapped name rather than falling
#  back to some auto-slugified guess, same fail-loud reasoning
#  parse_version_constraint already applies elsewhere: if verify_
#  commands.rb's own AREAS ever grows a new language, this should stop
#  a test run cold with a clear "go add it to the table" message, not
#  silently write a mis-keyed (or worse, inconsistently-keyed-between-
#  runs) baseline.
def area_key(name)
  AREA_KEYS.fetch(name) { raise "integration_test.rb: no AREA_KEYS entry for #{name.inspect} - add one" }
end

def language_key(name)
  LANGUAGE_KEYS.fetch(name) { raise "integration_test.rb: no LANGUAGE_KEYS entry for #{name.inspect} - add one" }
end

# nested_report(report) - {"win_scripts" => {"powershell" => {
#  "powershell" => "OK", "needs" => {"psake" => "OK"}}, ...}, ...} -
#  nested by area then language, matching the manifest's own directory/
#  section structure (see AREA_KEYS/LANGUAGE_KEYS) rather than
#  verify_commands.rb's own flat area/language/tool arrays or this
#  file's own previous flat "Language > tool" string keys. A language
#  with no tools is just its own bare status string (e.g. "awk" =>
#  "OK") - the nested {name => status, "needs" => {...}} shape only
#  shows up where there's actually a "needs" to report, so a baseline
#  reads as plainly as possible for the common case.
def nested_report(report)
  report[:areas].each_with_object({}) do |area, areas_hash|
    languages = area[:languages].each_with_object({}) do |lang, langs_hash|
      lkey = language_key(lang[:name])
      if lang[:tools].empty?
        langs_hash[lkey] = status_text(lang)
      else
        needs = lang[:tools].each_with_object({}) { |tool, h| h[tool[:name]] = status_text(tool) }
        langs_hash[lkey] = { lkey => status_text(lang), 'needs' => needs }
      end
    end
    areas_hash[area_key(area[:name])] = languages
  end
end

# flatten_tree(tree, prefix) - a nested_report-shaped Hash (or its own
#  JSON-round-tripped equivalent - see load_expected, which reads plain
#  string keys back, not symbols) walked back down into dotted-path
#  {"win_scripts.powershell.needs.psake" => "OK", ...} pairs - internal
#  to compare below, not written to disk anywhere; the persisted
#  expected/actual JSON stays nested (that's the whole point), this is
#  just the simplest way to line two nested trees up leaf-for-leaf
#  without writing a bespoke recursive differ.
def flatten_tree(tree, prefix = [])
  tree.each_with_object({}) do |(key, value), flat|
    path = prefix + [key]
    if value.is_a?(Hash)
      flat.merge!(flatten_tree(value, path))
    else
      flat[path.join('.')] = value
    end
  end
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
  flat_expected = flatten_tree(expected)
  flat_actual = flatten_tree(actual)
  results = flat_expected.map do |name, exp_status|
    act_status = flat_actual[name]
    { name: name, expected: exp_status, actual: act_status || 'MISSING (not reported)', pass: act_status == exp_status }
  end
  unexpected = flat_actual.keys - flat_expected.keys
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
  # selector/select/exclude default to nil, not ''/[] - effective_config
  #  needs to tell "not passed on the command line" apart from "passed
  #  as deliberately empty" (e.g. --select '' to force nothing tagged
  #  through even though the scenario itself selects something), which
  #  a [] default would collapse into the same thing.
  options = { format: 'text', record: false, destroy: true, junit: nil, selector: nil, select: nil, exclude: nil }
  OptionParser.new do |opts|
    opts.banner = "usage: #{$PROGRAM_NAME} <#{SCENARIOS.keys.join('|')}> [options]"
    opts.on('--record', 'capture actual output as the new expected baseline') { options[:record] = true }
    opts.on('--no-destroy', 'skip vagrant destroy at the end (leave the VM up for inspection)') { options[:destroy] = false }
    opts.on('--format FORMAT', %w[text json yaml], 'text (default), json, or yaml') { |v| options[:format] = v }
    opts.on('--junit PATH', 'also write a JUnit XML report to PATH') { |v| options[:junit] = v }
    # Overrides a named scenario's own selector/select/exclude (see
    #  scenarios.rb's own file-level comment) rather than requiring an
    #  edit to that file (or a whole separate tool) any time someone
    #  wants to try a variation - a scenario letter is a sensible,
    #  visible starting point, not the only way to configure a run.
    opts.on('--selector SELECTOR', 'override this scenario\'s own SECTION selector (empty for the whole manifest)') { |v| options[:selector] = v }
    opts.on('--select TAGS', 'override this scenario\'s own --select tags') { |v| options[:select] = v.split(',').map(&:strip) }
    opts.on('--exclude TAGS', 'override this scenario\'s own --exclude tags') { |v| options[:exclude] = v.split(',').map(&:strip) }
  end.parse!(ARGV)

  letter = ARGV[0]&.upcase
  scenario = SCENARIOS[letter]
  unless scenario
    warn "usage: #{$PROGRAM_NAME} <#{SCENARIOS.keys.join('|')}> [--selector SELECTOR] [--select TAG,TAG] [--exclude TAG,TAG] [--record] [--no-destroy] [--format text|json|yaml] [--junit PATH]"
    exit 1
  end

  config = effective_config(scenario, options)
  overridden = options[:selector] || options[:select] || options[:exclude]

  # Recording an overridden run as a named scenario's own canonical
  #  baseline would silently bake that override into it - not blocked
  #  outright (a deliberate, informed re-record is a real use case,
  #  e.g. widening what a scenario itself covers), just made loud
  #  enough that doing it by accident takes actually missing this line.
  warn "#{$PROGRAM_NAME}: recording with an override active (#{[options[:selector] && "selector=#{options[:selector].inspect}", options[:select] && "select=#{options[:select]}", options[:exclude] && "exclude=#{options[:exclude]}"].compact.join(', ')}) - this becomes scenario #{letter}'s own new baseline, not a one-off comparison" if options[:record] && overridden

  puts "=== Scenario #{letter}: #{scenario[:label]} (#{name_for(letter)}) ==="
  puts "    selector=#{config[:selector].inspect} select=#{config[:select]} exclude=#{config[:exclude]}#{' (overridden)' if overridden}"

  # begin/ensure, not a destroy call sitting at the end of each branch -
  #  confirmed directly this matters: load_expected's own `exit 1` (no
  #  recorded baseline yet) skipped vagrant_destroy entirely, leaving a
  #  real VM running - and so would any run!() failure anywhere above
  #  (vagrant up, provision, ssh), none of which were ever caught either.
  #  ensure runs on *any* way this begin block ends - a normal fall-
  #  through, an explicit exit (Kernel#exit raises SystemExit, which
  #  unwinds through ensure same as any other exception - only exit!
  #  skips it), or an uncaught exception - so vagrant_destroy (or
  #  --no-destroy's own skip of it) now applies uniformly no matter
  #  which of those actually happens, instead of only the two paths
  #  that happened to remember to call it themselves.
  exit_code = 0
  begin
    script_path = generate_script(config, letter)
    vagrant_up_and_provision(script_path)
    actual = nested_report(fetch_actual_report(letter))
    save_actual(letter, actual)

    if options[:record]
      save_expected(letter, actual)
    else
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

      exit_code = results.all? { |r| r[:pass] } ? 0 : 1
    end
  ensure
    # --no-destroy - the option to leave the VM up for a real look at
    #  what went wrong, not just a log after the fact - applies here
    #  too, same as the two call sites this replaced already respected
    #  it: a run you deliberately kept up for inspection stays up
    #  whether it passed, failed, or blew up outright.
    vagrant_destroy if options[:destroy]
  end

  exit(exit_code)
end
