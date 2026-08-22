# asdf_package - `asdf install <name> <version>` (:install) and setting
#  that version as the user's own active/default one (:global). Unlike
#  asdf-chef/asdf's own same-named resource (see this cookbook's own
#  README), :global runs `asdf set -u <name> <version>` - the modern
#  replacement command - not `asdf global`, which asdf's own 0.16.0
#  rewrite removed outright. The action name itself stays `:global`
#  (not renamed to `:set`) since that's the *intent* a manifest author
#  is expressing either way ("make this the active version for this
#  user") - only the underlying CLI command changed.

unified_mode true

property :version, String

property :user, String

action_class do
  include Asdf::Cookbook::Helpers

  def resolved_version
    return new_resource.version if new_resource.version

    cmd = Mixlib::ShellOut.new(
      "asdf latest #{new_resource.name}",
      user: asdf_user,
      environment: { 'HOME' => asdf_user_home }
    )
    cmd.run_command
    cmd.error!
    cmd.stdout.strip
  end

  def version_installed?
    ::Dir.exist?(::File.join(asdf_data_dir, 'installs', new_resource.name, resolved_version))
  end
end

action :install do
  execute "asdf install #{new_resource.name} #{resolved_version}" do
    user asdf_user
    environment('HOME' => asdf_user_home)
    not_if { version_installed? }
  end
end

action :global do
  execute "asdf set -u #{new_resource.name} #{resolved_version}" do
    user asdf_user
    environment('HOME' => asdf_user_home)
    only_if { version_installed? }
  end
end
