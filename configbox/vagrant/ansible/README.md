# ConfigBox: Ansible

© Joaquin Menchaca, 2015

## Overview

This area demonstrates how Ansible can be used to configure a ScriptBox environment.  The ScriptBox is an environment that can run demonstration scripts found within this tutorial.

Currently this section in under experimentation.

## Push Technolgy

Ansible is different that other provisioning technologies in that it is a push technology, meaning that Ansible remotely logs into a system invokes commands.  This is different that the pull technologies (CFEngine 3, Chef, or Puppet) that use an agent to pull down a configuration and apply it locally on the system.  

Ansible has the ability to run a configuration loocally on a system, but Vagrant's Ansible provisioner does not support this.  The provisioner will run ansible on the host system (thus requires a python environment and ansible) and then remotely logs into the system to do the magic.

## Hostname Based Configuration

By default, Vagrant's Ansible provisioner logs into the system, and automatically crafts a one-system inventory file (stored as `.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory`).  

For small scripts and experiments, this automated behavior may be acceptable, but for a managed repository of code that supports many unique systems, such as database server with MySQL installed or a web server with Apache installed, this solution may not work.

The Vagrantfile configuration files found in here, simulate hostbased configuration, so if there's host called `db01` and a host called `web01`, with unique configurations, e.g. MySQL and Apache, for those systems based on their hostname.  This is done by managing a vagrant inventory file (`provisoning/vagrant.ini`) that is used by Ansible to provision these systems.

## Links

Using these as references:

* Directory Layout Research
  - http://docs.ansible.com/playbooks_best_practices.html#directory-layout
  - Dynamic Directory - http://docs.ansible.com/intro_dynamic_inventory.html
  - Stack Exchange Question - http://stackoverflow.com/questions/30036138/ansible-create-directories-from-a-list
  - Shell Scriptr to Create Dirs - https://gist.github.com/qittu/b1bc1c54bf22eb3cecd8
* Really Good Guide - http://www.stavros.io/posts/example-provisioning-and-deployment-ansible/
* Another Guide - https://medium.com/@Drew_Stokes/ansible-good-for-the-environment-6ed26dc0e06e
* Ansible NGinx Example - http://www.capsunlock.net/2012/04/ansible-nginx-playbook.html
* Some PDF Reference (Don't know what this is yet) - http://www-uxsup.csx.cam.ac.uk/~jw35/docs/ansible/ansible-summary.pdf
* Vagrant Docs - http://docs.vagrantup.com/v2/provisioning/ansible.html
* Environment Vars - http://www.geedew.com/setting-up-ansible-for-multiple-environment-deployments/
* pedantically_commented_playbook.yml - https://gist.github.com/marktheunissen/2979474
* http://tomoconnor.eu/blogish/getting-started-ansible/#.VZ1YtqZ8tTU
* https://nylas.com/blog/graduating-past-playbooks
* http://probably.co.uk/ansible-for-puppet-users.html
