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
    require 'net/http'
    require 'json'
    require 'uri'

    # SPECIAL_SCRIPTS - script-name steps intercepted before the generic
    #  'script' case (bash pkg['cmd'] verbatim) - see
    #  lessons_install_special for what each one actually becomes.
    #  ubuntu22_go/ubuntu22_dotnet_10 used to be here too, back when
    #  their apt_repository was embedded inside a script's own cmd - the
    #  manifest now expresses that natively (see the generic 'apt' case
    #  below), so those two are gone from both the manifest's scripts:
    #  block and here.
    SPECIAL_SCRIPTS = %w[ubuntu22_powershell ubuntu22_rust ubuntu22_asdf].freeze

    # ppa_key_url(ppa) - given a 'ppa:owner/name' string, the HTTPS URL
    #  for that PPA's own signing key, resolved dynamically via
    #  Launchpad's own REST API - the same source add-apt-repository's
    #  own Python implementation (software-properties-common) queries to
    #  resolve a PPA's key. Deliberately NOT a hardcoded per-PPA
    #  fingerprint table in this cookbook - the manifest's own
    #  `apt_repository: ppa:owner/name` string is already everything
    #  add-apt-repository itself needs, so this keeps working for *any*
    #  PPA the manifest ever adds, not just the ones known about today,
    #  and never drifts if a PPA rotates its key. Chef's own
    #  apt_repository resource resolves a PPA's key itself when only
    #  `uri` is given - but only via `gpg --keyserver hkp://<host>:80
    #  --recv <fingerprint>` (keyserver defaults to keyserver.ubuntu.com -
    #  see its own key/keyserver property docs), which is exactly the
    #  path that fails outright - "No route to host", not a fallback -
    #  on a host with an IPv6 address configured but not actually routed
    #  anywhere (confirmed directly via a real `vagrant provision`
    #  failure; this is a known upstream gap, not anything specific to
    #  this cookbook - see https://github.com/chef/chef/issues/16281).
    #  Returning a URL instead - and never setting `keyserver` - takes
    #  the resource's *other* code path instead: a plain HTTPS GET, no
    #  gpg keyserver protocol involved at all.
    def ppa_key_url(ppa)
      owner, name = ppa.delete_prefix('ppa:').split('/', 2)
      lp_uri = URI("https://launchpad.net/api/1.0/~#{owner}/+archive/ubuntu/#{name}")
      response = Net::HTTP.get_response(lp_uri)
      raise "lessons: could not resolve signing key for #{ppa} from Launchpad (HTTP #{response.code})" unless response.is_a?(Net::HTTPSuccess)

      fingerprint = JSON.parse(response.body)['signing_key_fingerprint']
      raise "lessons: Launchpad returned no signing_key_fingerprint for #{ppa}" unless fingerprint

      "https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search=0x#{fingerprint}"
    end

    def lessons_install(pkg)
      return lessons_install_special(pkg) if pkg['type'] == 'script' && SPECIAL_SCRIPTS.include?(pkg['name'])

      case pkg['type']
      when 'apt'
        # pkg['apt_repository'] - a PPA the manifest declared alongside
        #  this package (e.g. ppa:dotnet/backports for dotnet-sdk-10.0) -
        #  added first via Chef's own apt_repository resource instead of
        #  a shell `add-apt-repository` call. The PPA string itself would
        #  be a fine, unique Chef resource name, but apt_repository's own
        #  repo_name property rejects a literal '/' (confirmed via a real
        #  `vagrant provision` run) - sanitized down to just
        #  alphanumerics/-/_/. , still unique, still readable. key -
        #  see ppa_key_url's own comment for why this is a resolved URL,
        #  not left for apt_repository's own default keyserver fetch.
        #  Resolved *before* the resource block, not inside it - a
        #  resource's own do...end block runs in the resource's own
        #  context, not this method's (confirmed directly via a real
        #  NoMethodError: undefined method 'ppa_key_url' for
        #  Chef::Resource::AptRepository) - a local variable, unlike a
        #  method call, is still visible via the block's own closure.
        if pkg['apt_repository']
          key_url = ppa_key_url(pkg['apt_repository'])
          apt_repository pkg['apt_repository'].gsub(/[^A-Za-z0-9_.-]/, '-') do
            uri pkg['apt_repository']
            key key_url
            action :add
          end
        elsif pkg['add_apt_repo']
          # pkg['add_apt_repo'] - the manifest's own add_apt_repos: entry
          #  (see generate_chef_databag.rb's step_to_entry), the other,
          #  non-PPA way to add a repo: a raw signed-by key + list file
          #  (Corretto, Docker, ...). Chef's own apt_repository resource
          #  already handles this natively - key accepts a URL and
          #  downloads/dearmors it into the trusted keyring itself, no
          #  need to compose remote_file/execute/file by hand the way
          #  the bash generator's own add_apt_repo() shell function does.
          #  distro_string ("stable main") is one space-joined string in
          #  the manifest (matches how the shell function concatenates it
          #  straight into `deb [...] $DISTRO_STRING`) - split here since
          #  Chef wants distribution/components as separate properties.
          repo = pkg['add_apt_repo']
          distribution, *components = repo['distro_string'].to_s.split(' ')
          apt_repository repo['name'].gsub(/[^A-Za-z0-9_.-]/, '-') do
            uri repo['repo_uri']
            key repo['key_url']
            distribution distribution
            components components
            action :add
          end
        end
        apt_package pkg['name']
      when 'file'
        # A manifest files: entry (e.g. ubuntu_default_zshrc) - real
        #  Chef file resource instead of a bash heredoc pretending to be
        #  one. '$HOME' - the only shell expansion the manifest's own
        #  dest ever used - resolved the same way rustup's own user/home
        #  lookup is below. Unlike a shell `cat > dest`, Chef's own file
        #  resource never creates a missing parent directory itself
        #  (confirmed directly via a real EnclosingDirectoryDoesNotExist
        #  failure) - a manifest's own script step happening to `mkdir
        #  -p` that directory first isn't something this can rely on
        #  (e.g. that mkdir only runs on rustup's own *first* install,
        #  never again once $HOME/.cargo already exists), so this
        #  ensures it exists itself instead.
        real_dest = pkg['dest'].sub('$HOME', Etc.getpwnam(node['lessons']['user']).dir)
        directory ::File.dirname(real_dest) do
          owner node['lessons']['user']
          recursive true
        end
        file real_dest do
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
        #  construction, no manual guard needed. Same missing-parent-
        #  directory gap as 'file' above - append_if_no_line creates the
        #  destination file itself if missing, which needs the directory
        #  to already exist.
        home = Etc.getpwnam(node['lessons']['user']).dir
        Array(pkg['dest']).each do |dest|
          real_dest = dest.sub('$HOME', home)
          directory ::File.dirname(real_dest) do
            owner node['lessons']['user']
            recursive true
          end
          Array(pkg['lines']).each do |ln|
            append_if_no_line "#{pkg['name']}: #{ln} -> #{real_dest}" do
              path real_dest
              line ln
            end
          end
        end
      when 'choco'
        # windows.yml's own package manager - no user/environment
        #  scoping needed the way the Linux per-user installs below
        #  require: chocolatey installs system-wide, and chef-client
        #  itself already runs elevated on a Windows Vagrant guest (same
        #  WinRM session the shell-provisioner pipeline's own
        #  `elevated: true` scripts already rely on). timeout raised
        #  well past chocolatey_package's own 900s default - confirmed
        #  directly via a real Mixlib::ShellOut::CommandTimeout on
        #  powershell-core: the package had genuinely finished
        #  installing (100% downloaded, "package files install
        #  completed" in the captured output), but the underlying
        #  choco.exe process itself took longer than 900s to actually
        #  exit on this VM - an MSI/Chocolatey process-handle quirk on
        #  slower/virtualized hosts, not anything wrong with the install.
        chocolatey_package pkg['name'] do
          timeout 1800
        end
      when 'choco_cyg'
        # windows.yml's own choco_cyg type (see resolve_order.rb's
        #  PACKAGE_TYPES) - installs a *Cygwin* package via the cyg-get
        #  shim (itself a `choco: cyg-get` package elsewhere in the same
        #  data bag), not a Windows one - genuinely a different install
        #  path than plain `choco:`, same reasoning generate_install_
        #  script.rb's own powershell_install gives it a separate type
        #  rather than folding into 'choco'. No idempotency guard here,
        #  same as that bash/PowerShell equivalent - relies on cyg-get/
        #  apt-cyg's own idempotency rather than duplicating it.
        execute "choco_cyg-#{pkg['name']}" do
          command "cyg-get #{pkg['name']}"
        end
      when 'choco_local'
        # pkgbox/chocolatey/<name>/ - a local nuspec source for a package
        #  missing from the community Chocolatey feed (see pkgbox's own
        #  README). Path derived from type+name, same reasoning apt_
        #  repository/add_apt_repo get their own key rather than being
        #  packed into name:. version: is always an exact pin here -
        #  choco install --version has no floor semantics, so '>=' isn't
        #  accepted (matches scriptbox/scripts/generate_install_script
        #  .rb's own choco_local case, and the data bag itself was
        #  already validated at generation time - see resolve_order.rb's
        #  own parse_version_constraint - so only the '>=' shape needs
        #  rejecting here, not the full operator vocabulary again).
        if pkg['version']&.start_with?('>=')
          raise "choco_local '#{pkg['name']}': version must be an exact pin ('=' or a bare version) - choco install --version has no floor semantics"
        end

        pkg_dir = "pkgbox/chocolatey/#{pkg['name']}"
        version = pkg['version']&.sub(/\A=\s*/, '')
        version_flag = version ? %( --version="#{version}") : ''
        powershell_script "choco_local-#{pkg['name']}" do
          code <<~PS1
            choco pack "#{pkg_dir}/#{pkg['name']}.nuspec" --output-directory="#{pkg_dir}/vendor"
            choco install #{pkg['name']} --source="#{pkg_dir}/vendor"#{version_flag} --yes
          PS1
        end
      when 'powershell_package_provider'
        version = pkg['version']&.sub(/\A(>=|=)\s*/, '')
        version_flag = version ? " -MinimumVersion #{version}" : ''
        run_powershell("Install-PackageProvider -Name #{pkg['name']}#{version_flag} -Force", "powershell_package_provider-#{pkg['name']}")
      when 'powershell_module'
        args_suffix = pkg['args'] ? " #{pkg['args']}" : ''
        run_powershell("Install-Module -Name #{pkg['name']}#{args_suffix} -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber", "powershell_module-#{pkg['name']}")
      when 'powershell_cmd'
        # One raw PowerShell command/expression - see generate_install_
        #  script.rb's own powershell_cmd case for what this is an
        #  escape hatch for (whatever powershell_package_provider/
        #  powershell_module above don't cover - e.g. Set-PSRepository's
        #  own repository-trust call). run_powershell already gives it
        #  the identical native-vs-pwsh dispatch those two get.
        run_powershell(pkg['name'], "powershell_cmd-#{pkg['name']}")
      when 'script'
        # Every one of these scripts (rbenv/pyenv installers, cpan's
        #  local::lib setup, sdkman's own bootstrap) installs into
        #  "$HOME" expecting the *lessons user's* home, not chef-client's
        #  own (chef-client runs as root by default, whose $HOME is
        #  /root) - user/environment here make that true, the same
        #  correction rustup's own install_rustup resource already makes
        #  below. Windows has no such gap to correct for (chef-client
        #  itself already runs elevated, same as the 'choco' case above),
        #  and no bash - powershell_script is the dialect this data bag's
        #  own scripts: block is actually written in for windows.yml
        #  (see generate_chef_databag.rb's step_to_entry, which pulls
        #  pkg['cmd'] straight from the manifest's own scripts: body
        #  verbatim, whatever dialect that platform's manifest uses).
        if platform_family?('windows')
          powershell_script pkg['name'] do
            code pkg['cmd']
          end
        else
          bash pkg['name'] do
            code pkg['cmd']
            user node['lessons']['user']
            environment('HOME' => Etc.getpwnam(node['lessons']['user']).dir)
          end
        end
      when 'sdkman'
        # sdkman's own bootstrap script (see the 'script' case above)
        #  sources sdkman-init.sh into .bashrc/.zshrc for a real login
        #  shell - useless here, since each Chef bash resource is its
        #  own fresh non-interactive shell that never reads those files.
        #  Sourcing it directly is the same fix ubuntu22_pyenv/ubuntu22_
        #  rbenv's own generated bash already needs for the same reason
        #  (see those scripts' own "Direct, not `source ~/.bashrc`"
        #  comment) - `sdk` is a shell function, not a binary, so it
        #  only exists after this source line runs.
        home = Etc.getpwnam(node['lessons']['user']).dir
        bash "sdkman-#{pkg['name']}" do
          code <<~BASH
            source "#{home}/.sdkman/bin/sdkman-init.sh"
            sdk install #{pkg['name']}
          BASH
          user node['lessons']['user']
          environment('HOME' => home)
        end
      when 'cpan', 'cpanm'
        # perl cookbook's own cpan_module resource installs via cpanm
        #  under the hood regardless of which of our two types this
        #  came from - one resource covers both.
        cpan_module pkg['name']
      when 'pyenv'
        # pyenv_python's own root_path helper reads node.run_state
        #  (sous-chefs/pyenv/root_path/prefix), normally only ever set
        #  by the pyenv cookbook's own pyenv_install bootstrap resource -
        #  which we never call, since our own ubuntu22_pyenv script (see
        #  the 'script' case above) already installs pyenv into $HOME/
        #  .pyenv the manifest's own way. Without this, pyenv_python
        #  blows up with a bare NoMethodError on a nil root_path -
        #  confirmed directly via a real `vagrant provision` run. Pre-
        #  seeding this run_state key by hand points the resource at
        #  where pyenv actually landed, without a second, redundant
        #  install.
        home = Etc.getpwnam(node['lessons']['user']).dir
        node.run_state['sous-chefs'] ||= {}
        node.run_state['sous-chefs']['pyenv'] ||= {}
        node.run_state['sous-chefs']['pyenv']['root_path'] ||= {}
        node.run_state['sous-chefs']['pyenv']['root_path']['prefix'] ||= "#{home}/.pyenv"

        pyenv_python pkg['name'] do
          user node['lessons']['user']
        end
        # pkg['cmd'] is our own manifest's follow-up "pyenv global ..."
        #  line (see generate_chef_databag.rb's step_to_entry) - reused
        #  here rather than re-deriving the version list, since pyenv's
        #  own multi-version fallback list (e.g. python2's own "3.14.7
        #  2.7.18") is exactly what's already in that string.
        if pkg['cmd'] =~ /pyenv global (.+)/
          pyenv_global Regexp.last_match(1) do
            user node['lessons']['user']
          end
        end
      when 'rbenv'
        # Same gap, same fix as 'pyenv' above - rbenv_ruby's own root_
        #  path is keyed per-user (see ruby_rbenv's own Chef::Rbenv::
        #  Helpers.root_path), normally set by rbenv_user_install, which
        #  we likewise never call in favor of our own ubuntu22_rbenv
        #  script.
        home = Etc.getpwnam(node['lessons']['user']).dir
        node.run_state['sous-chefs'] ||= {}
        node.run_state['sous-chefs']['ruby_rbenv'] ||= {}
        node.run_state['sous-chefs']['ruby_rbenv']['root_path'] ||= {}
        node.run_state['sous-chefs']['ruby_rbenv']['root_path'][node['lessons']['user']] ||= "#{home}/.rbenv"

        rbenv_ruby pkg['name'] do
          user node['lessons']['user']
        end
        if pkg['cmd'] =~ /rbenv global (.+)/
          rbenv_global Regexp.last_match(1) do
            user node['lessons']['user']
          end
        end
      when 'asdf_plugin'
        # "<name> <repo_url>" (e.g. "ruby https://github.com/asdf-vm/
        #  asdf-ruby.git") - the local ../asdf cookbook's own asdf_
        #  plugin resource (see its resources/plugin.rb), not raw shell -
        #  see ../asdf/README.md for why Supermarket's own asdf-chef/
        #  asdf can't be depended on as-is (its own same-named resource
        #  silently ignores the git url entirely).
        plugin, repo = pkg['name'].split(' ', 2)
        asdf_plugin plugin do
          git_url repo
          user node['lessons']['user']
        end
      when 'asdf'
        # "<language> <version>" (e.g. "ruby 4.0.6") - the local ../asdf
        #  cookbook's own asdf_package resource. [:install, :global]
        #  mirrors that resource's own documented usage (install this
        #  version, then make it the active one) - pkg['cmd'] (the
        #  manifest's own "asdf set -u ..." follow-up, used verbatim by
        #  the bash generator) isn't needed here at all; the resource's
        #  own :global action already does the equivalent, natively
        #  (via `asdf set -u`, not the removed `asdf global` - see
        #  ../asdf/resources/package.rb's own comment).
        language, version = pkg['name'].split(' ', 2)
        asdf_package language do
          version version
          action [:install, :global]
          user node['lessons']['user']
        end
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
        # ../resources/pwsh_package.rb - psake needs installing for the
        #  *lessons user*, not chef-client's own root (confirmed directly
        #  via a real `vagrant provision` run: without user/environment
        #  here, -Scope CurrentUser installed psake under /root's own
        #  PowerShell module path, invisible to verify_commands.rb
        #  running as the vagrant user - the same class of bug the
        #  'script'/'sdkman' cases above already had to correct for).
        pwsh_package 'psake' do
          skip_publisher_check true
          allow_clobber true
          user node['lessons']['user']
          environment('HOME' => Etc.getpwnam(node['lessons']['user']).dir)
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
      when 'ubuntu22_asdf'
        # Our own script downloads a specific GitHub Release tarball and
        #  installs the binary to /usr/local/bin - asdf_user_install
        #  (../asdf cookbook, a local fork - see its own README) is the
        #  faithful native equivalent, not a bash resource replaying
        #  pkg['cmd'] verbatim. The version is still pulled out of that
        #  same pkg['cmd'] (ASDF_VERSION="...", already <%= $asdf_ver %>-
        #  substituted by generate_chef_databag.rb) rather than
        #  hardcoded here a second time - same reasoning the 'pyenv'/
        #  'rbenv' cases above already apply to their own follow-up
        #  pkg['cmd'] - so the manifest's own variables: block stays the
        #  one and only place this version is ever written down.
        asdf_version = pkg['cmd'][/ASDF_VERSION="([^"]+)"/, 1]
        asdf_user_install node['lessons']['user'] do
          version asdf_version if asdf_version
        end
      end
    end

    # run_powershell(cmd, resource_name) - cmd run natively on Windows
    #  (chef-client already runs elevated there, same as the 'choco' case
    #  above) or through `pwsh -Command "..."` for the *lessons user* on
    #  every other platform - same platform_family? branch the 'script'
    #  case above already needs, for the same underlying reason (no
    #  PowerShell interpreter running chef-client itself to invoke this
    #  directly).
    def run_powershell(cmd, resource_name)
      if platform_family?('windows')
        powershell_script resource_name do
          code cmd
        end
      else
        home = Etc.getpwnam(node['lessons']['user']).dir
        execute resource_name do
          command %(pwsh -NoProfile -Command "#{cmd}")
          user node['lessons']['user']
          environment('HOME' => home)
        end
      end
    end
  end
end

Chef::Recipe.include(Lessons::Helpers)
