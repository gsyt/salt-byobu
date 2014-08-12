salt-byobu
==========

Salt formula to set up and configure [byobu](http://byobu.co)

Requirements
------------
The following pillars are available for configuration:
  * byobu:pkg:salt['pillar.get']('os')
  * byobu:users
  * byobu:enable
Pacakge 'byobu' (or 'byobu:pkg:salt['pillar.get']('os')') must be available from configured repos

Usage
-----
Apply state 'byobu.install' to install tmux to target minions
Apply state 'byobu.purge' to remove tmux from target minions
State 'tmux' is provided as an alias for 'byobu.install'

Compatibility
-------------
Ubuntu 13.10, 14.04 and CentOS 6.x
