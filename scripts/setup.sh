#!/bin/bash

# Script to setup a local Vagrant instance for developing babushka deps

vagrant up

# Need more swap for my Vagrant vm
vagrant ssh -- '/vagrant/scripts/add-swap.sh'

# By default link to local deps rather than use remotes
if [ "$1" != "remote" ]; then
  vagrant ssh -- '/vagrant/scripts/link-local-deps.sh'
fi

vagrant ssh -- 'source <(curl -s https://raw.github.com/grassdog/forge/master/scripts/bootstrap.sh)'

vagrant ssh -- 'sudo babushka sources --add forge https://github.com/grassdog/forge.git'
vagrant ssh -- 'sudo babushka forge:stage1'
vagrant ssh -- 'sudo babushka forge:stage2'

# Tasks for the deploy user

ssh deploy@forge.dev 'babushka sources --add forge https://github.com/grassdog/forge.git'
# Note that this will ask for params so must be done interactively
# for s3cmd to be set up properly
ssh deploy@forge.dev 'babushka forge:stage3'

