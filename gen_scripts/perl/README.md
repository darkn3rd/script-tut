# Scripting Tutorial: Perl

Version 1.0

© Joaquin Menchaca, 2014-2026

## Getting Perl

### macOS: HomeBrew

**[Homebrew](https://brew.sh/)** is a command-line package manager for **macOS** that simplifies software installation by letting you download, update, and manage applications and tools using quick, automated commands.

```bash
# Install Homebrew on macOS
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"

# Install Perl
brew install perl
```

### Windows: Chocolatey

**[Chocolatey](https://chocolatey.org)** is a command-line package manager for Windows, built on top of the NuGet infrastructure, that lets you install, update, and manage software using simple, automated commands instead of clicking through setup wizards.

```powershell
# Install Chocolatey on Windows 11
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$WebClient = New-Object System.Net.WebClient
$ScriptUrl = 'https://community.chocolatey.org/install.ps1'
Invoke-Expression ($WebClient.DownloadString($ScriptUrl))

# Install Perl
choco install -y strawberryperl
```

### Windows: UCRT64 (MSYS2)

If you have **[Chocolatey](https://chocolatey.org)** setup, you can install MSYS2 with `choco install msys2`.  Othwerwise you can fetch **[MSYS](https://www.msys2.org/)** installer from their website.

Once you launch the shell, you can install perl using either UCRT64 environment or classic MINGW64 environment.

```bash
# UCRT64 Environment (Recommended)
pacman -S mingw-w64-ucrt-x86_64-perl
# MSYS2 Runtime
pacman -S msys2-runtime perl
```

Unfortunately the UCRT64 perl binary will be blocked in Windows 11 due to [Smart App Control](https://support.microsoft.com/en-US/Windows/Security/Threat-Malware-Protection/smart-app-control-has-blocked-part-of-this-app).  You can run through the steps below to unblock it. 


```Powershell
# 1. Initialize the developer signature profile
$cert = New-SelfSignedCertificate -Type CodeSigningCert -Subject "CN=MSYS2-LocalDev" -CertStoreLocation "Cert:\CurrentUser\My"
Move-Item -Path $cert.PSPath -Destination "Cert:\CurrentUser\Root"

# 2. Target the main binary
$TargetExe = "C:\tools\msys64\ucrt64\bin\perl.exe"
Set-AuthenticodeSignature -FilePath $TargetExe -Certificate $cert

# 3. Locate and sign all Perl internal engine dependencies (.dll files)
$PerlDlls = Get-ChildItem -Path "C:\tools\msys64\ucrt64\bin\" -Filter "*perl*.dll"
foreach ($dll in $PerlDlls) {
    Write-Host "Signing dependency: $($dll.FullName)"
    Set-AuthenticodeSignature -FilePath $dll.FullName -Certificate $cert
}

# 4. Global Verification Summary
Get-AuthenticodeSignature -FilePath $TargetExe
```

## Testing
* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 `perl v5.34.1 built for darwin-thread-multi-2level`
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * **Shell**: PowerShell 5.1.26100.8875
    * 📦 Strawberry Perl - `perl v5.42.0 built for MSWin32-x64-multi-thread`
  * **Shell**: Command Shell (C:\Windows\System32\cmd.exe)
    * 📦 Strawberry Perl - `perl v5.42.0 built for MSWin32-x64-multi-thread`
  * **Shell**: MSYS2 UCRT64 20260611.0.0 bash
    * 📦 UCRT64 Perl - `perl v5.42.2 built for MSWin32-x64-multi-thread`
