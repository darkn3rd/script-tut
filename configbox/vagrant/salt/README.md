# ConfigBox: Salt Stack
© Joaquin Menchaca, 2015

## Overview
This area demonstrates how SaltStack can be used to configure a ScriptBox environment.  The ScriptBox is an environment that can run demonstration scripts found within this tutorial.

Currently this section in under experimentation.

## Bugs

Provisioning is challenged with Vagrant 1.7.4 that introduced bugs that prevents Salt Stack provisioner from working well:
- **Salt provisioner fails to upload minion config** (Issue #[5973](https://github.com/mitchellh/vagrant/issues/5973))
- **Regression: Salt provisioning fails when box is already provisioned** (Issue #[6011](https://github.com/mitchellh/vagrant/issues/6011))
- **Bootstrapping Salt Fails Due to Salt-Boostrap Update** (Issue #[6029](https://github.com/mitchellh/vagrant/issues/6029))
- **Failure during salt provision since upgrade to 1.7.4** (Issue #[6103](https://github.com/mitchellh/vagrant/issues/6103))

It seems these errors were introduced in Vagrant 1.7.4, so rolling back to Vagrant 1.7.2 may be the easiest path for now.

I might have ran into this issue as well:

- **Masterless salt-call attempts to load pillar.sls files from salt:// uri** (Issue #[6103](https://github.com/saltstack/salt/issues/18775))
