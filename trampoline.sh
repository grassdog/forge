#!/bin/sh

set -e

ready_babushka () {
  type babushka >/dev/null 2>&1 || sudo sh -c "`curl https://babushka.me/up`" < /dev/null
}

bootstrap () {
  NAME=$1
  babushka sources --add ${NAME} https://github.com/grassdog/${NAME}.git
  babushka ${NAME}:stage1
  babushka ${NAME}:bootstrap
}

ready_babushka
bootstrap forge
