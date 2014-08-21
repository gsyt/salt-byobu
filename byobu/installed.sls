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
  pkg.{{ 'latest' if package.upgrade else 'installed' }}:
    - name: {{ byobu.package }}
{% if config.manage %}
  {% if config.users %}
  require:
    {% for user in config.users %}
      {% set userhome = salt['user.info'](user).home %}
    - sls: byobu-tmuxconf-{{ user }}
      {% endif %}
    {% endfor %}

    {% for user in config.users %}
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
