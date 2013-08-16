#!/bin/sh

PATH=/usr/local/bin:$PATH

type babushka 2> /dev/null || sh -c "`curl https://babushka.me/up`" < /dev/null

mkdir -p /home/vagrant/.babushka/sources
ln -s /vagrant /home/vagrant/.babushka/sources/forge
chown -R vagrant /home/vagrant/.babushka

