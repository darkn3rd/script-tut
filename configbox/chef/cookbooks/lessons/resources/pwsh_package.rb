# Resource:: pwsh_package
#
# A cross-platform equivalent of Chef's own built-in powershell_package -
#  that resource looks like it would do this, but it's Windows-only in a
#  way its own name/description don't advertise: its provider never
#  shells out to pwsh at all, it calls Chef::Mixin::PowershellExec, which
#  hosts PowerShell in-process via .NET/COM interop (WIN32OLE) - and that
#  mixin's own source is unconditionally `include ... if ChefUtils.
#  windows?`, empty otherwise. Confirmed directly by reading both
#  chef/chef's lib/chef/resource/powershell_package.rb and lib/chef/
#  mixin/powershell_exec.rb - there's no non-Windows fallback to shell
#  out to a real pwsh binary. This resource is that fallback: a genuine
#  `pwsh -Command "Install-Module ..."` invocation, wrapped as a proper
#  idempotent Chef resource instead of a bare execute - real, not a
#  Windows-only impersonation of "real."

unified_mode true

# provides - without this, Chef's default DSL name for an unprefixed
#  resource file is <cookbook_name>_<filename> (lessons_pwsh_package
#  here), not the filename alone - confirmed directly via a real
#  `undefined method 'pwsh_package'` failure. ruby_rbenv's own
#  resources/ruby.rb does the exact same thing (`provides :rbenv_ruby`,
#  not ruby_rbenv_ruby) for the same reason.
provides :pwsh_package

property :package_name, String, name_property: true
property :version, String
property :scope, String, default: 'CurrentUser', equal_to: %w(CurrentUser AllUsers)
property :skip_publisher_check, [true, false], default: false
property :allow_clobber, [true, false], default: false
# user/environment - who `pwsh` actually runs as. No default here (chef-
#  client's own default is root) - the caller supplies these, same as
#  every other per-user install in this cookbook (see ../libraries/
#  helpers.rb's own 'script'/'sdkman' cases) - confirmed directly this
#  matters: without it, `-Scope CurrentUser` installs into *root's* own
#  PowerShell module path, invisible to whichever user actually runs
#  pwsh interactively afterward.
property :user, String
property :environment, Hash, default: {}

default_action :install

action :install do
  version_filter = new_resource.version ? " | Where-Object { $_.Version -eq '#{new_resource.version}' }" : ''
  guard = "pwsh -NoProfile -Command \"if (Get-Module -ListAvailable -Name #{new_resource.package_name}#{version_filter}) " \
          '{ exit 0 } else { exit 1 }"'

  install_cmd = ['Set-PSRepository -Name PSGallery -InstallationPolicy Trusted;']
  install_cmd << "Install-Module -Name #{new_resource.package_name}"
  install_cmd << "-RequiredVersion #{new_resource.version}" if new_resource.version
  install_cmd << "-Scope #{new_resource.scope} -Force"
  install_cmd << '-SkipPublisherCheck' if new_resource.skip_publisher_check
  install_cmd << '-AllowClobber' if new_resource.allow_clobber

  execute "pwsh_package[#{new_resource.package_name}] install" do
    command "pwsh -NoProfile -Command \"#{install_cmd.join(' ')}\""
    user new_resource.user if new_resource.user
    environment new_resource.environment unless new_resource.environment.empty?
    not_if guard, user: new_resource.user
  end
end
