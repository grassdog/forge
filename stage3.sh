#!/bin/sh

set -e

if [ ! -d "$HOME/.babushka/sources/forge" ]; then
  babushka sources --add forge https://github.com/grassdog/forge.git
fi

babushka forge:stage3

