#!/bin/sh

mkdir -p /home/vagrant/.babushka/sources
ln -s /vagrant /home/vagrant/.babushka/sources/forge
chown -R vagrant /home/vagrant/.babushka

sudo mkdir /root/.babushka/sources
sudo ln -s /vagrant /root/.babushka/sources/forge
