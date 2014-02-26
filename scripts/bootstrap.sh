#!/bin/sh

set -e

type babushka >/dev/null 2>&1 || sudo sh -c "`curl https://babushka.me/up`" < /dev/null

