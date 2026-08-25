{#- shell_scripts.sls - see ./gen_scripts.sls's own header comment;
  same shape, different area key. #}

{%- from "lessons/map.jinja" import lessons, home with context %}
{%- import "lessons/install_step.jinja" as step_lib with context %}
{%- set steps = lessons.areas.get('shell_scripts', {}).get('steps', []) %}

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
{{ step_lib.install_step('lessons-shell_scripts-' ~ loop.index0, step, lessons.user, home) }}
{%- endfor %}
