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
    {% if 1 == salt['cmd.retcode']('test -f ' ~ userhome ~ '/.byobu.conf') %}
  require:
      {% for user in config.users %}
        {% set userhome = salt['user.info'](user).home %}
    - sls: byobu-tmuxconf-{{ user }}

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

byobu-tmuxconf-{{ user }}:
  file.symlink:
    - name: {{ userhome }}/.byobu/.tmux.conf
    - target: {{ userhome }}/.tmux.conf
    - user: {{ user }}
    - group: {{ user }}
    - force: True
    - require:
      - file: byobu-config-{{ user }}
      {% endfor %}
    {% endif %}
  {% endif %}
{% endif %}
