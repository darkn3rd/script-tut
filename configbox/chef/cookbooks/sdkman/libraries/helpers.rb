# Sdkman::Helpers - shared by all three resources (get/install/default).
#  Unlike pyenv/ruby_rbenv, there's no node.run_state root_path bridge
#  here - SDKMAN always installs to exactly $HOME/.sdkman for whichever
#  user it's targeting, no configurable prefix the way pyenv's own
#  prefix_type: user/system is, so there's no variable state a later
#  resource could ever need to recover from an earlier one - a plain
#  Etc.getpwnam lookup is already the whole answer, every time.
module Sdkman
  module Helpers
    require 'etc'

    def sdkman_home(user)
      ::Etc.getpwnam(user).dir
    end

    def sdkman_env(user)
      { 'HOME' => sdkman_home(user) }
    end

    # sdkman_cmd(user, sdk_command) - `sdk_command` run through a fresh
    #  bash that sources sdkman-init.sh first. Every Chef execute is its
    #  own fresh, non-interactive shell - `sdk` is a shell function, not
    #  a real binary, so it only exists after this source line runs
    #  (confirmed directly via a real `vagrant provision` failure in the
    #  lessons cookbook's own earlier hand-rolled sdkman case - the same
    #  gap this cookbook exists to fix properly, once, in one place).
    def sdkman_cmd(user, sdk_command)
      home = sdkman_home(user)
      %(bash -c 'source "#{home}/.sdkman/bin/sdkman-init.sh" && #{sdk_command}')
    end
  end
end
