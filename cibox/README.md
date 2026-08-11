# Continuous Integration (CI)

This area covers Continious Integration scripts in general.

Currently GHA (GitHub Actions) is used to run tests. GHA will use a matrix, a list of langauges, to use the test harness (`rake` and `Script.rb`) to run the tests for a given language.  

The GHA script is configured in `script-tut/.github/workflows/ci.yml`.

## Setup for Act

You can use [Act](https://github.com/nektos/act) to run tests locally on Windows, macOS, or Linux.  For non-linux systems, they will need a Linux VM to run a container runtime, and they will need docker client tools. 

### Windows 11: Elevated Privileges with gsudo

In order to run elevated privileges without ambiguity in the instructions, install gsudo.  Any command that requires elevated privileges will be prepended by gsudo. Use **[Chocolatey](https://chocolatey.org/)** or **[Winget](https://learn.microsoft.com/windows/package-manager/)** in a terminal with elevated privileges. 

* Install with **[Chocolatey](https://chocolatey.org/)**
  ```powershell
  choco install -y gsudo
  ```
* Install using **[Winget](https://learn.microsoft.com/windows/package-manager/)**
  ```powershell
  winget install geardog.gsudo
  ```

After you can enable caching, so you don't have to elevate privileges for every command.  Not this is considered a security risk. 

```powershell
# set cache on in current session
gsudo cache on               
# configure cache to always be turned on
gsudo config CacheMode Auto
```

### Windows 11 Home Prerequisites

For Act, you need to have a Linux VM to run a container runtime.  You can get this with WSL2 on Windows Home.  Windows Professional can use Hyper-V.

#### Enable WSL2 Features

For Windows 11 Home, you need to install a WSL2 environment, which is a light-weight virtual machine running Linux.  You can run the following below in either Command Shell or PowerShell.  This will require a reboot to take effect. 

In command shell (cmd.exe), you can run this:

```dos
REM ---------------------------
REM Enable WSL features
REM ---------------------------
gsudo dism.exe /online ^
  /enable-feature ^
  /featurename:"Microsoft-Windows-Subsystem-Linux" ^
  /all ^
  /norestart

gsudo dism.exe /online ^
  /enable-feature ^
  /featurename:"VirtualMachinePlatform" ^
  /all ^
  /norestart

REM ---------------------------
REM Verify WSL features enabled
REM ---------------------------
gsudo dism ^
  /online ^
  /get-featureinfo ^
  /featurename:"Microsoft-Windows-Subsystem-Linux" |^
findstr /B /C:"Feature Name" /C:"Description" /C:"State"

gsudo dism ^
  /online ^
  /get-featureinfo ^
  /featurename:"VirtualMachinePlatform" |^
findstr /B /C:"Feature Name" /C:"Description" /C:"State"
```

In PowerShell, you can run this:

```pwsh
##############################
# Enable WSL features
##############################
$features = @(
  'Microsoft-Windows-Subsystem-Linux',
  'VirtualMachinePlatform'
)

foreach ($feature in $features) {
  gsudo Enable-WindowsOptionalFeature `
    -Online `
    -FeatureName $feature `
    -All `
    -NoRestart
}

##############################
# Verify WSL features enable
##############################
gsudo {
  $features = "Microsoft-Windows-Subsystem-Linux", "VirtualMachinePlatform"
  $features | ForEach-Object { Get-WindowsOptionalFeature -Online -FeatureName $_ } |
    Select-Object FeatureName, State, Description |
    Format-Table -AutoSize
}
```

#### Install WSL Ubuntu Linux

You can install the default distribution with the following:

```powershell
gsudo wsl --install
```

#### Install a Container Service

Install a container service:

* [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
  ```pwsh
  gsudo choco install -y docker-desktop
  ```
* [Podman Desktop](https://podman-desktop.io/)
  ```pwsh
  gsudo choco install -y podman-desktop
  ```
* [Rancher Desktop](https://rancherdesktop.io/)
  ```pwsh
  gsudo choco install -y rancher-desktop
  ```

### macOS Prerequisites

#### Install Docker Compatible Daemon

Act needs a Docker-compatible daemon to execute workflow steps.

* **[Colima](https://colima.run/)**
  ```bash
  # Install docker client and lightweight VM
  brew install colima docker
  # Start VM
  colima start
  ```
* **[Docker Desktop for Mac](https://docs.docker.com/desktop/setup/install/mac-install/)**
  ```bash
  # Install Docker Desktop (uses HyperKit for VM)
  brew install --cask docker
  ```
* [Podman Desktop](https://podman-desktop.io/)
  ```bash
  # Install Podman Desktop
  brew install --cask podman-desktop
  ```
* [Rancher Desktop](https://rancherdesktop.io/)
  ```bash
  # Install Rancher Desktop
  brew install --cask rancher
  ```

## Getting Act

### Windows 11 Home

* Install using Chocolatey
  ```powershell
  choco install act-cli
  ```
* Install using WinGet
  ```powershell
  winget install nektos.act
  ```

### macOS: Homebrew

```bash
brew install act
```

## Running it locally

You can run act locally with the follwoing commands:

```bash
docker pull catthehacker/ubuntu:act-latest
act -W .github/workflows/ci.yml --pull=false
```

> **NOTE**: Act will do a force pull for every test in the matrix, which not only wasteful for small code tests, but can run into rate limiting from Docker Hub. 

## Further Reading 

* GitHub Actions
  * [Act](https://nektosact.com/) ([repo](https://github.com/nektos/act)) - Run GitHub Actions locally 🚀
  * [GitHub Actions Documentation](https://docs.github.com/en/actions)
* WSL
  * [How to install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Docs)
* Package Managers
  * [Mise](https://mise.en.dev/) ([repo](https://github.com/jdx/mise))
  * [Nix](https://nixos.org/) ([repo](https://github.com/NixOS/nix))
* Container Runtimes
  * [Colima](https://colima.run/) ([repo](https://github.com/abiosoft/colima))
  * [containerd](https://containerd.io/) ([repo](https://github.com/containerd/containerd)) - container runtime
  * [Incus](https://linuxcontainers.org/incus/) - container and VM runtime alternative to LXD
* Virtual Machine Launcher
  * [Lima](https://lima-vm.io/) ([repo](https://github.com/lima-vm/lima))
* Others
  * [Finch](https://runfinch.com/)
  * [BuildKit Git Repo](https://github.com/moby/buildkit)
  * [Nerdctl Git Repo](https://github.com/containerd/nerdctl)
