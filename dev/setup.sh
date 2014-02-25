#!/bin/sh

# Script to set up for local Vagrant development

# mkdir -p /home/vagrant/.babushka/sources
# ln -s /vagrant /home/vagrant/.babushka/sources/forge
# chown -R vagrant /home/vagrant/.babushka

# sudo mkdir -p /root/.babushka/sources
# sudo ln -s /vagrant /root/.babushka/sources/forge

vagrant ssh -- 'sudo source <(curl -s https://raw.github.com/grassdog/forge/master/bootstrap.sh)'
