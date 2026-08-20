# Resource:: sdkman_install
#
# Installs one candidate (e.g. groovy, java, kotlin) via SDKMAN - the
#  pyenv_python/rbenv_ruby equivalent. Assumes sdkman_get has already
#  bootstrapped SDKMAN itself for this same user - this resource
#  doesn't call it automatically (same division of responsibility
#  pyenv_python/rbenv_ruby themselves leave to pyenv_install/rbenv_
#  user_install, not something this resource re-derives).

unified_mode true
provides :sdkman_install

action_class do
  include Sdkman::Helpers
end

property :candidate, String, required: true, name_property: true
property :version, String,
  description: 'A specific candidate version (e.g. "17.0.19-tem"). Omit to let sdk install pick its own default/latest.'
property :user, String, required: true

default_action :install

action :install do
  home = sdkman_home(new_resource.user)
  env = sdkman_env(new_resource.user)
  version_arg = new_resource.version ? " #{new_resource.version}" : ''

  # A pinned version can be checked for directly on disk; an unpinned
  #  "whatever sdk install picks" has no version to check ahead of time,
  #  so the closest available idempotency signal is "is *some* version
  #  of this candidate already current" - sdk install itself already
  #  no-ops quickly when the requested version is already current, so
  #  this guard is a coarser but still real time-saver, not the only
  #  thing standing between this and a full reinstall every converge.
  guard = if new_resource.version
            "test -d \"#{home}/.sdkman/candidates/#{new_resource.candidate}/#{new_resource.version}\""
          else
            sdkman_cmd(new_resource.user, "sdk current #{new_resource.candidate}") + ' >/dev/null 2>&1'
          end

  execute "sdkman install #{new_resource.candidate}#{version_arg}" do
    command sdkman_cmd(new_resource.user, "sdk install #{new_resource.candidate}#{version_arg}")
    user new_resource.user
    environment env
    not_if guard, user: new_resource.user, environment: env
  end
end
