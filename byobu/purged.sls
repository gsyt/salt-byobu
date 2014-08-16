{% from "byobu/map.jinja" import byobu with context %}

{% set config = {
  'manage': salt['pillar.get']('byobu:config:manage', False),
  'users': salt['pillar.get']('byobu:config:users', []),
  'source': salt['pillar.get']('byobu:config:source', 'salt://byobu/conf/.byobu.conf'),
} %}

byobu.purged:
  pkg.purged:
    - name: {{ byobu.package }}
{% if config.manage %}
  {% if config.users %}
  require:
    {% for user in config.users %}
    - sls: byobu-purgeconfig-{{ user }}
    {% endfor %}
  {% endif %}

  {% for user in users %}
    {% set userhome = salt['user.info'](user).home %}
byobu-bash_profile-{{ user }}:
  file.managed:
    - name: {{ userhome }}/.bash_profile
    - user: {{ user }}
    - mode: 644

byobu-purgeconfig-{{ user }}:
  file.absent:
    - name: {{ userhome }}/.byobu
  {% endfor %}
{% endif %}
