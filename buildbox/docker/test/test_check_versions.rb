require 'minitest/autorun'
require 'tmpdir'
require_relative '../check_versions'

class TestCheckVersions < Minitest::Test
  def test_extracts_stable_rust_version
    manifest = <<~TOML
      manifest-version = "2"
      [pkg.rust]
      version = "1.98.0 (deadbeef 2026-08-20)"
    TOML

    stub(:get_text, manifest) do
      assert_equal '1.98.0', latest_rust('source' => 'https://example.invalid/stable.toml')
    end
  end

  def test_extracts_latest_github_tag
    release = JSON.generate('tag_name' => 'v7.6.5')

    stub(:get_text, release) do
      assert_equal '7.6.5', latest_github('repository' => 'PowerShell/PowerShell')
    end
  end

  def test_distribution_and_manual_tracks_do_not_claim_an_upstream_version
    assert_equal :distribution, latest_for('track' => 'ubuntu_noble')
    assert_equal :manual, latest_for('track' => 'manual')
  end
end
