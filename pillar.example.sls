groups:
  - wheel
  - sudo
  - users

users:
  root:
    present: True
    password: xxxxxxx
    shell: /bin/bash
    groups:
      - root
    sshpubkeys:
      - AAAA...
      - AAAA...
