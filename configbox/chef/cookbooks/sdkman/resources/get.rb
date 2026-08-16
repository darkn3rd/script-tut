# Resource:: sdkman_get
#
# Bootstraps SDKMAN! itself for one user - the sdkman_install/
#  sdkman_default equivalent of pyenv's own pyenv_install or ruby_
#  rbenv's own rbenv_user_install. SDKMAN has no system-wide install
#  mode of its own (unlike pyenv's prefix_type: user/system choice) -
#  it always lands in $HOME/.sdkman for whichever user runs its
#  installer, so `user` here is required, not optional.

unified_mode true
provides :sdkman_get

action_class do
  include Sdkman::Helpers
end

property :user, String, required: true, name_property: true
property :auto_answer, [true, false], default: true,
  description: "Set sdkman_auto_answer=true in sdkman's own config, so later sdk install/default calls never block on an interactive prompt."

default_action :install

action :install do
  home = sdkman_home(new_resource.user)
  env = sdkman_env(new_resource.user)

  execute 'install sdkman' do
    command 'curl -s "https://get.sdkman.io" | bash'
    user new_resource.user
    environment env
    not_if { ::File.directory?("#{home}/.sdkman") }
  end

  next unless new_resource.auto_answer

  execute 'sdkman auto answer' do
    command "sed -i 's/sdkman_auto_answer=false/sdkman_auto_answer=true/' \"#{home}/.sdkman/etc/config\""
    user new_resource.user
    environment env
    not_if "grep -q sdkman_auto_answer=true \"#{home}/.sdkman/etc/config\"", user: new_resource.user, environment: env
  end
end
