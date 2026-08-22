# asdf_user_install - installs the asdf binary itself, system-wide, from
#  the pinned GitHub Releases tarball - not per-user, and not a git
#  checkout (see this cookbook's own README for why the Supermarket
#  asdf-chef/asdf cookbook's own same-named resource can't be used
#  as-is). Mirrors scriptbox/config/ubuntu2204.yml's own ubuntu22_asdf
#  script exactly, so the two never drift into installing asdf two
#  different ways depending on which automation converged a given box.
#  `user` is still a real property (name_property) even though the
#  binary itself is installed once, system-wide - it's what asdf_
#  plugin/asdf_package (see their own resources) default their own
#  `user` to via node.run_state, and it's whose $HOME the per-user
#  ~/.asdf data directory (installs/plugins/shims) gets created under.

unified_mode true

property :version, String,
         default: 'v0.20.0'

property :user, String,
         name_property: true

action_class do
  include Asdf::Cookbook::Helpers

  def asdf_release_arch
    case node['kernel']['machine']
    when 'x86_64' then 'amd64'
    when 'aarch64' then 'arm64'
    else
      raise "asdf_user_install: unsupported architecture '#{node['kernel']['machine']}' - asdf only publishes linux amd64/arm64 release tarballs"
    end
  end
end

action :install do
  # Recorded for asdf_plugin/asdf_package's own `user` property to fall
  #  back to (see libraries/helpers.rb's own asdf_user) - set before
  #  anything below, so a single asdf_user_install followed by several
  #  asdf_plugin/asdf_package resources doesn't need `user` repeated on
  #  every one of them.
  node.run_state['asdf_user'] = new_resource.user

  tarball = "asdf-#{new_resource.version}-linux-#{asdf_release_arch}.tar.gz"
  cache_path = ::File.join(Chef::Config[:file_cache_path], tarball)

  remote_file cache_path do
    source "https://github.com/asdf-vm/asdf/releases/download/#{new_resource.version}/#{tarball}"
    mode '0644'
    action :create_if_missing
  end

  # tar -C straight into /usr/local/bin - the release tarball's own
  #  single member is already named `asdf`, no intermediate extraction
  #  directory to clean up the way a git checkout would need. Guarded
  #  on the binary already existing - re-running this on every converge
  #  would work fine (idempotent either way), but redownloading/
  #  re-extracting a binary that's already there is pure waste.
  execute "install asdf #{new_resource.version}" do
    command "tar -xzf #{cache_path} -C /usr/local/bin asdf"
    not_if { ::File.exist?('/usr/local/bin/asdf') }
  end

  file '/usr/local/bin/asdf' do
    mode '0755'
  end

  home = Etc.getpwnam(new_resource.user).dir
  data_dir = ::File.join(home, '.asdf')

  %w(installs plugins shims).each do |dir|
    directory ::File.join(data_dir, dir) do
      owner new_resource.user
      recursive true
    end
  end
end
