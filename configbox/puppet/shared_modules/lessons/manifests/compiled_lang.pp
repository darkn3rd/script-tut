# Class: lessons::compiled_lang
#
# Static - never edited when the manifest/generated data changes. See
#  ./gen_scripts.pp's own comment for where $steps actually comes from.
class lessons::compiled_lang (
  Array[Hash] $steps = [],
) {
  $steps.each |Integer $i, Hash $step| {
    lessons::install_step { "lessons compiled_lang ${i}: ${step['type']}/${step['name']}":
      step => $step,
      user => $lessons::user,
    }
  }
}
