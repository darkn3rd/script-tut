# Class: lessons::win_scripts
#
# Static - never edited when the manifest/generated data changes. See
#  ./gen_scripts.pp's own comment for where $steps actually comes from.
class lessons::win_scripts (
  Array[Hash] $steps = [],
) {
  $steps.each |Integer $i, Hash $step| {
    lessons::install_step { "lessons win_scripts ${i}: ${step['type']}/${step['name']}":
      step => $step,
      user => $lessons::user,
    }
  }
}
