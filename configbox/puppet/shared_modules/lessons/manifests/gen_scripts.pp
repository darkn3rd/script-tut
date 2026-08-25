# Class: lessons::gen_scripts
#
# Static - never edited when the manifest/generated data changes. All
#  content arrives via $steps, bound however this catalog's classifier
#  delivers it (hiera key lessons::gen_scripts::steps, an ENC classes:
#  block, or an explicit class{} in a generated node manifest - see
#  ../../../../scriptbox/scripts/generate_puppet.rb --classifier).
#  $lessons::user (not a param here) - reused straight from the
#  containing lessons class, same as every other area class; no reason
#  to have four classifiers each bind the same user separately.
class lessons::gen_scripts (
  Array[Hash] $steps = [],
) {
  $steps.each |Integer $i, Hash $step| {
    lessons::install_step { "lessons gen_scripts ${i}: ${step['type']}/${step['name']}":
      step => $step,
      user => $lessons::user,
    }
  }
}
