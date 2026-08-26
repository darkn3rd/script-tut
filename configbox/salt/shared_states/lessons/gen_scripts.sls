{#- gen_scripts.sls - one of the four gated areas, only ever pulled in
  by ./init.sls when lessons.gates.gen_scripts is true. Same shape as
  its three siblings (shell_scripts/compiled_lang/win_scripts.sls) -
  only the area key differs. #}

{%- from "lessons/map.jinja" import lessons, home with context %}
{%- import "lessons/install_step.jinja" as step_lib with context %}
{%- set steps = lessons.areas.get('gen_scripts', {}).get('steps', []) %}

{%- set formula_includes = [] %}
{%- for step in steps if step['type'] == 'salt_formula' %}
{%- do formula_includes.append(step['name']) %}
{%- endfor %}
{%- if formula_includes %}
include:
{%- for f in formula_includes %}
  - {{ f }}
{%- endfor %}
{%- endif %}

{%- for step in steps if step['type'] != 'salt_formula' %}
{{ step_lib.install_step('lessons-gen_scripts-' ~ loop.index0, step, lessons.user, home) }}
{%- endfor %}
