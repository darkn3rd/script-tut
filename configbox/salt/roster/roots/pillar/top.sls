# Intentionally empty. This tree delivers every value the lessons
#  tree needs as minion_opts.grains embedded directly in ../roster.yaml
#  (generated - see its own header comment) instead of through pillar
#  at all - see shared_states/lessons/map.jinja's own grains-first
#  lookup. This file exists only because salt-ssh's own config-dir
#  (../master) expects a pillar_roots/top.sls to resolve without
#  erroring - it deliberately contributes no data of its own.
base: {}
