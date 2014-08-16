salt-byobu
==========

Salt formula to set up and configure [byobu](http://byobu.co)

Parameters
------------
Please refer to example.pillar for a list of available pillar configuration options

Usage
-----
Apply state 'byobu.install' to install tmux to target minions
Apply state 'byobu.purge' to remove tmux from target minions
State 'tmux' is provided as an alias for 'byobu.install'

Compatibility
-------------
Ubuntu 13.10, 14.04 and CentOS 6.x
