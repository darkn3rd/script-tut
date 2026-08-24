require 'etc'

# Asdf::Cookbook::Helpers - shared by every resource's own action_class
#  (see resources/*.rb) - same module name/shape as asdf-chef/asdf's own
#  libraries/helpers.rb (see this cookbook's own README on why this
#  isn't that cookbook), kept small on purpose: modern asdf needs none
#  of the profile-sourcing/PATH-exporting the original's own script_
#  code/script_environment did, since the `asdf` binary itself installs
#  straight to /usr/local/bin (already on any normal user's PATH) - see
#  user_install.rb's own :install action.
module Asdf
  module Cookbook
    module Helpers
      # asdf_user - every resource here takes a `user` property; falls
      #  back to whichever user asdf_user_install's own :install action
      #  last recorded (node.run_state), the same fallback chain asdf-
      #  chef/asdf's own helpers.rb already established, so a manifest
      #  author using asdf_plugin/asdf_package right after asdf_user_
      #  install doesn't have to repeat `user` on every single resource.
      def asdf_user
        new_resource.user || node.run_state['asdf_user']
      end

      def asdf_user_home
        Etc.getpwnam(asdf_user).dir
      end

      # asdf_data_dir - where asdf itself stores plugins/installs/shims
      #  for this user (ASDF_DATA_DIR, defaulting to ~/.asdf) - not
      #  where the `asdf` binary itself lives (that's /usr/local/bin,
      #  system-wide, installed once by asdf_user_install regardless of
      #  which user runs it).
      def asdf_data_dir
        ::File.join(asdf_user_home, '.asdf')
      end
    end
  end
end
