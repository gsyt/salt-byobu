{% from "byobu/map.jinja" import byobu with context %}

{% set package = {
  'upgrade': salt['pillar.get']('byobu:package:upgrade', False),
} %}

{% set config = {
  'manage': salt['pillar.get']('byobu:config:manage', False),
  'users': salt['pillar.get']('byobu:config:users', []),
  'source': salt['pillar.get']('byobu:config:source', 'salt://byobu/conf/tmux.conf'),
} %}

byobu.installed:
  require:
    - sls: byobu.install
    - sls: byobu.configure

byobu.install:
  pkg.{{ 'latest' if package.upgrade else 'installed' }}:
    - name: {{ byobu.package }}

byobu.configure:
  require:
    - sls: byobu.install
{% if config.manage %}
  {% if config.users %}
    {% for user in config.users %}
    - sls: byobu-tmuxconf-{{ user }}
    {% endfor %}

    {% for user in config.users %}
      {% if salt['user.info'](user) %}
        {% set userhome = salt['user.info'](user).home %}
byobu-tmuxconf-{{ user }}:
  file.managed:
    - name: {{ userhome }}/.byobu/.tmux.conf
    - source: {{ config.source }}
    - user: {{ user }}
    - group: {{ user }}
    - force: True
    - require:
      - file: byobu-config-{{ user }}

byobu-config-{{ user }}:
  file.directory:
    - name: {{ userhome }}/.byobu
    - user: {{ user }}
    - group: {{ user }}
    - dir_mode: 755
    - file_moe: 644
    - recurse:
      - user
      - group
      - mode
      {% endif %}
    {% endfor %}
  {% endif %}
{% endif %}
