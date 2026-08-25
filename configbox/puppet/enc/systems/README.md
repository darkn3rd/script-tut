# Puppet External Node Classifier Virtual Guests

## Provision in Steps

```sh
vagrant up --no-provision
vagrant provision --provision-with bootstrap
vagrant provision --provision-with enc
vagrant provision --provision-with apply
```

## Verify Interactively

```sh
vagrant ssh
/var/script-tut/scriptbox/scripts/verify_commands.rb --format text
```
