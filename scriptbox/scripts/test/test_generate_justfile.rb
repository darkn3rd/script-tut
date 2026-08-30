require_relative 'test_helper'
require_relative '../generate_justfile'
require 'tmpdir'

class TestGenerateJustfile < Minitest::Test
  CONFIG_PATH = File.expand_path('../../config/ubuntu2204.yml', __dir__)

  def generate(select = [])
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'ubuntu2204.just')
      write_resolved_justfile(
        CONFIG_PATH, path, select_tags: select, check_host: false,
        selectors: ['lessons.gen_scripts.{ruby,python3}']
      )
      return File.binread(path)
    end
  end

  def test_emits_one_bash_script_recipe
    output = generate

    assert_includes output, '[script("bash")]'
    assert_includes output, "install:\n"
    assert_includes output, '    set -e'
    refute_includes output, '#!/bin/bash'
  end

  def test_uses_the_existing_resolved_provider_selection
    output = generate(%w[asdf asdf_ruby asdf_python])

    assert_includes output, 'asdf install ruby 4.0.6'
    assert_includes output, 'asdf install python 3.14.7'
    refute_includes output, 'rbenv install'
    refute_includes output, 'pyenv install'
  end

  def test_platform_matching_distinguishes_windows_shell_environments
    env_path = File.expand_path('../../config/env.yml', __dir__)
    dir = File.dirname(env_path)

    assert_equal true, just_platform_supported?(File.join(dir, 'windows.yml'), 'windows', 'windows_nt.10_0_26200')
    assert_equal false, just_platform_supported?(File.join(dir, 'windows.yml'), 'windows', 'mingw64_nt.10_0_26200')
    assert_equal true, just_platform_supported?(File.join(dir, 'msys2.yml'), 'msys2', 'mingw64_nt.10_0_26200')
    assert_equal true, just_platform_supported?(File.join(dir, 'cygwin.yml'), 'cygwin', 'cygwin_nt.10_0_26200')
  end

  def test_windows_elevation_waits_while_justs_temporary_script_exists
    config = File.expand_path('../../config/windows.yml', __dir__)
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'windows.just')
      write_resolved_justfile(config, path, check_host: false)
      output = File.binread(path)

      assert_includes output, '[script("powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]'
      assert_includes output, 'Start-Process powershell.exe -Verb RunAs -Wait -ArgumentList'
    end
  end
end
