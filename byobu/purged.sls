{%- set os = salt['grains.get']('os') -%}
{%- set users = salt['pillar.get']('byobu:users', []) -%}
{%- set pkgdefault = { 
  'Ubuntu': 'byobu', 
  'CentOS': 'byobu' } -%}
{%- set pkgname = salt['pillar.get']('byobu:pkg:' ~ os, pkgdefault[os]) -%}
{%- set enable = salt['pillar.get']('byobu:enable', False) -%}

byobu.purged:
  pkg.purged:
    - name: {{ pkgname }}
  {% if users %}
  require:
  {% for user in users %}
    - byobu-disable-{{ user }}
    - byobu-purgeconfig-{{ user }}
  {% endfor %}
  {% endif %}

{% for user in users %}
{% set userhome = salt['user.info'](user).home %}
byobu-enable-{{ user }}:
  file.sed:
    - name: {{ userhome }}/.bash_profile
    - before: _byobu_sourced=1 . /usr/bin/byobu-launch
    - after: ''

byobu-purgeconfig-{{ user }}:
  file.absent:
    - name: {{ userhome }}/.byobu
{% endfor %}
