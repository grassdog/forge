#!/bin/sh

# Link up my deps locally in the Vagrant box

mkdir -p /home/vagrant/.babushka/sources
ln -s /vagrant /home/vagrant/.babushka/sources/forge
chown -R vagrant /home/vagrant/.babushka

sudo mkdir -p /root/.babushka/sources
sudo ln -s /vagrant /root/.babushka/sources/forge

