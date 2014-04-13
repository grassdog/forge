#!/usr/bin/env bash

# Script to setup a local Vagrant instance for developing babushka deps
vagrant up

# Get guest additions working properly
vagrant ssh -- 'sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions'
vagrant reload

# Need more swap for my Vagrant vm
vagrant ssh -- '/vagrant/scripts/add-swap.sh'

vagrant ssh -- 'type babushka >/dev/null 2>&1 || sudo sh -c "`curl https://babushka.me/up`" < /dev/null'

# By default link to local deps rather than use remotes
if [ "$1" != "remote" ]; then
  vagrant ssh -- '/vagrant/scripts/link-local-deps.sh'
else
  vagrant ssh -- 'sudo babushka sources --add forge https://github.com/grassdog/forge.git'
fi

vagrant ssh -- 'sudo babushka forge:stage1'
vagrant ssh -- 'sudo babushka forge:stage2'

# Tasks for the deploy user

if [ "$1" != "remote" ]; then
  ssh deploy@forge.dev "mkdir -p /home/deploy/.babushka/sources && ln -s /vagrant /home/deploy/.babushka/sources/forge"
else
  ssh deploy@forge.dev 'babushka sources --add forge https://github.com/grassdog/forge.git'
fi

# Note that this will ask for params so must be done interactively
# for s3cmd to be set up properly
ssh deploy@forge.dev 'babushka forge:stage3'

