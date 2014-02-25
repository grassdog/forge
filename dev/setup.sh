#!/bin/sh

# Script to setup a local Vagrant environment from scratch

vagrant destroy
vagrant up
vagrant ssh -- 'source <(curl -s https://raw.github.com/grassdog/forge/master/bootstrap.sh)'
# Need more swap for my vm
vagrant ssh -- '/vagrant/dev/add-swap.sh'
vagrant ssh -- 'sudo babushka sources --add forge https://github.com/grassdog/forge.git'
vagrant ssh -- 'sudo babushka forge:stage2'

# Note that this will ask for params so must be done interactively
# for s3cmd to be set up properly
ssh deploy@forge.dev 'babushka sources --add forge https://github.com/grassdog/forge.git'
ssh deploy@forge.dev 'babushka forge:stage3'

