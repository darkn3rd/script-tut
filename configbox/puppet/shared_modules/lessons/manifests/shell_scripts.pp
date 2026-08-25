# Class: lessons::shell_scripts
#
# Static - never edited when the manifest/generated data changes. See
#  ./gen_scripts.pp's own comment for where $steps actually comes from.
class lessons::shell_scripts (
  Array[Hash] $steps = [],
) {
  $steps.each |Integer $i, Hash $step| {
    lessons::install_step { "lessons shell_scripts ${i}: ${step['type']}/${step['name']}":
      step => $step,
      user => $lessons::user,
    }
  }
}
