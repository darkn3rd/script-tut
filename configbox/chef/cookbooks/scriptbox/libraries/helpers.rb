# Scriptbox::Helpers#scriptbox_install - one step from the scriptbox
#  data bag's own flat packages array (see scriptbox/scripts/generate_
#  scriptbox_databag.rb's own step_to_entry, reused from generate_chef_
#  databag.rb) dispatched to the matching Chef resource. Mirrors the
#  lessons cookbook's own lessons_install/SPECIAL_SCRIPTS shape exactly -
#  a small SPECIAL_SCRIPTS intercept for the one script step whose real
#  intent (skip a rubygems update that's already current, not just
#  blindly re-run it) needs more than a plain execute, everything else
#  a direct type-to-resource mapping.
module Scriptbox
  module Helpers
    require 'etc'

    SPECIAL_SCRIPTS = ['ubuntu22_gem_update'].freeze

    def scriptbox_install(pkg)
      return scriptbox_install_special(pkg) if pkg['type'] == 'script' && SPECIAL_SCRIPTS.include?(pkg['name'])

      case pkg['type']
      when 'apt'
        apt_package pkg['name']
      when 'gem'
        # Deliberately a plain execute, not Chef's own gem_package -
        #  confirmed directly via a real `vagrant provision` run that
        #  gem_package has no user/environment property at all (unlike
        #  execute/bash), so it installs into whatever ruby chef-client
        #  itself runs under (cinc's own embedded ruby, for this omnibus
        #  install) rather than the rbenv-managed one this package's own
        #  manifest entry declares needs:/tags: [rbenv] for - useless to
        #  the actual logged-in user, who only ever sees rbenv's own
        #  ruby. rbenv_gem_env below puts rbenv's shims first on PATH,
        #  the same thing the bash generator's own script relies on
        #  already having happened by this point in *its* script. pkg['args']
        #  (e.g. --platform ruby) is its own data bag key, not parsed back
        #  out of pkg['name'] - see scriptbox/scripts/generate_install_
        #  script.rb's own arg_suffix.
        env = rbenv_gem_env
        execute "gem install #{pkg['name']}" do
          command "gem install #{pkg['name']}#{pkg['args'] ? " #{pkg['args']}" : ''}"
          user node['scriptbox']['user']
          environment env
          not_if "gem list -i #{pkg['name']}", user: node['scriptbox']['user'], environment: env
        end
      when 'pipx'
        execute "pipx install #{pkg['name']}" do
          command "pipx install #{pkg['name']}#{pkg['args'] ? " #{pkg['args']}" : ''}"
          user node['scriptbox']['user']
          not_if "pipx list --short | grep -qw '^#{pkg['name']} '", user: node['scriptbox']['user']
        end
      when 'cmd'
        execute pkg['name'] do
          command pkg['cmd']
        end
      else
        Chef::Log.warn("scriptbox: unsupported package type '#{pkg['type']}' for '#{pkg['name']}'")
      end
    end

    # scriptbox_install_special(pkg) - see SPECIAL_SCRIPTS. The manifest's
    #  own ubuntu22_gem_update script (scriptbox/config/ubuntu2204.yml's
    #  scripts: block) does this same check via curl - this is that same
    #  logic in Ruby instead, not a shell one-liner, since a not_if block
    #  can express it more clearly with Gem::Version/JSON directly.
    def scriptbox_install_special(pkg)
      case pkg['name']
      when 'ubuntu22_gem_update'
        # Same rbenv-scoping reasoning as the 'gem' case above - this
        #  needs to update *rbenv's* rubygems, the one ratatui_ruby
        #  actually installs into, not root's own system gem (confirmed
        #  directly: without user/environment here, this updated nothing
        #  the 'gem' case above could ever see).
        env = rbenv_gem_env
        execute 'update_rubygems_system' do
          command 'gem update --system'
          user node['scriptbox']['user']
          environment env
          # Skips the run once rbenv's own current rubygems is already
          #  >= the latest upstream release. A not_if *block* runs
          #  in-process, in chef-client's own Ruby - Gem::VERSION there
          #  would be chef-client's own embedded ruby's rubygems
          #  version, not rbenv's (confirmed directly: it never matched
          #  what `gem --version` above the block actually sees) - so
          #  the current version has to come from a shell_out scoped to
          #  the same user/environment as the command itself, not read
          #  directly off this process's own Gem::VERSION constant.
          not_if do
            require 'json'
            require 'net/http'

            current = shell_out('gem --version', user: node['scriptbox']['user'], environment: env).stdout.strip
            current_version = Gem::Version.new(current)

            uri = URI('https://rubygems.org/api/v1/versions/rubygems-update/latest.json')
            response = Net::HTTP.get(uri)
            latest_version = Gem::Version.new(JSON.parse(response)['version'])

            current_version >= latest_version
          rescue StandardError
            # If the network call fails or times out, let the execute
            #  resource run anyway as a fallback.
            false
          end
          action :run
        end
      end
    end

    def rbenv_gem_env
      home = Etc.getpwnam(node['scriptbox']['user']).dir
      {
        'HOME' => home,
        'PATH' => "#{home}/.rbenv/shims:#{home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      }
    end
  end
end

Chef::Recipe.include(Scriptbox::Helpers)
