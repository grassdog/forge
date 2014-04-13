#!/bin/sh

set -e

# Prodlike runbook

ssh root@forge   'type babushka >/dev/null 2>&1 || sudo sh -c "`curl https://babushka.me/up`" < /dev/null'
ssh foot@forge   'babushka sources --add forge https://github.com/grassdog/forge.git'
ssh root@forge   'sudo babushka forge:stage1'
ssh root@forge   'sudo babushka forge:stage2'
ssh deploy@forge 'babushka sources --add forge https://github.com/grassdog/forge.git'
ssh deploy@forge 'babushka forge:stage3'
