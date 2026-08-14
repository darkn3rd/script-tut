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
      {% if grains['os_family'] == 'Debian' %}
      - php5-cli
      - tcl8.5
      {% elif grains['os_family'] == 'RedHat' %}
      - php-cli
      - tcl
      {% endif %}
