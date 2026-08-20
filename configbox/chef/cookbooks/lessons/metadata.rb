name 'lessons'
maintainer 'darkn3rd'
license 'all_rights'
description 'Installs script-tut lesson tooling from generated data bags'
version '0.1.0'
chef_version '>= 15.0'

supports 'ubuntu'
supports 'windows'

# ruby_rbenv, not rbenv - the latter (RiotGames/rbenv-cookbook) is
#  abandoned, last published 2013, capped at 1.7.1. sous-chefs' own
#  ruby_rbenv is the actively maintained rbenv cookbook and is what
#  actually has a 4.x release line.
depends 'pyenv', '~> 4.2.8'
depends 'ruby_rbenv', '~> 4.0.0'
depends 'perl', '~> 8.0.15'
depends 'line', '~> 5.0.1'
depends 'chocolatey'
