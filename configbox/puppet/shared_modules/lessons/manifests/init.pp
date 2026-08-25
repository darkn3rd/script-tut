# Class: lessons
#
# Classifier-agnostic - every parameter below arrives as an ordinary
#  Puppet class parameter, bound however this catalog's classifier
#  delivers it: hiera automatic parameter lookup, an ENC's own
#  `classes:` block, or an explicit `class { 'lessons': ... }`
#  resource-like declaration in a generated node manifest. The class
#  bodies here never know or care which one - see scriptbox/scripts/
#  generate_puppet.rb --classifier [site|hiera|enc] (default hiera).
#
# Area gates ($gen_scripts/$shell_scripts/$compiled_lang/$win_scripts,
#  all default true) override per node/hiera-level/ENC entry to skip an
#  area entirely without touching this class or any area class itself.
class lessons (
  String[1]   $platform      = 'ubuntu22',
  String[1]   $user          = 'vagrant',
  Array[Hash] $common_steps  = [],
  Boolean     $gen_scripts   = true,
  Boolean     $shell_scripts = true,
  Boolean     $compiled_lang = true,
  Boolean     $win_scripts   = true,
) {
  if $facts['os']['family'] == 'Debian' {
    exec { 'lessons: apt-get update':
      command => '/usr/bin/apt-get update',
      unless  => '/usr/bin/find /var/cache/apt/pkgcache.bin -newer /etc/apt/sources.list 2>/dev/null | /usr/bin/grep -q .',
    }
  }

  # 'common' - steps that live directly on the manifest's own lessons.
  #  packages, not nested under any one of the four gated areas below -
  #  e.g. the sdkman bootstrap, which gen_scripts's own `sdkman: groovy`
  #  step depends on already having run. Always applied, ungated.
  $common_steps.each |Integer $i, Hash $step| {
    lessons::install_step { "lessons common ${i}: ${step['type']}/${step['name']}":
      step => $step,
      user => $user,
    }
  }

  if $gen_scripts   { contain lessons::gen_scripts }
  if $shell_scripts { contain lessons::shell_scripts }
  if $compiled_lang { contain lessons::compiled_lang }
  if $win_scripts   { contain lessons::win_scripts }
}
