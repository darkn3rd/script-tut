# Cookbook:: chocolatey
# Recipe:: default
#
# Bootstraps the Chocolatey package manager itself - a prerequisite for
#  Chef's own built-in chocolatey_package/chocolatey_feature/... resources,
#  none of which install Chocolatey on their own (confirmed directly via
#  a real Chef::Exceptions::MissingLibrary: "Could not locate your
#  Chocolatey install" failure). Deliberately a standalone cookbook, not
#  bundled inline into ../../lessons's own recipes/default.rb - any
#  future cookbook that needs Chocolatey present (not just lessons) can
#  `depends 'chocolatey'` + `include_recipe 'chocolatey'` the same way,
#  same reasoning as ../sdkman being its own cookbook rather than living
#  inside lessons.
#
# A community cookbook already exists for this
#  (chocolatey-community/chocolatey-cookbook, Supermarket's own
#  `chocolatey`) - not used here: its last real commit is from 2020, the
#  same "effectively abandoned" call already made about RiotGamesCookbooks/
#  rbenv-cookbook elsewhere in this project. This reimplements the same
#  handful of lines directly instead of taking on a stale dependency for
#  something this small.
#
# Body is the official Chocolatey install snippet verbatim (the same one
#  scriptbox/config/windows.yml's own global.windows_chocolatey script
#  uses for the bash/PowerShell generator pipeline) - two independent
#  copies, one per pipeline, not one generated from the other, the same
#  relationship Chef's own built-in apt_update resource already has with
#  ubuntu2204.yml's own `- cmd: sudo apt update` in global.packages.
return unless platform_family?('windows')

powershell_script 'install_chocolatey' do
  code <<~POWERSHELL
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = `
      [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    $WebClient = New-Object System.Net.WebClient
    $ScriptUrl = 'https://community.chocolatey.org/install.ps1'
    Invoke-Expression ($WebClient.DownloadString($ScriptUrl))
  POWERSHELL
  not_if { ::File.exist?("#{ENV['ChocolateyInstall'] || 'C:/ProgramData/chocolatey'}/bin/choco.exe") }
end
