common_packages:
  pkg.installed:
    - pkgs:
      - dash
      - bash
      - ksh
      - tcsh
      - gawk
      - perl
      - python
      - ruby
      - perl
      {% if grains['os_familiy'] == 'Debian' %}
      - php5-cli
      - tcl8.5
      {% if grains['os_familiy'] == 'RedHat' %}
      - php-cli
      - tcl
      {% endif %}
