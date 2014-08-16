{% from "byobu/map.jinja" import byobu with context %}

{% set package = {
  'upgrade': salt['pillar.get']('byobu:package:upgrade', False),
} %}

{% set config = {
  'manage': salt['pillar.get']('byobu:config:manage', False),
  'users': salt['pillar.get']('byobu:config:users', []),
  'source': salt['pillar.get']('byobu:config:source', 'salt://byobu/conf/.byobu.conf'),
} %}

byobu.installed:
  pkg.latest:
    - name: {{ byobu.package }}
{% if config.manage %}
  {% if config.users %}
  require:
    {% for user in config.users %}
    - sls: byobu-byobuconf-{{ user }}
    {% endfor %}
  {% endif %}

  {% for user in users %}
    {% set userhome = salt['user.info'](user).home %}
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

byobu-byobuconf-{{ user }}:
  file.symlink:
    - name: {{ userhome }}/.byobu/.byobu.conf
    - target: {{ userhome }}/.byobu.conf
    - user: {{ user }}
    - group: {{ user }}
    - force: True
    - require:
      - file: byobu-config-{{ user }}
  {% endfor %}
{% endif %}
