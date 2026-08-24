require_relative 'test_helper'

class TestPathMatches < Minitest::Test
  def test_exact_match
    assert path_matches?('lessons.gen_scripts.perl', 'lessons.gen_scripts.perl')
  end

  def test_selector_matches_a_deeper_descendant_path
    assert path_matches?('lessons.gen_scripts.perl', 'lessons.gen_scripts')
  end

  def test_selector_matches_as_a_consecutive_run_anywhere_in_the_path
    assert path_matches?('global.lessons.gen_scripts.groovy', 'lessons.gen_scripts.groovy')
  end

  def test_selector_does_not_match_out_of_order_segments
    refute path_matches?('lessons.gen_scripts.groovy', 'gen_scripts.lessons')
  end

  def test_selector_longer_than_the_path_never_matches
    refute path_matches?('lessons', 'lessons.gen_scripts.groovy')
  end

  def test_selector_does_not_match_a_non_consecutive_subsequence
    refute path_matches?('lessons.gen_scripts.groovy', 'lessons.groovy')
  end
end

class TestExpandSelectors < Minitest::Test
  def test_plain_token_passes_through
    assert_equal ['testbox'], expand_selectors(['testbox'])
  end

  def test_brace_expands_into_one_selector_per_name
    result = expand_selectors(['lessons.gen_scripts.{ruby,python2,python3,groovy}'])

    assert_equal %w[
      lessons.gen_scripts.ruby
      lessons.gen_scripts.python2
      lessons.gen_scripts.python3
      lessons.gen_scripts.groovy
    ], result
  end

  def test_multiple_argv_tokens_each_expand_independently
    result = expand_selectors(['testbox', 'lessons.{compiled_lang,shell_scripts}'])

    assert_equal ['testbox', 'lessons.compiled_lang', 'lessons.shell_scripts'], result
  end
end

class TestResolveIncludedSectionRegression < Minitest::Test
  # The real bug this whole file guards against: selecting a narrow
  # SECTION whose own needs:/meets: chain reaches into a completely
  # different part of the tree (groovy needing perl's own cpanm) must
  # not drop that provider's own unit_span (its attached bootstrap
  # script) or natural_prefix (its own unstated local prerequisites) -
  # see resolve_order.rb's own natural_prefix/unit_span docs for the
  # full story, and this session's own README for the real CPAN
  # FirstTime.pm failure this caused before it was fixed.
  def tree
    {
      'lessons' => {
        'gen_scripts' => {
          'packages' => [
            { 'apt' => 'curl' }, # untagged, no needs:/meets: at all - a real local prerequisite anyway
            { 'apt' => 'build-essential', 'meets' => 'make' }
          ],
          'perl' => {
            'packages' => [
              { 'system' => 'perl', 'meets' => 'perl', 'script' => 'cpan_setup', 'needs' => 'make' },
              { 'cpan' => 'App::cpanminus', 'meets' => 'cpanm' }
            ]
          },
          'groovy' => {
            'packages' => [{ 'cpanm' => 'HTTP::Tiny', 'needs' => 'cpanm' }]
          }
        }
      }
    }
  end

  def selected_for(selector)
    steps = flatten(tree)
    included, = resolve_included(steps, [], [], selectors: expand_selectors([selector]))
    topological_order(included)
    included
  end

  def test_pulls_in_the_providers_own_unit_span
    steps = selected_for('lessons.gen_scripts.groovy')

    assert(steps.any? { |s| s[:type] == 'script' && s[:name] == 'cpan_setup' },
           "expected perl's own attached bootstrap script to be pulled in alongside system: perl")
  end

  def test_pulls_in_the_providers_own_natural_prefix
    steps = selected_for('lessons.gen_scripts.groovy')

    assert(steps.any? { |s| s[:name] == 'curl' },
           'expected gen_scripts own untagged local prerequisite (no needs:/meets: at all) to be pulled in')
  end

  def test_pulls_in_the_transitive_chain_all_the_way_to_the_root_provider
    steps = selected_for('lessons.gen_scripts.groovy')

    # groovy needs: cpanm -> cpan:App::cpanminus meets: cpanm, implicitly
    # needs: perl -> system: perl meets: perl - two hops, both required.
    assert(steps.any? { |s| s[:name] == 'App::cpanminus' })
    assert(steps.any? { |s| s[:type] == 'system' && s[:name] == 'perl' })
  end
end

# The other real bug hierarchy expansion has had, repeatedly: an
# ancestor level of a selected path (e.g. "global.lessons.gen_scripts"
# is an ancestor of "global.lessons.gen_scripts.python3") must be
# included unconditionally, the same way it would run in the unfiltered
# whole-manifest build - NOT only when some selected leaf happens to
# `needs:` one specific ancestor step by name. That second, needs:/
# meets:-gated version is what actually shipped (asdf's own
# `asdf_plugin: <lang>` steps, sitting at gen_scripts' own ancestor
# level with no needs:/meets: link to the leaf asdf: <lang> steps at
# all, were silently dropped from every narrow per-language SECTION
# selection - confirmed directly against a live VM: `asdf install
# groovy` failed with "Plugin named groovy not installed" because `asdf
# plugin add groovy` had never run). A sibling subsection at the same
# ancestor level (here, `ruby` sitting next to `python3` under
# gen_scripts) must NOT be pulled in the same way - only genuine
# ancestors of the selected path, never a sibling branch off of one.
class TestResolveIncludedHierarchy < Minitest::Test
  def tree
    {
      'global' => {
        'packages' => [{ 'apt' => 'root_level_pkg' }],
        'lessons' => {
          'packages' => [{ 'apt' => 'lessons_level_pkg' }],
          'gen_scripts' => {
            # No needs:/meets: on this at all - nothing for a leaf to
            # ever "need" by name, same as asdf_plugin's own real shape.
            'packages' => [{ 'apt' => 'gen_scripts_level_pkg' }],
            'python3' => {
              'packages' => [{ 'system' => 'python' }]
            },
            'ruby' => {
              'packages' => [{ 'system' => 'ruby' }]
            }
          }
        }
      }
    }
  end

  def selected_for(selector)
    steps = flatten(tree)
    included, = resolve_included(steps, [], [], selectors: expand_selectors([selector]))
    topological_order(included)
    included
  end

  def test_pulls_in_every_ancestor_levels_own_untagged_packages
    steps = selected_for('lessons.gen_scripts.python3')

    assert(steps.any? { |s| s[:name] == 'root_level_pkg' }, 'expected global-level own package, unconditionally')
    assert(steps.any? { |s| s[:name] == 'lessons_level_pkg' }, 'expected lessons-level own package, unconditionally')
    assert(steps.any? { |s| s[:name] == 'gen_scripts_level_pkg' },
           'expected gen_scripts-level own package, unconditionally - it has no needs:/meets: link to python3 at all')
  end

  def test_does_not_pull_in_a_sibling_subsections_own_packages
    steps = selected_for('lessons.gen_scripts.python3')

    refute(steps.any? { |s| s[:name] == 'ruby' },
           "ruby is a sibling of python3 under gen_scripts, not an ancestor - selecting python3 shouldn't include it")
  end
end

# Formalizes README.md's own "combinations you would try" table for
# generate_install_script.rb - each scenario run against the *real*
# manifest (scriptbox/config/ubuntu2204.yml), not a synthetic fixture,
# since the whole point is confirming these specific --select/--exclude
# combinations still produce what the README says they do. Expected
# step sets were captured by actually running the pipeline once (see
# git history) and reading the real output, not derived from reading
# the manifest by eye - this file's own job from here is to keep that
# confirmed-correct snapshot from silently drifting.
class TestReadmeScenarios < Minitest::Test
  CONFIG_PATH = File.expand_path('../../config/ubuntu2204.yml', __dir__)
  SELECTOR = ['lessons.gen_scripts.{ruby,python2,python3,groovy}'].freeze

  def self.tree
    @tree ||= begin
      raw = YAML.load_file(CONFIG_PATH)
      name = root_key(raw)
      substitute_variables(raw, raw[name]['variables'] || {})
    end
  end

  def run_scenario(select_tags, exclude_tags)
    name = root_key(self.class.tree)
    steps = flatten(self.class.tree[name])
    steps, omitted = resolve_included(steps, select_tags, exclude_tags, selectors: expand_selectors(SELECTOR))
    topological_order(steps)
    dedup!(steps)
    [steps, omitted]
  end

  def names(steps)
    steps.map { |s| s[:name] }
  end

  def test_a_baseline_uses_system_ruby_python_and_sdkman_groovy
    steps, = run_scenario([], [])

    assert_includes names(steps), 'App::cpanminus' # perl bootstrap still required by groovy's own cpanm step
    assert(steps.any? { |s| s[:type] == 'sdkman' }, 'expected groovy via sdkman (the default path)')
    assert(steps.any? { |s| s[:path].end_with?('.ruby') && s[:type] == 'system' })
    assert(steps.any? { |s| s[:path].end_with?('.python3') && s[:type] == 'system' })
    refute(steps.any? { |s| s[:type] == 'rbenv' })
    refute(steps.any? { |s| s[:type] == 'pyenv' })
    refute(steps.any? { |s| s[:type] == 'asdf' })
  end

  def test_b_traditional_bundle_uses_rbenv_pyenv_and_sdkman_groovy
    steps, = run_scenario(%w[rbenv pyenv sdkman_groovy], [])

    assert(steps.any? { |s| s[:type] == 'rbenv' })
    assert(steps.any? { |s| s[:type] == 'pyenv' && s[:path].end_with?('.python3') })
    assert(steps.any? { |s| s[:type] == 'pyenv' && s[:path].end_with?('.python2') },
           'python2 shares the pyenv tag, so selecting pyenv covers it too')
    assert(steps.any? { |s| s[:type] == 'sdkman' })
    refute(steps.any? { |s| s[:type] == 'asdf' })
  end

  def test_c_full_asdf_pulls_in_bootstrap_and_all_three_plugins
    steps, = run_scenario(%w[asdf asdf_ruby asdf_python asdf_groovy], [])

    assert(steps.any? { |s| s[:type] == 'script' && s[:meets] == 'asdf' }, 'expected the asdf bootstrap script')
    # asdf_plugin steps live at gen_scripts' own level (an ancestor of
    # ruby/python3/groovy, not nested under any one of them) with no
    # needs:/meets: link of their own to the leaf asdf: <lang> steps -
    # this is the actual regression the test's own name always claimed
    # to cover but never asserted: they were silently missing from this
    # scenario's real output until hierarchy expansion was fixed to
    # include ancestor-level packages unconditionally (see
    # TestResolveIncludedHierarchy).
    assert(steps.any? { |s| s[:type] == 'asdf_plugin' && s[:name].start_with?('ruby ') }, 'expected asdf plugin add ruby')
    assert(steps.any? { |s| s[:type] == 'asdf_plugin' && s[:name].start_with?('python ') }, 'expected asdf plugin add python')
    assert(steps.any? { |s| s[:type] == 'asdf_plugin' && s[:name].start_with?('groovy ') }, 'expected asdf plugin add groovy')
    assert(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.ruby') })
    assert(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.python3') })
    assert(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.groovy') })
    refute(steps.any? { |s| s[:type] == 'rbenv' })
    refute(steps.any? { |s| s[:type] == 'pyenv' })
    refute(steps.any? { |s| s[:type] == 'sdkman' })
  end

  def test_d_mixed_per_language_combines_independently_selected_tags
    steps, = run_scenario(%w[rbenv asdf_python sdkman_groovy], [])

    assert(steps.any? { |s| s[:type] == 'rbenv' }, 'ruby via rbenv')
    assert(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.python3') }, 'python via asdf')
    assert(steps.any? { |s| s[:type] == 'sdkman' }, 'groovy via sdkman')
    refute(steps.any? { |s| s[:type] == 'pyenv' })
    refute(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.ruby') })
    refute(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.groovy') })
  end

  def test_e_excluding_asdf_groovy_leaves_groovy_with_no_active_path
    steps, = run_scenario(%w[asdf asdf_ruby asdf_python asdf_groovy], ['asdf_groovy'])

    refute(steps.any? { |s| s[:path].end_with?('.groovy') },
           'groovy has no eligible install path at all once its only tagged alternative is excluded')
    # The rest of the selection is unaffected by excluding just groovy's own tag.
    assert(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.ruby') })
    assert(steps.any? { |s| s[:type] == 'asdf' && s[:path].end_with?('.python3') })
  end
end

# Real-manifest regression coverage for tag_eligible?'s own two,
# BOTH-intentional shapes (see its own header comment, "issue #16") -
# confirmed the hard way this session: an untagged step (system: ruby)
# being unconditionally eligible regardless of selection was initially
# misread as a bug ("selecting rbenv shouldn't also install system
# ruby") and briefly patched by retagging it - the manifest author
# caught this immediately: system: ruby is a deliberate always-on OS
# baseline, and rbenv/asdf/rvm are genuinely opt-in ADDITIONS layered on
# top of it, never replacements. These tests exist so that
# misdiagnosis can't quietly reappear and get "fixed" again.
class TestRubyAdditiveAlternatives < Minitest::Test
  CONFIG_PATH = File.expand_path('../../config/ubuntu2204.yml', __dir__)

  def self.tree
    @tree ||= begin
      raw = YAML.load_file(CONFIG_PATH)
      name = root_key(raw)
      substitute_variables(raw, raw[name]['variables'] || {})
    end
  end

  def ruby_steps_for(select_tags)
    name = root_key(self.class.tree)
    steps = flatten(self.class.tree[name])
    steps, = resolve_included(steps, select_tags, [])
    topological_order(steps)
    steps.select { |s| s[:path].end_with?('.ruby') }
  end

  def test_no_selection_installs_the_system_baseline_and_rvms_own_default
    # rvm carries tags: [rvm, default] - its own group's default,
    # since nothing else in that same group (rbenv/asdf_ruby) was
    # selected. Group-scoped default resolution (see compute_default_
    # wins) means this activates independent of system's own additive
    # baseline - the two coexist, same as any other tag-selected
    # alternative would alongside system.
    steps = ruby_steps_for([])
    assert_equal [['system', 'ruby'], ['rvm', '4.0.6']], steps.map { |s| [s[:type], s[:name]] }
  end

  def test_selecting_rbenv_suppresses_rvms_own_default
    # rbenv is in the *same* group as rvm (gen_scripts.ruby.packages) -
    # explicitly selecting rbenv means that group's own default no
    # longer wins, so rvm drops out even though nothing named it in
    # --exclude.
    steps = ruby_steps_for(['rbenv'])
    refute(steps.any? { |s| s[:type] == 'rvm' })
  end

  def test_rbenv_installs_alongside_the_system_baseline
    steps = ruby_steps_for(['rbenv'])
    assert(steps.any? { |s| s[:type] == 'system' },
           'system: ruby is an always-on baseline by design - rbenv adds to it, does not replace it')
    assert(steps.any? { |s| s[:type] == 'rbenv' })
  end

  def test_asdf_ruby_installs_alongside_the_system_baseline
    steps = ruby_steps_for(%w[asdf asdf_ruby])
    assert(steps.any? { |s| s[:type] == 'system' })
    assert(steps.any? { |s| s[:type] == 'asdf' })
  end

  def test_rvm_installs_alongside_the_system_baseline
    steps = ruby_steps_for(['rvm'])
    assert(steps.any? { |s| s[:type] == 'system' })
    assert(steps.any? { |s| s[:type] == 'rvm' })
  end
end

# Groovy's own two real paths (sdkman, asdf) are the *other* shape -
# neither is untagged; sdkman's own tags: [sdkman_groovy, default] is
# the manifest's own declared fallback (groovy has no Ubuntu package of
# its own, so something has to be the zero-flag default), gated on
# select_tags being empty per tag_eligible? - so selecting one real
# path here correctly excludes the other, unlike ruby's additive system
# baseline above. Confirmed directly - do not assume one of these two
# classes proves anything about the other.
class TestGroovyTagGatedAlternatives < Minitest::Test
  CONFIG_PATH = File.expand_path('../../config/ubuntu2204.yml', __dir__)

  def self.tree
    @tree ||= begin
      raw = YAML.load_file(CONFIG_PATH)
      name = root_key(raw)
      substitute_variables(raw, raw[name]['variables'] || {})
    end
  end

  def groovy_steps_for(select_tags)
    name = root_key(self.class.tree)
    steps = flatten(self.class.tree[name])
    steps, = resolve_included(steps, select_tags, [])
    topological_order(steps)
    steps.select { |s| s[:path].end_with?('.groovy') }
  end

  def test_asdf_groovy_excludes_sdkman_and_its_own_cpanm_prerequisite
    steps = groovy_steps_for(%w[asdf asdf_groovy])

    assert_equal [['asdf', 'groovy 5.1.0']], steps.map { |s| [s[:type], s[:name]] }
    refute(steps.any? { |s| s[:type] == 'sdkman' },
           'sdkman groovy must not also be installed when asdf_groovy was explicitly chosen')
    refute(steps.any? { |s| s[:type] == 'cpanm' && s[:name] == 'HTTP::Tiny' },
           "sdkman's own cpanm prerequisite shouldn't be pulled in either - nothing needs it once sdkman itself isn't selected")
  end

  def test_sdkman_groovy_excludes_asdf
    steps = groovy_steps_for(%w[sdkman sdkman_groovy])

    assert(steps.any? { |s| s[:type] == 'sdkman' })
    refute(steps.any? { |s| s[:type] == 'asdf' })
  end
end
