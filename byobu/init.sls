include:
  - epel
  - tmux
  - root

byobu:
  require:
    - sls: epel
    - sls: tmux
    - sls: byobu-install
    - sls: root-byobu-enable

byobu-install:
  pkg.latest:
    - name: byobu

root-byobu-enable:
  require:
    - sls: root-bash_profile
    - file: /root/.byobu
    - file: /root/.byobu/.tmux.conf
  file.append:
    - name: /root/.bash_profile
    - text: _byobu_sourced=1 . /usr/bin/byobu-launch

/root/.byobu:
  file.recurse:
    - name: /root/.byobu
    - source: salt://byobu/config
    - file_mode: 744
    - dir_mode: 755

/root/.byobu/.tmux.conf:
  file.symlink:
    - target: /root/.tmux.conf
    - force: True
    - require:
      - file: /root/.byobu
