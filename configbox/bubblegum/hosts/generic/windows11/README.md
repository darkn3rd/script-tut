# Virtualbox Windows Guest

## Launch VM

```bash
# download image, bootstrap VM
vagrant up --no-provision
```

## Provision VM

```bash
##############################
# provision windows - 32m33s
##############################
vagrant provision --provision-with windows

##############################
# provision msys2 - 10m20s
##############################
vagrant provision --provision-with msys2

##############################
# provision cygwin - 39m16s
##############################
vagrant provision --provision-with cygwin
```

## Interactive Sessions

### Command Shell (OpenSSH)

```bash
vagrant ssh 
```

### Powershell (WinRM)

On a Windows Host, you can type:

```bash 
vagrant powershell
```

For non-Windows systems, you can get `evil-winrm`:

```bash
gem install evil-winrm
export PATH="$(gem environment gemdir)/bin:$PATH"
WINRM_PORT="$(vagrant winrm-config | awk '/Port/{print $2}')"

evil-winrm -i 127.0.0.1 -u vagrant -p vagrant -P $WINRM_PORT
```

### Verifying Provision Scripts

Log into guest with `vagrant ssh`:

```batch
:: Remove HOME env var
::   HOME is set to %USERPROFILE% which interferes with cygwin and msys2
set HOME=

:: launch Powershell
pwsh
```

While in Powershell, run these:

```pwsh
##############################
# test packages on Windows
##############################
C:\script-tut\scriptbox\scripts\verify_commands.rb

##############################
# test packages on MSYS2
##############################
& "C:\tools\msys64\msys2_shell.cmd" -ucrt64 -defterm -no-start -where .
/c/script-tut/scriptbox/scripts/verify_commands.rb
exit # msys2 (bash.exe)

##############################
# test packages on Cygwin
##############################
& "C:\tools\cygwin\bin\bash.exe" --login -i
/cygdrive/c/script-tut/scriptbox/scripts/verify_commands.rb
exit # cygwin (bash.exe)

# exit powershell (pwsh.exe)
exit
```

Now you are back in Command Shell, exit from there to return back to the host

```batch
:: exit from vagrant guest (cmd.exe)
exit
```