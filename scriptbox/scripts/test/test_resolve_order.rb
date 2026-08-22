require_relative 'test_helper'

# Small synthetic manifests, not the real scriptbox/config/*.yml - these
#  tests are about the pipeline mechanism itself (flatten/resolve!/
#  select_by_tags/unit_span/natural_prefix), which should stay correct
#  independent of whatever the real manifest's own content happens to
#  look like on any given day. See test_generate_install_script.rb for
#  tests against the real manifest.
class TestFlatten < Minitest::Test
  def test_extracts_basic_package_fields
    tree = { 'packages' => [{ 'apt' => 'curl', 'meets' => 'curl', 'tags' => ['x'] }] }
    steps = flatten(tree)

    assert_equal 1, steps.length
    step = steps.first
    assert_equal 'apt', step[:type]
    assert_equal 'curl', step[:name]
    assert_equal 'curl', step[:meets]
    assert_equal ['x'], step[:tags]
    assert_equal '', step[:path]
  end

  def test_builds_dotted_path_through_nested_hashes
    tree = { 'lessons' => { 'gen_scripts' => { 'packages' => [{ 'apt' => 'make' }] } } }
    steps = flatten(tree)

    assert_equal 'lessons.gen_scripts', steps.first[:path]
  end

  def test_needs_is_nil_not_empty_array_when_absent
    tree = { 'packages' => [{ 'apt' => 'curl' }] }
    step = flatten(tree).first

    assert_nil step[:needs]
    refute step[:needs] # the actual bug this guards: [] is truthy in Ruby
  end

  def test_needs_is_normalized_to_an_array_when_present
    tree = { 'packages' => [{ 'apt' => 'curl', 'needs' => 'make' }] }
    step = flatten(tree).first

    assert_equal ['make'], step[:needs]
  end

  def test_cpan_implicitly_needs_perl
    tree = { 'packages' => [{ 'cpan' => 'App::cpanminus', 'meets' => 'cpanm' }] }
    step = flatten(tree).first

    assert_equal ['perl'], step[:needs]
  end

  def test_cpanm_implicitly_needs_perl
    tree = { 'packages' => [{ 'cpanm' => 'Switch' }] }
    step = flatten(tree).first

    assert_equal ['perl'], step[:needs]
  end

  def test_explicit_needs_on_a_cpan_step_merges_with_implicit_perl
    tree = { 'packages' => [{ 'cpan' => 'Foo', 'needs' => 'make' }] }
    step = flatten(tree).first

    assert_equal %w[make perl], step[:needs]
  end

  def test_implicit_needs_does_not_duplicate_an_explicit_perl
    tree = { 'packages' => [{ 'cpan' => 'Foo', 'needs' => 'perl' }] }
    step = flatten(tree).first

    assert_equal ['perl'], step[:needs]
  end

  def test_other_package_types_get_no_implicit_needs
    tree = { 'packages' => [{ 'apt' => 'curl' }] }
    step = flatten(tree).first

    assert_nil step[:needs]
  end

  def test_script_and_append_attach_to_their_package
    tree = {
      'packages' => [
        { 'system' => 'perl', 'meets' => 'perl', 'script' => 'setup', 'append' => 'setup' }
      ]
    }
    steps = flatten(tree)

    assert_equal %w[system script append], steps.map { |s| s[:type] }
    assert_equal 'perl', steps[1][:attached_to]
    assert_equal 'perl', steps[2][:attached_to]
  end

  def test_attachable_key_with_no_real_package_type_becomes_its_own_step
    tree = { 'packages' => [{ 'script' => 'ubuntu22_sdkman', 'append' => 'ubuntu22_sdkman' }] }
    steps = flatten(tree)

    # The primary 'script' step is emitted once, not doubled up just
    #  because 'script' is itself in ATTACHABLE_KEYS - see flatten's own
    #  comment on the real bug this regression-guards.
    assert_equal %w[script append], steps.map { |s| s[:type] }
  end

  def test_append_with_array_value_becomes_one_step_per_name
    tree = {
      'packages' => [
        { 'script' => 'ubuntu22_rbenv', 'append' => %w[bash_rc zsh_rc] }
      ]
    }
    steps = flatten(tree)

    assert_equal %w[script append append], steps.map { |s| s[:type] }
    assert_equal %w[bash_rc zsh_rc], steps[1..].map { |s| s[:name] }
  end
end

class TestUnitSpan < Minitest::Test
  def test_includes_attached_steps_following_the_provider
    tree = {
      'packages' => [
        { 'system' => 'perl', 'meets' => 'perl', 'script' => 'setup', 'append' => 'setup' },
        { 'cpan' => 'App::cpanminus' }
      ]
    }
    steps = flatten(tree)
    start, finish = unit_span(steps, 0)

    assert_equal 0, start
    assert_equal 2, finish # system + script + append, not the following cpan step
  end

  def test_includes_a_preceding_tap_on_the_same_path
    tree = { 'packages' => [{ 'tap' => 'some/tap' }, { 'cask' => 'some-app' }] }
    steps = flatten(tree)
    start, finish = unit_span(steps, 1)

    assert_equal 0, start
    assert_equal 1, finish
  end

  def test_single_step_with_no_attachments_spans_only_itself
    tree = { 'packages' => [{ 'apt' => 'curl' }] }
    steps = flatten(tree)
    start, finish = unit_span(steps, 0)

    assert_equal [0, 0], [start, finish]
  end
end

class TestNaturalPrefix < Minitest::Test
  def perl_groovy_tree
    {
      'lessons' => {
        'gen_scripts' => {
          'packages' => [{ 'apt' => 'build-essential', 'meets' => 'build_essential' }],
          'perl' => {
            'packages' => [
              { 'system' => 'perl', 'meets' => 'perl' },
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

  def test_includes_direct_local_siblings_before_the_provider
    steps = flatten(perl_groovy_tree)
    cpanminus = steps.find { |s| s[:name] == 'App::cpanminus' }
    prefix = natural_prefix(cpanminus, steps)

    # build-essential is gen_scripts' own direct package (path ends
    #  exactly in "gen_scripts") - a real local prerequisite even
    #  without any needs:/meets: link to cpanminus itself.
    assert_equal ['build-essential'], prefix.map { |s| s[:name] }
  end

  def test_does_not_cross_into_a_different_owning_function
    steps = flatten(perl_groovy_tree)
    perl_system = steps.find { |s| s[:type] == 'system' && s[:name] == 'perl' }
    # perl's own owning_function is gen_scripts (perl isn't a
    #  FUNCTION_SECTIONS segment); nothing precedes it in gen_scripts
    #  before build-essential, which is fine to also collect - the
    #  bound to test here is that it never climbs into `lessons` itself.
    prefix = natural_prefix(perl_system, steps)

    assert prefix.none? { |s| s[:path] == 'lessons' }
  end

  def test_skips_a_sibling_subsections_own_steps
    steps = flatten(perl_groovy_tree)
    http_tiny = steps.find { |s| s[:name] == 'HTTP::Tiny' }
    prefix = natural_prefix(http_tiny, steps)

    # The walk passes through perl's own steps on its way further back
    #  (perl isn't a FUNCTION_SECTIONS segment either, so it doesn't
    #  stop the walk) but skips them (path ends in "perl", not
    #  "gen_scripts") - only gen_scripts' own direct package qualifies.
    assert_equal ['build-essential'], prefix.map { |s| s[:name] }
    refute prefix.any? { |s| s[:path] == 'lessons.gen_scripts.perl' }
  end
end

class TestResolveBang < Minitest::Test
  def test_moves_a_consumer_after_its_provider
    tree = {
      'packages' => [
        { 'apt' => 'thing', 'needs' => 'toolchain' },
        { 'apt' => 'build-essential', 'meets' => 'toolchain' }
      ]
    }
    steps = flatten(tree)
    resolve!(steps)

    assert_equal %w[build-essential thing], steps.map { |s| s[:name] }
  end

  def test_leaves_already_correct_order_alone
    tree = {
      'packages' => [
        { 'apt' => 'build-essential', 'meets' => 'toolchain' },
        { 'apt' => 'thing', 'needs' => 'toolchain' }
      ]
    }
    steps = flatten(tree)
    resolve!(steps)

    assert_equal %w[build-essential thing], steps.map { |s| s[:name] }
  end
end

class TestSelectByTags < Minitest::Test
  def rbenv_asdf_tree
    {
      'packages' => [
        { 'system' => 'ruby' }, # untagged, no meets: at all - a documentation no-op, never gated
        { 'rbenv' => '4.0.6', 'meets' => 'ruby', 'tags' => ['rbenv'] },
        { 'script' => 'asdf_bootstrap', 'meets' => 'asdf', 'tags' => ['asdf'] },
        { 'asdf_plugin' => 'ruby', 'meets' => 'ruby', 'needs' => 'asdf', 'tags' => ['asdf_ruby'] }
      ]
    }
  end

  def test_untagged_step_is_always_included_regardless_of_selection
    steps = flatten(rbenv_asdf_tree)

    no_select, = select_by_tags(steps, [], [])
    with_select, = select_by_tags(steps, ['rbenv'], [])

    assert_includes no_select.map { |s| s[:name] }, 'ruby'
    assert_includes with_select.map { |s| s[:name] }, 'ruby'
  end

  def test_no_selection_excludes_every_tagged_alternative
    steps = flatten(rbenv_asdf_tree)
    included, = select_by_tags(steps, [], [])

    assert_equal ['ruby'], included.map { |s| s[:name] }
  end

  def test_select_pulls_in_the_matching_tagged_alternative
    steps = flatten(rbenv_asdf_tree)
    included, = select_by_tags(steps, ['rbenv'], [])

    assert_includes included.map { |s| s[:name] }, '4.0.6'
  end

  def test_select_transitively_pulls_in_an_untagged_prerequisite_of_a_tagged_step
    steps = flatten(rbenv_asdf_tree)
    included, = select_by_tags(steps, ['asdf_ruby'], [])
    names = included.map { |s| s[:name] }

    # asdf_plugin's own needs: asdf has no eligible provider on tag_
    #  eligible?'s own first pass alone (asdf_bootstrap only carries
    #  tags: [asdf], not asdf_ruby) - the transitive pull-in pass is
    #  what's actually being tested here, not tag_eligible? itself.
    assert_includes names, 'asdf_bootstrap'
  end

  def test_transitive_pull_in_picks_only_the_first_listed_provider
    # Two tagged alternatives both meets: ruby - neither directly
    # selected - plus a separate, always-eligible (tags: [default])
    # consumer that needs: ruby. The transitive pull-in pass has to
    # pick one provider for it; the real issue #16 bug this guards is a
    # naive pass pulling in *both*, not just the first listed.
    tree = {
      'packages' => [
        { 'rbenv' => '4.0.6', 'meets' => 'ruby', 'tags' => ['rbenv'] },
        { 'asdf_plugin' => 'ruby', 'meets' => 'ruby', 'tags' => ['asdf_ruby'] },
        { 'gem' => 'bundler', 'needs' => 'ruby', 'tags' => ['default'] }
      ]
    }
    steps = flatten(tree)
    included, = select_by_tags(steps, [], [])
    names = included.map { |s| s[:name] }

    assert_includes names, 'bundler'
    assert_includes names, '4.0.6'
    refute_includes names, 'ruby' # asdf_plugin's own step, second in document order - not pulled in twice
  end

  def test_exclude_vetoes_even_a_selected_tag
    steps = flatten(rbenv_asdf_tree)
    included, = select_by_tags(steps, ['rbenv'], ['rbenv'])

    refute_includes included.map { |s| s[:name] }, '4.0.6'
  end

  def test_omits_a_step_whose_need_has_no_provider_left
    tree = {
      'packages' => [
        { 'apt' => 'thing', 'needs' => 'asdf', 'tags' => ['default'] },
        { 'script' => 'asdf_bootstrap', 'meets' => 'asdf', 'tags' => ['asdf'] }
      ]
    }
    steps = flatten(tree)
    _included, omitted = select_by_tags(steps, [], ['asdf'])

    assert_equal 1, omitted.length
    omitted_step, missing = omitted.first
    assert_equal 'thing', omitted_step[:name]
    assert_equal 'asdf', missing
  end
end

class TestDedup < Minitest::Test
  def test_drops_an_exact_duplicate_keeping_the_first
    tree = { 'packages' => [{ 'apt' => 'curl' }, { 'apt' => 'curl' }] }
    steps = flatten(tree)
    dedup!(steps)

    assert_equal 1, steps.length
  end
end
