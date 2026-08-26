# Intentionally empty - see ../../roster/roots/pillar/top.sls's own
#  comment, same reasoning: every value the lessons tree needs arrives
#  as a grain (here, computed fresh on every run by ../roster_modules/
#  lessons_dynamic.py, rather than read from a file at all - see its
#  own header comment), never through pillar. This file exists only
#  because salt-ssh's own config-dir (../master) expects a
#  pillar_roots/top.sls to resolve without erroring.
base: {}
