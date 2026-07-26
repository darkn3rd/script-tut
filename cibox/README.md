# Continuous Integration (CI)

[../.github/workflows/ci.yml](../.github/workflows/ci.yml) runs the shared [testbox](../testbox/README.md) harness (`rake`) for a fixed set of languages on every push/PR - currently `python3`, `ruby`, `perl`, `bash`, and `powershell`. That matrix list *is* the "which languages are tested in CI" tag: there's no separate manifest file, adding or dropping a language means editing that one list directly. `rake` only actually fails the job on a real test failure because of the `at_exit` hook at the bottom of `testbox/Script.rb` - without it, Ruby exits 0 regardless of how many test comparisons came back false.

## Setup for Act

### Windows 11: Elevated Privileges

In order to run elevated privileges without ambiguity in the instructions, install gsudo.  Any command that requires elevated privileges will be prepended by gsudo. Use Chocolatey or Winget in a termianl with elevated privileges. 

* Instasll with Chocolatey
  ```powershell
  choco install -y gsudo
  ```
* Install using Winget
  ```powershell
  winget install gerardog.gsudo
  ```

After you can enabled caching, so you don't have to elevate privileges for every command.  Not this is considered a security risk. 

```powershell
# set cache on in current session
gsudo cache on               
# configure cache to always be turned on
gsudo config CacheMode Auto
```

### Windows 11 Home Prerequisites

#### Install WSL2

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

#### Install Linux

TBD

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

#### Colima

**[Colima](https://colima.run/)** 

```bash
brew install colima docker
colima start
```

## Getting Act

### Windows 11 Home: Chocolatey

```powershell
choco install act-cli
```

### Windows 11 Home: WinGet

```powershell
winget install nektos.act
```

### macOS: Homebrew

```bash
brew install act
```
## Running it locally

You can run the exact same workflow on your own machine with [`act`](https://github.com/nektos/act), which replays the YAML against real containers instead of guessing what CI would do:

`act` needs a Docker-compatible daemon. If you don't already have Docker Desktop, [colima](https://github.com/abiosoft/colima) is a lighter, CLI-only alternative that works as a drop-in:

```bash
brew install colima docker
colima start
```

Then, from the repo root:

```bash
# Run every language in the matrix
act push -W .github/workflows/ci.yml -P ubuntu-latest=catthehacker/ubuntu:act-latest --container-daemon-socket -

# Run just one (handy while iterating on a single language)
act push -W .github/workflows/ci.yml -P ubuntu-latest=catthehacker/ubuntu:act-latest --container-daemon-socket - --matrix name:python3
```

Notes on those flags, in case something looks off:

* `-P ubuntu-latest=catthehacker/ubuntu:act-latest` picks `act`'s "Medium" runner image non-interactively (its first-run prompt otherwise hangs waiting for input). This image is a much smaller approximation of the real GitHub-hosted runner - it's what actually caught that `bash`'s and `powershell`'s jobs needed explicit `bc`/`pwsh` install steps, since the real runner apparently already has both but this local image doesn't.
* `--container-daemon-socket -` works around a known `act` + colima incompatibility (mounting the Docker socket into the job container fails under colima's setup) - not needed if you're using Docker Desktop instead.
* If you see `error getting credentials - err: exec: "docker-credential-desktop": executable file not found`, your `~/.docker/config.json` has a stale `"credsStore": "desktop"` entry from a previous Docker Desktop install - remove that line (colima doesn't need a credential helper for pulling public images).
* Running the *entire* matrix at once may print `Job failed` for every job even when only one genuinely failed - `act` has a known quirk where a failing sibling job's status leaks into the summary line of others in the same run. Trust each job's own `Summary: Total=... Fail=...` line (and re-run that one job alone with `--matrix name:...` to confirm) over the top-level `🏁` line when the two disagree.


## Further Reading 

* WSL
  * [How to install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Docs)

* Package Managers
  * [Mise](https://mise.en.dev/) and [Mise Git Repo](https://github.com/jdx/mise)
  * [Nix](https://nixos.org/)
* Container Runtimes
  * [Colima](https://colima.run/) and [Colima Git Repo](https://github.com/abiosoft/colima)
  * [containerd](https://containerd.io/) and [containerd git repo](https://github.com/containerd/containerd) - container runtime
  * [Incus](https://linuxcontainers.org/incus/) - container and VM runtime alternative to LXD
* Virtual Machine Launcher
  * [Lima](https://lima-vm.io/) and [Lima Git Repo](https://github.com/lima-vm/lima)
* Others
  * [Finch](https://runfinch.com/)
  * [BuildKit Git Repo](https://github.com/moby/buildkit)
  * [Nerdctl Git Repo](https://github.com/containerd/nerdctl)
