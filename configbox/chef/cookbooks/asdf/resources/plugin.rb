# asdf_plugin - `asdf plugin add <name> [git_url]`, idempotent (skipped
#  once the plugin directory already exists - `asdf plugin add` itself
#  errors out on an already-registered plugin, the same reasoning the
#  bash generator's own asdf_plugin case guards on `asdf plugin list`
#  first). Unlike asdf-chef/asdf's own same-named resource (see this
#  cookbook's own README), `git_url` is actually passed through to the
#  command when given, rather than silently falling back to asdf's own
#  default plugin registry regardless of what the manifest asked for -
#  confirmed directly this matters: that registry's own default `python`
#  entry is a *different* plugin (danhper/asdf-python.git) than the one
#  scriptbox/config/ubuntu2204.yml pins (asdf-community/asdf-python.git).

unified_mode true

property :git_url, String

property :user, String

action_class do
  include Asdf::Cookbook::Helpers

  def plugin_installed?
    ::Dir.exist?(::File.join(asdf_data_dir, 'plugins', new_resource.name))
  end
end

action :add do
  command = ["asdf plugin add #{new_resource.name}", new_resource.git_url].compact.join(' ')

  execute "asdf plugin add #{new_resource.name}" do
    command command
    user asdf_user
    environment('HOME' => asdf_user_home)
    not_if { plugin_installed? }
  end
end
