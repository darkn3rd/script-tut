# Hand-written - never regenerated. Every node this tree knows about
#  gets the same one entry point; area gating happens inside the
#  lessons tree itself (see ../../../shared_states/lessons/init.sls),
#  not here.
base:
  'ubuntu22':
    - lessons
