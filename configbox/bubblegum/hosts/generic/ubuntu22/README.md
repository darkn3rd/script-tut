# Ubuntu 22.04 Jammy Jellyfish

## Launch VM

```bash
# download image, bootstrap VM
vagrant up --no-provision
```

## Provision VM

```bash
vagrant provision
```

## Verify Environments (non-interactive)

```sh
vagrant ssh -c "/var/script-tut/scriptbox/scripts/verify_commands.rb --format text"
```

## Interactive Sessions

This is how you can have interactive sessions with either OpenSSH:


### Command Shell (OpenSSH)

```bash
vagrant ssh 
```

## Verify Environment Interactively


```bash
/var/script-tut/scriptbox/scripts/verify_commands.rb
```