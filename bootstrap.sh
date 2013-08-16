#!/bin/sh

# TODO Refer to https://raw.github.com/quad/karen/master/trampoline.sh

PATH=/usr/local/bin:$PATH

sh -c "`curl https://babushka.me/up`" </dev/null

mkdir -p /home/vagrant/.babushka/sources
ln -s /vagrant /home/vagrant/.babushka/sources/custom
chown -R vagrant /home/vagrant/.babushka

# rehash
# TODO Add the deps repo
#babushka grassdog:Sinatra.tmbundle

# TODO Execute babushka dep
