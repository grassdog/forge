#!/bin/sh

ssh root@forge 'source <(curl -s https://raw.github.com/grassdog/forge/master/bootstrap.sh)'
ssh root@forge 'sudo babushka forge:stage2'
ssh deploy@forge 'babushka sources --add forge https://github.com/grassdog/forge.git && babushka forge:stage3'
