# Knife Vagrants

These are Vagrant Virtualbox systems that can be used with *knife-solo*.  They have the minimalist configuration, so the provisioning takes place outside of Vagrant.

## Knife Solo

Vagrant's Chef-Solo provisioning may not be to your liking, so as an alternatively you can skip Vagrant's built-in provisioning system and use *knife-solo* tool to provision these systems.

### Installing Knife Solo

You can install knife solo by installing the gem with `gem install knife-solo`.  

Alternatively, you can use bundler (`gem install bundler`) tool to install *knife-solo*:

```bash
$ CONFIGBOX=/path/to/script-tut/configbox
$ cd ${CONFIGBOX}/chef-solo
$ gem install bundler     # only if needed
$ bundle
```

### Preparation

Before we begin the journey, we need to do some upfront preparation work.  First we determine which vagrant we would like to use, such as *wheezy*.

Then we configure the following steps.

1. Create localhost copy of the target system.

```bash
$ CONFIGBOX=/path/to/script-tut/configbox
$ cd ${CONFIGBOX}/chef-solo
$ TARGET_VAGRANT=wheezy
$ cp nodes/${TARGET_VAGRANT}box.json 127.0.0.1.json
```

2. Extract Information for the target vagrant's ssh port and ssh key

```bash
$ pushd .
$ cd knife-vagrants/${TARGET_VAGRANT} # change to guest virtual system directory
$ vagrant up                          # this may take a while
$ VAGRANT_PORT=$(vagrant ssh-config | grep Port | grep -oE '\d+')
$ VAGRANT_KEY=$(vagrant ssh-config | grep IdentityFile | awk '{ print $2 }')
$ popd
```

### Install Chef-Solo onto virtual guest

```bash
knife solo prepare vagrant@127.0.0.1 -p ${VAGRANT_PORT} -i ${VAGRANT_KEY}
```

### Provision virtual guest

```bash
knife solo cook vagrant@127.0.0.1 -p ${VAGRANT_PORT} -i ${VAGRANT_KEY}
```

Reference: http://matschaffer.github.io/knife-solo/

### SSH Tips

You can automate the SSH options to log into the system by changing or adding a `~/.ssh/config` file.  

From the above you would add:

```bash
$ echo <<EOF
Host ${TARGET_VAGRANT}box
    HostName 127.0.0.1
    Port ${VAGRANT_PORT}
    IdentityFile ${VAGRANT_KEY}
    User vagrant
EOF >> ~/.ssh/config
```

Then after, you should be able to do this:

```bash
$ knife solo prepare "${TARGET_VAGRANT}box"
$ knife solo cook "${TARGET_VAGRANT}box"
```
