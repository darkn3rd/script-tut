# scenarios.rb - the same lettered table README.md documents by hand,
#  kept here as real data so integration_test.rb doesn't have to
#  re-parse prose to know what each letter means. Deliberately a
#  separate small data file, not shared with test_generate_install_
#  script.rb's own TestReadmeScenarios - that suite already passed with
#  its own inline select/exclude arrays before this file existed, and
#  duplicating a few short rows here is cheaper than risking a refactor
#  regressing already-verified, already-passing unit tests for the sake
#  of DRY. Keep both in sync with README.md's own table by hand if a
#  scenario is ever added, changed, or removed.
#
# `selector:` is each scenario's *own* field, not a single shared
#  constant every scenario silently inherited - confirmed directly this
#  mattered: with one module-level SELECTOR every scenario used
#  regardless of its own row here, scenarios.rb alone couldn't tell you
#  what a given letter's expected results should even cover (C#/Go/Rust/
#  csh/ksh/powershell all read MISSING in every scenario's own actual
#  report, for a reason invisible from this file - the shared SELECTOR
#  scoped every one of them down to just lessons.gen_scripts's own
#  ruby/python2/python3/groovy, nothing about tag selection at all).
#  Now each row says its own scope right next to its own select/
#  exclude, so "what should this scenario actually produce" is
#  answerable from this file alone.
SCENARIOS = {
  'A' => {
    slug: 'baseline',
    label: 'Baseline (no flags)',
    selector: 'lessons.gen_scripts.{ruby,python2,python3,groovy}',
    select: [],
    exclude: []
  },
  'B' => {
    slug: 'traditional',
    label: 'Traditional bundle (rbenv + pyenv + sdkman groovy)',
    selector: 'lessons.gen_scripts.{ruby,python2,python3,groovy}',
    select: %w[rbenv pyenv sdkman_groovy],
    exclude: []
  },
  'C' => {
    slug: 'asdf',
    label: 'Full asdf',
    selector: 'lessons.gen_scripts.{ruby,python2,python3,groovy}',
    select: %w[asdf asdf_ruby asdf_python asdf_groovy],
    exclude: []
  },
  'D' => {
    slug: 'mixed',
    label: 'Mixed per-language (rbenv + asdf python + sdkman groovy)',
    selector: 'lessons.gen_scripts.{ruby,python2,python3,groovy}',
    select: %w[rbenv asdf_python sdkman_groovy],
    exclude: []
  },
  'E' => {
    slug: 'exclude',
    label: 'Exclude/omission sanity check (asdf minus groovy)',
    selector: 'lessons.gen_scripts.{ruby,python2,python3,groovy}',
    select: %w[asdf asdf_ruby asdf_python asdf_groovy],
    exclude: ['asdf_groovy']
  },
  # ZZZ - the whole manifest (selector: nil - no SECTION argument at
  #  all, see integration_test.rb's own generate_script), default/
  #  untagged path (no --select/--exclude either) - the one scenario
  #  that actually reaches global/cibox/pkgbox/scriptbox/testbox and
  #  compiled_lang/shell_scripts/win_scripts, all of which A-E skip on
  #  purpose (see this file's own top comment). Real installs of
  #  Docker, the .NET SDK, Go, a from-source Rust build, act, nfpm, and
  #  PowerShell/psake, all in one run - meaningfully slower than A-E,
  #  so this is the "run it occasionally, trust it more" scenario, not
  #  the fast day-to-day one. Named to sort last, deliberately distinct
  #  from the lettered A-E tag-selection scenarios rather than "F" -
  #  it isn't testing one more point on the same axis as those, it's a
  #  different kind of coverage entirely (breadth of the whole manifest,
  #  not depth on tag-selection logic).
  'ZZZ' => {
    slug: 'full',
    label: 'Full default install (whole manifest, no selector, no --select/--exclude)',
    selector: nil,
    select: [],
    exclude: []
  }
}.freeze
