class scriptbox (
  $mode          = $scriptbox::params::mode,
  $shells        = $scriptbox::params::shells,
  $scripting     = $scriptbox::params::scripting,
  $gvm_install   = $scriptbox::params::gvm_install,
) inherits scriptbox::params {

  if $mode == "win" {
    include scriptbox::win
  }
  else {
    include scriptbox::nix
  }
}
