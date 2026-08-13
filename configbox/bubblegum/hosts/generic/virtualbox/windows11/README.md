# Virtualbox Windows Guest

## Launch VM

```bash
# download image, bootstrap VM
vagrant up --no-provision
```

## Provision VM

```bash
# run scripts
vagrant provision --provision-with windows
vagrant provision --provision-with msys2
vagrant provision --provision-with cygwin
```

## Interactive Sessions

### OpenSSH

```bash
vagrant ssh 
```

### Powershell (WinRM)

If you would like to try out Powershell through WinRM, you can do one of the following below.

On a Windows Host, you can type:

```bash 
vagrant powershell
```

For non-Windows systems, you can get `evil-winrm`:

```bash
gem install evil-winrm
WINRM_CMD="$(gem env | awk -F': ' '/EXECUTABLE DIRECTORY/ {print $2}')/evil-winrm"
WINRM_PORT"$(vagrant winrm-config | awk '/Port/{print $2}')"

$WINRM_CMD -i 127.0.0.1 -u vagrant -p vagrant -P $WINRM_PORT
```

### Verifying Provision Scripts

Log into an interactive session with into the Windows Guest using `vagrant ssh`:

```pwsh
pwsh

# test packages on Windows
C:\script-tut\scriptbox\scripts\verify_commands.rb

# test packages on MSYS2
& "C:\tools\msys64\msys2_shell.cmd" -ucrt64 -defterm -no-start -where .
/c/script-tut/scriptbox/scripts/verify_commands.rb
exit # msys2

# test packages on Cygwin
& "C:\tools\cygwin\bin\bash.exe" --login -i
/cygdrive/c/script-tut/scriptbox/scripts/verify_commands.rb
exit # cygwin
exit # pwsh
exit # vagrant
```
