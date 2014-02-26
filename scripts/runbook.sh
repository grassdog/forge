#!/bin/sh

# Prodlike runbook

ssh root@forge   'source <(curl -s https://raw.github.com/grassdog/forge/master/bootstrap.sh)'
ssh foot@forge   'babushka sources --add forge https://github.com/grassdog/forge.git'
ssh root@forge   'sudo babushka forge:stage1'
ssh root@forge   'sudo babushka forge:stage2'
ssh deploy@forge 'babushka sources --add forge https://github.com/grassdog/forge.git'
ssh deploy@forge 'babushka forge:stage3'
