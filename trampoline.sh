#!/bin/sh

set -e

install_ruby () {
  sudo apt-get update && sudo apt-get -y install ruby
}

ready_babushka () {
  type babushka >/dev/null 2>&1 || sudo sh -c "`curl https://babushka.me/up`" < /dev/null
}

bootstrap () {
  NAME=$1
  babushka sources --add ${NAME} https://github.com/grassdog/${NAME}.git
  babushka ${NAME}:bootstrap
}

install_ruby
ready_babushka
bootstrap forge
