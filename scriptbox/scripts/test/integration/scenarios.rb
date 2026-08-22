# scenarios.rb - the same A-E table README.md documents by hand, kept
#  here as real data so integration_test.rb doesn't have to re-parse
#  prose to know what each letter means. Deliberately a separate small
#  data file, not shared with test_generate_install_script.rb's own
#  TestReadmeScenarios - that suite already passed with its own inline
#  select/exclude arrays before this file existed, and duplicating five
#  short rows here is cheaper than risking a refactor regressing
#  already-verified, already-passing unit tests for the sake of DRY.
#  Keep both in sync with README.md's own table by hand if a scenario
#  is ever added, changed, or removed.
SCENARIOS = {
  'A' => {
    slug: 'baseline',
    label: 'Baseline (no flags)',
    select: [],
    exclude: []
  },
  'B' => {
    slug: 'traditional',
    label: 'Traditional bundle (rbenv + pyenv + sdkman groovy)',
    select: %w[rbenv pyenv sdkman_groovy],
    exclude: []
  },
  'C' => {
    slug: 'asdf',
    label: 'Full asdf',
    select: %w[asdf asdf_ruby asdf_python asdf_groovy],
    exclude: []
  },
  'D' => {
    slug: 'mixed',
    label: 'Mixed per-language (rbenv + asdf python + sdkman groovy)',
    select: %w[rbenv asdf_python sdkman_groovy],
    exclude: []
  },
  'E' => {
    slug: 'exclude',
    label: 'Exclude/omission sanity check (asdf minus groovy)',
    select: %w[asdf asdf_ruby asdf_python asdf_groovy],
    exclude: ['asdf_groovy']
  }
}.freeze

SELECTOR = 'lessons.gen_scripts.{ruby,python2,python3,groovy}'.freeze
