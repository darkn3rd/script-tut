# Define: lessons::install_step
#
# One step from a $steps array (see ./gen_scripts.pp and friends),
#  applied once per resource title by their own each() loops ($step -
#  the whole step hash - and $user passed straight through). Puppet has
#  no native switch/case-over-a-hash, so one case($type) block dispatches
#  on $step['type'] and handles every step shape the generator can emit.
#
# $home is computed here rather than looked up (getent-style) because
#  every current platform (ubuntu22) is a fixed, known Vagrant test user.
#
# Exec { path => [...] } at the top is a resource default, scoped to
#  just this define's own body - every bare-command exec below can stay
#  a plain shell fragment instead of repeating path => [...] each time.
define lessons::install_step (
  Hash   $step,
  String $user,
) {
  Exec {
    path => ['/usr/local/bin', '/usr/bin', '/bin'],
  }

  $home = $facts['os']['family'] ? {
    'windows' => "C:/Users/${user}",
    default   => "/home/${user}",
  }
  $type = $step['type']
  $step_name = $step['name']

  case $type {
    'apt': {
      if 'apt_repository' in $step {
        # apt_repository - a PPA (add-apt-repository) - always paired
        #  1:1 with a single package name; consolidate_apt in
        #  generate_puppet.rb deliberately excludes an apt_repository-
        #  carrying entry from the plain-package merge specifically so
        #  that holds here too.
        #
        # unless checks the actual sources.list.d files, not `apt-cache
        #  policy` output - policy prints the repo's real URL/label
        #  (e.g. "o=LP-PPA-dotnet-backports"), never the literal
        #  "ppa:owner/name" shorthand, so grepping policy output for
        #  that string never matches and this exec would otherwise
        #  re-run add-apt-repository (hitting Launchpad's API) on every
        #  single provision, PPA already added or not.
        $ppa_slug = regsubst($step['apt_repository'], '^ppa:', '')
        exec { "${title}: ppa":
          command => "/usr/bin/add-apt-repository -y '${step['apt_repository']}'",
          unless  => "/bin/grep -rqF '${ppa_slug}' /etc/apt/sources.list.d/",
          before  => Package[$step_name],
        }
        stdlib::ensure_packages([$step_name])
      } elsif 'add_apt_repo' in $step {
        # add_apt_repo - the manifest's own raw signed-by key + list
        #  file (Corretto, Docker, ...), not a PPA - see scriptbox/
        #  config/README.md. Native file/exec instead of an apt module
        #  resource - see ../../README.md's own "Forge Modules Used"
        #  note: apt is still only "being evaluated", not adopted.
        $repo = $step['add_apt_repo']
        $repo_parts = split($repo['distro_string'], ' ')
        $repo_suite = $repo_parts[0]
        $repo_components = join($repo_parts[1, -1], ' ')
        $key_path = "/etc/apt/keyrings/${repo['name']}.gpg"
        $list_path = "/etc/apt/sources.list.d/${repo['name']}.list"

        file { '/etc/apt/keyrings':
          ensure => directory,
        }

        exec { "${title}: key":
          command => "/bin/bash -c \"curl -fsSL '${repo['key_url']}' | gpg --dearmor -o '${key_path}'\"",
          creates => $key_path,
          require => File['/etc/apt/keyrings'],
        }

        file { $list_path:
          ensure  => file,
          content => "deb [signed-by=${key_path}] ${repo['repo_uri']} ${repo_suite} ${repo_components}\n",
          require => Exec["${title}: key"],
        }

        # add-apt-repository (the 'apt_repository' branch above) refreshes
        #  the apt cache itself; a raw key+list file doesn't, so without
        #  this the package below installs against a stale cache that has
        #  never heard of the new repo.
        exec { "${title}: update":
          command     => '/usr/bin/apt-get update',
          subscribe   => File[$list_path],
          refreshonly => true,
          before      => Package[$step_name],
        }

        stdlib::ensure_packages([$step_name])
      } else {
        stdlib::ensure_packages(any2array($step_name))
      }
    }

    # A raw "key=value" string (or an array of them) - deliberately just
    #  that one string, not a {key:, value:} hash, so the manifest's own
    #  data reads as a plain sysctl -w argument, the same shape every
    #  other CM tool's own sysctl-equivalent primitive expects.
    'sysctl': {
      any2array($step_name).each |String $kv| {
        $parts = split($kv, '=')
        $key   = $parts[0]
        $value = $parts[1, -1].join('=')
        exec { "${title}: ${kv}":
          command => "/usr/sbin/sysctl -w '${kv}'",
          unless  => "/usr/sbin/sysctl -n '${key}' | /bin/grep -qx '${value}'",
        }
      }
    }

    'file': {
      $dest = regsubst($step['dest'], '\$HOME', $home)
      ensure_resource('file', dirname($dest), { 'ensure' => 'directory', 'owner' => $user, 'mode' => '0755' })
      file { $dest:
        ensure  => file,
        content => $step['content'],
        owner   => $user,
        mode    => '0644',
        require => File[dirname($dest)],
      }
    }

    'append': {
      $raw_dests = $step['dest'] =~ String ? { true => [$step['dest']], default => $step['dest'] }
      $dests = $raw_dests.map |$d| { regsubst($d, '\$HOME', $home) }
      $dests.each |$d| {
        $dir = dirname($d)
        # ensure_resource on $dir alone only covers one level - not enough
        #  for a target like ~/.config/powershell/... where ~/.config
        #  itself doesn't exist yet either. Walk every ancestor under $home.
        $rel_dir = regsubst($dir, "^${home}/", '')
        if $rel_dir != $dir {
          split($rel_dir, '/').reduce($home) |$parent, $seg| {
            $cur = "${parent}/${seg}"
            ensure_resource('file', $cur, { 'ensure' => 'directory', 'owner' => $user, 'mode' => '0755' })
            $cur
          }
        } else {
          ensure_resource('file', $dir, { 'ensure' => 'directory', 'owner' => $user, 'mode' => '0755' })
        }
        # file_line manages a line *within* a file - it doesn't create the
        #  file itself, so a target that doesn't pre-exist (like a
        #  PowerShell profile nothing has run yet to generate) errors out
        #  with a plain ENOENT unless something ensures the file first. An
        #  exec+touch (not a file resource) on purpose - some of these
        #  destinations (.bashrc/.zshrc) are *also* the target of a 'file'
        #  step elsewhere with real content, and two `file { $d: }`
        #  declarations for the same path is a duplicate-declaration
        #  error regardless of which runs first; a distinct resource
        #  type/title never collides, and `file`'s content still wins
        #  either way since it overwrites whatever touch left behind.
        exec { "${title}: ensure ${d} exists":
          command => "/usr/bin/touch '${d}'",
          creates => $d,
          require => File[$dir],
        }
        $step['lines'].each |Integer $li, String $line| {
          file_line { "${title}: ${d} #${li}":
            path    => $d,
            line    => $line,
            require => Exec["${title}: ensure ${d} exists"],
          }
        }
      }
    }

    'script': {
      case $step_name {
        # ubuntu22_powershell - the manifest's own script downloads and
        #  installs a vendor .deb that configures apt itself, not a
        #  plain PPA - get_url-equivalent (exec+creates) + package{deb}
        #  is the faithful native equivalent; there's no way to express
        #  "install this specific local .deb" through the generic apt
        #  case above.
        'ubuntu22_powershell': {
          exec { "${title}: download ms deb":
            command => '/usr/bin/wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb',
            creates => '/tmp/packages-microsoft-prod.deb',
          }
          exec { "${title}: install ms deb + refresh":
            command => '/usr/bin/dpkg -i /tmp/packages-microsoft-prod.deb && /usr/bin/apt-get update',
            unless  => "/usr/bin/dpkg -s packages-microsoft-prod",
            require => Exec["${title}: download ms deb"],
          }
          package { 'powershell':
            ensure  => installed,
            require => Exec["${title}: install ms deb + refresh"],
          }
          # psake needs installing for the *lessons user*, not whoever
          #  the Puppet agent itself runs as - user/environment keep
          #  -Scope CurrentUser landing in the right home directory.
          exec { "${title}: install psake":
            command     => 'pwsh -NoProfile -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; Install-Module -Name psake -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber"',
            unless      => 'pwsh -NoProfile -Command "if (Get-Module -ListAvailable -Name psake) { exit 0 } else { exit 1 }"',
            user        => $user,
            environment => ["HOME=${home}"],
            require     => Package['powershell'],
          }
        }

        # ubuntu22_rust - rustup's own installer script, which has no
        #  idempotency guard of its own; creates gives it one here.
        'ubuntu22_rust': {
          exec { $title:
            command     => "/bin/bash -c \"curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path\"",
            creates     => "${home}/.cargo/bin/cargo",
            user        => $user,
            environment => ["HOME=${home}"],
          }
        }

        # Generic script - no idempotency guard here either: whatever
        #  the manifest's own cmd body does about re-runs is all there is.
        default: {
          # provider => shell always runs via /bin/sh -c "<command>" - a
          #  shebang embedded in that string is just a comment to sh, not
          #  an actual interpreter switch, so it never gets to bash. These
          #  scripts (see scriptbox/config/ubuntu2204.yml's own per-script
          #  `type: bash`, dropped by the generator before reaching here)
          #  rely on bash-only syntax like `source`, which dash lacks.
          #  Writing the script to a real file with its own shebang and
          #  executing that file directly is the only way to actually get
          #  bash, without having to shell-quote arbitrary cmd content
          #  (which may itself contain stray single quotes).
          $script_path = "/tmp/lessons_${step_name}.sh"
          file { $script_path:
            ensure  => file,
            content => "#!/bin/bash\n${step['cmd']}",
            mode    => '0755',
          }
          exec { $title:
            command     => $script_path,
            user        => $user,
            environment => ["HOME=${home}"],
            cwd         => $home,
            require     => File[$script_path],
          }
        }
      }
    }

    # sdk is a shell function, not a binary - only defined once
    #  sdkman's own init script has been sourced (the ubuntu22_sdkman
    #  common step, which must already have run). No idempotency guard
    #  here either - relies on sdkman_auto_answer=true (set by that same
    #  common step) plus `sdk install`'s own already-installed handling.
    'sdkman': {
      exec { $title:
        command     => "/bin/bash -c 'source ${home}/.sdkman/bin/sdkman-init.sh && sdk install ${step_name}'",
        user        => $user,
        environment => ["HOME=${home}"],
      }
    }

    'cpan', 'cpanm': {
      # cpanminus - the real prerequisite every cpan/cpanm step needs;
      #  stdlib::ensure_packages dedups automatically across every step
      #  that calls it, so running it ahead of each is harmless.
      stdlib::ensure_packages(['cpanminus'])
      exec { $title:
        command     => "/bin/bash -c 'cpanm ${step_name}'",
        unless      => "/bin/bash -c \"perl -M'${step_name}' -e 1\"",
        user        => $user,
        environment => ["HOME=${home}"],
        require     => Package['cpanminus'],
      }
    }

    # No Puppet-native pyenv resource exists (see ../../README.md's own
    #  "Missing Modules" note) - `pyenv install -s`/pyenv global instead,
    #  PATH-scoped to reach the pyenv binary without needing a login
    #  shell's own eval "$(pyenv init -)". creates gives the install its
    #  own idempotency guard, since the raw command has none of its own.
    'pyenv': {
      exec { "${title}: install":
        command     => "/bin/bash -c 'PYENV_ROOT=${home}/.pyenv PATH=${home}/.pyenv/bin:${home}/.pyenv/shims:\$PATH pyenv install -s ${step_name}'",
        creates     => "${home}/.pyenv/versions/${step_name}",
        user        => $user,
        environment => ["HOME=${home}"],
      }
      if 'cmd' in $step {
        exec { "${title}: global":
          command     => $step['cmd'],
          provider    => shell,
          user        => $user,
          environment => ["HOME=${home}", "PYENV_ROOT=${home}/.pyenv", "PATH=${home}/.pyenv/bin:${home}/.pyenv/shims:/usr/bin:/bin"],
          require     => Exec["${title}: install"],
        }
      }
    }

    'rbenv': {
      exec { "${title}: install":
        command     => "/bin/bash -c 'PATH=${home}/.rbenv/bin:${home}/.rbenv/shims:\$PATH rbenv install -s ${step_name}'",
        creates     => "${home}/.rbenv/versions/${step_name}",
        user        => $user,
        environment => ["HOME=${home}"],
      }
      if 'cmd' in $step {
        exec { "${title}: global":
          command     => $step['cmd'],
          provider    => shell,
          user        => $user,
          environment => ["HOME=${home}", "PATH=${home}/.rbenv/bin:${home}/.rbenv/shims:/usr/bin:/bin"],
          require     => Exec["${title}: install"],
        }
      }
    }

    # "<plugin> <repo_url>" - asdf plugin add errors out if the plugin's
    #  already registered, unlike sdkman/pyenv/rbenv above - so this
    #  checks `plugin list` first.
    'asdf_plugin': {
      $asdf_parts = split($step_name, ' ')
      exec { $title:
        command     => "/bin/bash -c 'asdf plugin list | grep -qx \"${asdf_parts[0]}\" || asdf plugin add ${asdf_parts[0]} ${asdf_parts[1]}'",
        user        => $user,
        environment => ["HOME=${home}"],
      }
    }

    # "<language> <version>" - `asdf install` already skips a version
    #  that's already installed, no creates-style guard needed the way
    #  pyenv/rbenv above get from their own install command.
    'asdf': {
      exec { "${title}: install":
        command     => "/bin/bash -c 'asdf install ${step_name}'",
        user        => $user,
        environment => ["HOME=${home}"],
      }
      if 'cmd' in $step {
        exec { "${title}: set":
          command     => $step['cmd'],
          provider    => shell,
          user        => $user,
          environment => ["HOME=${home}"],
          require     => Exec["${title}: install"],
        }
      }
    }

    # pkgbox/chocolatey/<name>/ - a local nuspec source for a package
    #  missing from the community Chocolatey feed (see pkgbox's own
    #  README). version: is always an exact pin - choco install
    #  --version has no floor semantics, so '>=' is rejected outright.
    'choco_local': {
      if 'version' in $step and $step['version'] =~ /^>=/ {
        fail("lessons::install_step '${title}': choco_local '${step_name}' version must be an exact pin ('=' or a bare version) - choco install --version has no floor semantics")
      }
      $choco_dir = "pkgbox/chocolatey/${step_name}"
      $choco_version_flag = 'version' in $step ? {
        true    => " --version=${regsubst($step['version'], '^=\s*', '')}",
        default => '',
      }
      exec { "${title}: pack":
        command => "choco pack ${choco_dir}/${step_name}.nuspec --output-directory=${choco_dir}/vendor",
      }
      exec { "${title}: install":
        command => "choco install ${step_name} --source=${choco_dir}/vendor${choco_version_flag} --yes",
        require => Exec["${title}: pack"],
      }
    }

    # pwsh, not native PowerShell - every current platform (ubuntu22)
    #  has no native PowerShell host, so this always goes through the
    #  pwsh wrapper. -Force covers the untrusted-PSGallery prompt on its
    #  own for powershell_module - no separate repository-trust step
    #  needed.
    # unless guards below match chef/cookbooks/lessons/resources/
    #  pwsh_package.rb's own Get-Module check exactly - that resource
    #  exists specifically because Chef's *built-in* powershell_package
    #  looks cross-platform but isn't (its provider only ever calls
    #  Chef::Mixin::PowershellExec, empty on non-Windows) - it's the
    #  genuine cross-platform fallback, and unlike a bare exec, it's
    #  actually idempotent. Without a guard here, both of these would
    #  re-run Install-Module/Install-PackageProvider on every single
    #  apply, reporting a false "changed" every time even when nothing
    #  changed.
    'powershell_package_provider': {
      $ps_version = 'version' in $step ? {
        true    => " -MinimumVersion ${regsubst($step['version'], '^(>=|=)\s*', '')}",
        default => '',
      }
      exec { $title:
        command     => "pwsh -NoProfile -Command \"Install-PackageProvider -Name ${step_name}${ps_version} -Force\"",
        unless      => "pwsh -NoProfile -Command \"if (Get-PackageProvider -Name ${step_name} -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }\"",
        user        => $user,
        environment => ["HOME=${home}"],
      }
    }

    'powershell_module': {
      $ps_args = 'args' in $step ? { true => " ${step['args']}", default => '' }
      exec { $title:
        command     => "pwsh -NoProfile -Command \"Install-Module -Name ${step_name}${ps_args} -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber\"",
        unless      => "pwsh -NoProfile -Command \"if (Get-Module -ListAvailable -Name ${step_name}) { exit 0 } else { exit 1 }\"",
        user        => $user,
        environment => ["HOME=${home}"],
      }
    }

    # One raw PowerShell command/expression - the escape hatch for
    #  whatever powershell_package_provider/powershell_module above
    #  don't cover (e.g. Set-PSRepository's own repository-trust call).
    'powershell_cmd': {
      exec { $title:
        command     => "pwsh -NoProfile -Command \"${step_name}\"",
        user        => $user,
        environment => ["HOME=${home}"],
      }
    }

    default: {
      notify { "${title}: unsupported step type":
        message => "lessons: unsupported step type '${type}' for '${step_name}'",
      }
    }
  }
}
