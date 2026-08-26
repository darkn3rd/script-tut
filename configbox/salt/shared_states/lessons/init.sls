{#- init.sls

  Entry point for the whole "lessons" tree - always applied, ungated,
  regardless of where its data came from (see ./map.jinja). Every
  common step runs here unconditionally; the four areas below are each
  their own file, pulled in only when their own gate is on. #}

{%- from "lessons/map.jinja" import lessons, home with context %}
{%- import "lessons/install_step.jinja" as step_lib with context %}

{%- set formula_includes = [] %}
{%- for step in lessons.common_steps if step['type'] == 'salt_formula' %}
{%- do formula_includes.append(step['name']) %}
{%- endfor %}

{%- if formula_includes
    or lessons.gates.gen_scripts or lessons.gates.shell_scripts
    or lessons.gates.compiled_lang or lessons.gates.win_scripts %}
include:
{%- for f in formula_includes %}
  - {{ f }}
{%- endfor %}
{%- if lessons.gates.gen_scripts %}
  - lessons.gen_scripts
{%- endif %}
{%- if lessons.gates.shell_scripts %}
  - lessons.shell_scripts
{%- endif %}
{%- if lessons.gates.compiled_lang %}
  - lessons.compiled_lang
{%- endif %}
{%- if lessons.gates.win_scripts %}
  - lessons.win_scripts
{%- endif %}
{%- endif %}

{%- for step in lessons.common_steps if step['type'] != 'salt_formula' %}
{{ step_lib.install_step('lessons-common-' ~ loop.index0, step, lessons.user, home) }}
{%- endfor %}
