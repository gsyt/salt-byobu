{%- set os = salt['grains.get']('os') -%}
{%- set users = salt['pillar.get']('byobu:users', []) -%}
{%- set pkgdefault = { 
  'Ubuntu': 'byobu', 
  'CentOS': 'byobu' } -%}
{%- set pkgname = salt['pillar.get']('byobu:pkg:' ~ os, pkgdefault[os]) -%}
{%- set enable = salt['pillar.get']('byobu:enable', False) -%}

byobu.installed:
  pkg.latest:
    - name: {{ pkgname }}
  {% if users %}
  require:
  {% for user in users %}
  {% if enable == True %}
    - byobu-enable-{{ user }}
  {% endif %}
    - byobu-tmuxconf-{{ user }}
  {% endfor %}
  {% endif %}

{% for user in users %}
{% set userhome = salt['user.info'](user).home %}
{% if enable == True %}
byobu-enable-{{ user }}:
  file.append:
    - name: {{ userhome }}/.bash_profile
    - text: _byobu_sourced=1 . /usr/bin/byobu-launch
{% endif %}

byobu-config-{{ user }}:
  file.directory:
    - name: {{ userhome }}/.byobu
    - user: {{ user }}
    - mode: 655

byobu-tmuxconf-{{ user }}:
  file.symlink:
    - name: {{ userhome }}/.byobu/.tmux.conf
    - target: {{ userhome }}/.tmux.conf
    - force: True
    - require:
      - file: byobu-config-{{ user }}
{% endfor %}
