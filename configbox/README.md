# ConfigBox

© Joaquin Menchaca, 2015

**Last Update** July 26th, 2015

## Overview

This area will have details about how to configure a system with all the scripting languages needed for this tutorial.  There are the targeted tools and environemnts

## Knife-Solo

Knife Solo is a great tool that simulates a real Chef environment that would exist with a Chef Server.  The tool will remotely control a system, and configure the system with chef-solo.  Knife Solo also dynamically builds the configuration based on the `nodes/{hostname}.json` configuration files.

## Test Kitchen

This is for future mention.  Test Kitchen is a great tool that can automate several vagrant systems.  Chef has incorporated this tool for testing chef environments, and it has been popular with Ansbile as well.  Feasibly, it can be used to test any change configuration tool.  This tool does not use Vagrant's built-in provisioners, and handles provisioning outside the vagrant system.

## Vagrant

Vagrant directory contains configurations that use the built-in provisioners that come with Vagrant.

The current provioners being tested are the following:

  * ansible
  * chef_solo
  * cfengine
  * puppet
