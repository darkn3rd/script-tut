## Windows Developer Power Shell

```powershell
choco install visualstudio2022buildtools `
  --package-parameters `
    "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --passive" -y

Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"

Enter-VsDevShell -VsInstallPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" -DevCmdArguments "-arch=x64 -host_arch=x64" -SkipAutomaticLocation
```
