# Guest Systems



# Control System

The control is the system that executes the Ansible scripts. This can vary depending on your setup:

* Vagrant Provisioner
  * `ansible_local` - the virtual guest is both the controller and the target. 
  * `ansible` - the non-Windows host system is the control, which executes scripts remotely on the target
* BYOP (Bring Your Own Provisioner)
  * You can execute scripts from the non-Windows host onto the vagrant guest

## Wy not Windows

Windows does not support `fork()` and implementation through Cygwin is barely useable. The filesystem NTFS does not support POSIX symbolic links, which is required by collections.  

Under MSYS2, I was able to get some minmal functionality to install roles:

```sh
# launch msys environment
& "C:\tools\msys64\msys2_shell.cmd" -msys -defterm -no-start -where .
# install requirements
pacman -S python python-pip python-cryptography
# setup virtual environment
python -m venv --system-site-packages ~/.venvs/ansible-galaxy

# update pip (optional)
~/.venvs/ansible-galaxy/bin/pip install --upgrade pip

# install ansible core
~/.venvs/ansible-galaxy/bin/pip install ansible-core

# Install Role
cd ../../provision
~/.venvs/ansible-galaxy/bin/ansible-galaxy role install \
  -r requirements.yml \
  -p .galaxy-vendor/roles \
  --force

# FAILS: symbolic links are required
#
# ~/.venvs/ansible-galaxy/bin/ansible-galaxy collection install \
#   -r requirements.yml \
#   -p .galaxy-vendor/collections \
#   --force
```

## Notes

* Ansible will not trust world writeable directories, such as vboxsf mounts.  You can test with with
  ```sh
  stat -c '%a %U:%G %n' /path/to/test
  ``` 