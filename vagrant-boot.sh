#!/bin/sh

PATH=/usr/local/bin:$PATH

sudo apt-get update && sudo apt-get -y install ruby

type babushka || sudo sh -c "`curl https://babushka.me/up`" < /dev/null

mkdir -p /home/vagrant/.babushka/sources
ln -s /vagrant /home/vagrant/.babushka/sources/forge
chown -R vagrant /home/vagrant/.babushka

