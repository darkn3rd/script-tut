require 'minitest/autorun'
require 'tmpdir'
require_relative '../generate_dockerfile'

class TestGenerateDockerfile < Minitest::Test
  PROFILE = File.expand_path('../profiles/polyglot-noble.yml', __dir__)

  def test_generates_layered_polyglot_dockerfile
    Dir.mktmpdir do |dir|
      output = File.join(dir, 'Dockerfile')
      generate_dockerfile(PROFILE, output)
      dockerfile = File.binread(output)

      assert_includes dockerfile, 'FROM python:3.14.7-slim-bookworm AS component_python'
      assert_includes dockerfile, 'FROM mcr.microsoft.com/dotnet/sdk:10.0-noble@sha256:'
      assert_includes dockerfile, 'COPY --from=component_python /usr/local/ /usr/local/'
      assert_operator dockerfile.index('openjdk-17-jdk-headless'), :<, dockerfile.index('COPY --from=component_groovy')
      assert_includes dockerfile, 'CMD ["/bin/bash"]'
      refute_includes dockerfile, 'asdf'
    end
  end
end
