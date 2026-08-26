# Hand-written - never regenerated. Two pillar files merge for this
#  node: common.sls (hand-written knobs, never touched by the
#  generator) and ubuntu22.sls (GENERATED - see ../../../../../
#  scriptbox/scripts/generate_salt.rb --tree masterless). Kept as two
#  files, not one, so re-running the generator can never clobber a
#  hand-written override.
base:
  'ubuntu22':
    - lessons.common
    - lessons.ubuntu22
