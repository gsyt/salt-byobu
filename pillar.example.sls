byobu:
  package:
    upgrade: False
  config:
    manage: False
    users:
      - root
    source: salt://byobyu/conf/.tmux.conf
  lookup:
    - package: byobu
