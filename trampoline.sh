#!/bin/sh

set -e

install_ruby () {
  sudo apt-get update && sudo apt-get -y install ruby
}

ready_babushka () {
  type babushka || sh -c "`curl https://babushka.me/up`" < /dev/null
}

bootstrap () {
  NAME=$1
  # TODO May need to install source in root as well
  babushka sources --add ${NAME} https://github.com/grassdog/${NAME}.git
  sudo babushka ${NAME}:stage1
  babushka ${NAME}:bootstrap
}


install_ruby
ready_babushka
bootstrap forge
