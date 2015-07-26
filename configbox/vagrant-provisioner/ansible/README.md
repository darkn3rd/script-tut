# ConfigBox: Ansible

© Joaquin Menchaca, 2015

## Overview

This area demonstrates how Ansible can be used to configure a ScriptBox environment.  The ScriptBox is an environment that can run demonstration scripts found within this tutorial.

Currently this section in under experimentation.

## Push Technolgy

Ansible is interesting in that it is a push technology, rather than a pull technology like Chef or Puppet.  Thus you need to know the systems in advance, before provisioning the systems.  As Vagrant systems are dynamically created, with a unique port for accessing ssh, this provides a bit of a challenge.

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
