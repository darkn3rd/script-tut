# Resource:: sdkman_default
#
# Sets one candidate's persistent default version - the pyenv_global/
#  rbenv_global equivalent, `sdk default <candidate> <version>` rather
#  than `sdk use` (which is session-only, not what a converge wants).

unified_mode true
provides :sdkman_default

action_class do
  include Sdkman::Helpers
end

property :candidate, String, required: true, name_property: true
property :version, String, required: true
property :user, String, required: true

default_action :create

action :create do
  home = sdkman_home(new_resource.user)
  env = sdkman_env(new_resource.user)
  current_path = "#{home}/.sdkman/candidates/#{new_resource.candidate}/current"

  execute "sdkman default #{new_resource.candidate} #{new_resource.version}" do
    command sdkman_cmd(new_resource.user, "sdk default #{new_resource.candidate} #{new_resource.version}")
    user new_resource.user
    environment env
    not_if "readlink -f \"#{current_path}\" | grep -qx \"#{home}/.sdkman/candidates/#{new_resource.candidate}/#{new_resource.version}\"",
           user: new_resource.user, environment: env
  end
end
