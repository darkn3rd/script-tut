# Virtualbox Windows Guest

## Launch VM

```bash
# download image, bootstrap VM
vagrant up --no-provision
```

## Provision VM

You can run the installation scripts using `vagrant provision` commands:

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

## Verify Environments (non-interactive)

You can verify tools are working in these environments with this one-line commands below.

**NOTE**: This output may get mangled due to text encoding between WinRM. 

```sh
WINDOWS_CMD="C:\script-tut\scriptbox\scripts\verify_commands.rb --format text"

MSYS2_CMD=$(cat <<'EOF'
  $env:MSYSTEM='UCRT64';
  Remove-Item Env:\HOME -ErrorAction SilentlyContinue;
  & 'C:\tools\msys64\usr\bin\bash.exe' `
    -ic '/c/script-tut/scriptbox/scripts/verify_commands.rb --format text'
EOF
)

CYGWIN_CMD=$(cat <<'EOF'
  Remove-Item Env:\HOME -ErrorAction SilentlyContinue;
  & 'C:\tools\cygwin\bin\bash.exe' `
    -ic '/cygdrive/c/script-tut/scriptbox/scripts/verify_commands.rb --format text'
EOF
)

vagrant powershell -c "$WINDOWS_CMD"
vagrant powershell -c "$MSYS2_CMD"
vagrant powershell -c "$CYGWIN_CMD"
```

## Interactive Sessions

This is how you can have interactive sessions with either OpenSSH or WinRM. 


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

## Verify Environment Interactively


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