# Lessons::Helpers#lessons_install - one step from a data bag area array
#  (see scriptbox/scripts/generate_chef_databag.rb's own step_to_entry)
#  dispatched to the matching Chef resource. Mirrors generate_install_
#  script.rb's own bash_install/command_for dispatch, type for type -
#  except pyenv/rbenv/cpan/cpanm, which dispatch to the real sous-chefs
#  pyenv/ruby_rbenv/perl cookbook resources (see ../metadata.rb's own
#  depends) instead of a raw shell command, and the two script steps
#  in SPECIAL_SCRIPTS, each of which has a real native-resource
#  equivalent for its actual first action (install a local .deb, or -
#  rustup - a per-user installer script with no cookbook of its own
#  worth using - see lessons_install_special).
module Lessons
  module Helpers
    require 'etc'

    # SPECIAL_SCRIPTS - script-name steps intercepted before the generic
    #  'script' case (bash pkg['cmd'] verbatim) - see
    #  lessons_install_special for what each one actually becomes.
    #  ubuntu22_go/ubuntu22_dotnet_10 used to be here too, back when
    #  their apt_repository was embedded inside a script's own cmd - the
    #  manifest now expresses that natively (see the generic 'apt' case
    #  below), so those two are gone from both the manifest's scripts:
    #  block and here.
    SPECIAL_SCRIPTS = %w[ubuntu22_powershell ubuntu22_rust].freeze

    def lessons_install(pkg)
      return lessons_install_special(pkg) if pkg['type'] == 'script' && SPECIAL_SCRIPTS.include?(pkg['name'])

      case pkg['type']
      when 'apt'
        # pkg['apt_repository'] - a PPA the manifest declared alongside
        #  this package (e.g. ppa:dotnet/backports for dotnet-sdk-10.0) -
        #  added first via Chef's own apt_repository resource instead of
        #  a shell `add-apt-repository` call. The PPA string itself is a
        #  fine, unique Chef resource name - no separate human label
        #  needed just to satisfy the resource's own name parameter.
        if pkg['apt_repository']
          apt_repository pkg['apt_repository'] do
            uri pkg['apt_repository']
            action :add
          end
        end
        apt_package pkg['name']
      when 'file'
        # A manifest files: entry (e.g. ubuntu_default_zshrc) - real
        #  Chef file resource instead of a bash heredoc pretending to be
        #  one. '$HOME' - the only shell expansion the manifest's own
        #  dest ever used - resolved the same way rustup's own user/home
        #  lookup is below.
        file pkg['dest'].sub('$HOME', Etc.getpwnam(node['lessons']['user']).dir) do
          content pkg['content']
          owner node['lessons']['user']
          action :create
        end
      when 'append'
        # A manifest appends: entry (e.g. ubuntu22_go's own GOPATH
        #  exports) - the sous-chefs `line` cookbook's own
        #  append_if_no_line resource is the native equivalent of the
        #  bash generator's own grep-guarded `>> dest` (see
        #  generate_install_script.rb's append_lines) - idempotent by
        #  construction, no manual guard needed.
        home = Etc.getpwnam(node['lessons']['user']).dir
        Array(pkg['dest']).each do |dest|
          real_dest = dest.sub('$HOME', home)
          Array(pkg['lines']).each do |ln|
            append_if_no_line "#{pkg['name']}: #{ln} -> #{real_dest}" do
              path real_dest
              line ln
            end
          end
        end
      when 'script'
        bash pkg['name'] do
          code pkg['cmd']
        end
      when 'sdkman'
        bash "sdkman-#{pkg['name']}" do
          code "sdk install #{pkg['name']}"
        end
      when 'cpan', 'cpanm'
        # perl cookbook's own cpan_module resource installs via cpanm
        #  under the hood regardless of which of our two types this
        #  came from - one resource covers both.
        cpan_module pkg['name']
      when 'pyenv'
        pyenv_python pkg['name']
        # pkg['cmd'] is our own manifest's follow-up "pyenv global ..."
        #  line (see generate_chef_databag.rb's step_to_entry) - reused
        #  here rather than re-deriving the version list, since pyenv's
        #  own multi-version fallback list (e.g. python2's own "3.14.7
        #  2.7.18") is exactly what's already in that string.
        pyenv_global Regexp.last_match(1) if pkg['cmd'] =~ /pyenv global (.+)/
      when 'rbenv'
        rbenv_ruby pkg['name']
        rbenv_global Regexp.last_match(1) if pkg['cmd'] =~ /rbenv global (.+)/
      else
        Chef::Log.warn("lessons: unsupported package type '#{pkg['type']}' for '#{pkg['name']}'")
      end
    end

    # lessons_install_special(pkg) - see SPECIAL_SCRIPTS. The rest of
    #  each script (PSake module install) has no native Chef resource
    #  equivalent and stays as a plain follow-up resource where it's
    #  still needed.
    def lessons_install_special(pkg)
      case pkg['name']
      when 'ubuntu22_powershell'
        # Our own script downloads and installs a vendor .deb that
        #  configures apt itself (packages-microsoft-prod.deb), not a
        #  plain `add-apt-repository ppa:...` the way the manifest's own
        #  apt_repository field handles a PPA - remote_file + dpkg_
        #  package is the faithful native equivalent here, not
        #  apt_repository (which has no way to represent "install this
        #  specific local .deb").
        deb_cache_path = "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.deb"

        remote_file deb_cache_path do
          source "https://packages.microsoft.com/config/ubuntu/#{node['platform_version']}/packages-microsoft-prod.deb"
          mode '0644'
          action :create
        end

        dpkg_package 'packages-microsoft-prod' do
          source deb_cache_path
          action :install
          # The 'update' apt_update resource already ran once, up front,
          #  in recipes/default.rb - re-triggered here so apt's cache
          #  reflects the repo this .deb just configured before the
          #  apt_package below tries to install from it.
          notifies :update, 'apt_update[update]', :immediately
        end

        apt_package 'powershell'
        execute 'trust-psgallery-and-install-psake' do
          command 'pwsh -NoProfile -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; ' \
                  'Install-Module -Name psake -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber"'
        end
      when 'ubuntu22_rust'
        # No viable community cookbook (confirmed directly - the only
        #  rustlang cookbook on Supermarket is abandoned since 2015,
        #  defaults to a pre-1.0 alpha release, and installs a totally
        #  different way than modern Rust does). rustup's own installer
        #  script is what our manifest already uses; the only thing
        #  missing from just shelling it out was Chef's own idempotency
        #  primitive (not_if) in place of the manifest's bash-level
        #  `if [ ! -d ... ]` guard. Etc.getpwnam - not a hardcoded
        #  /home/#{user} - resolves the user's real home directory,
        #  same as the manifest's own $HOME would at run time.
        rust_user = node['lessons']['user']
        rust_home = Etc.getpwnam(rust_user).dir

        execute 'install_rustup' do
          command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | " \
                  'sh -s -- -y --profile minimal --no-modify-path'
          user rust_user
          environment('HOME' => rust_home)
          not_if { ::File.exist?("#{rust_home}/.cargo/bin/cargo") }
        end
      end
    end
  end
end

Chef::Recipe.include(Lessons::Helpers)
