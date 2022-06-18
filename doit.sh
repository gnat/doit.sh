#!/bin/bash
set -euo pipefail # Error handling: -e stops on errors. -u stops on unset variables. -o pipefail stops pipelines on fail: https://mobile.twitter.com/b0rk/status/1314345978963648524

build() {
  echo "I am ${FUNCNAME[0]}ing"
}

deploy() {
  # doit deploy a b c
  echo "I am ${FUNCNAME[0]}ing with args '$1 $2 $3'" # I am deploying with $1=a $2=b and $3=c
}

clean() { echo "I am ${FUNCNAME[0]}ing in just one line."; }

_preflight() {
  echo "I am a hidden task because I start with _. You can still call me directly"
  command docker -v || (echo "Error: Docker is not installed"; exit 1) # Check for command.
}

all() {
  _preflight && clean && build && deploy
}

"$@" # <- Do it.

[ "$#" -gt 0 ] || build # Default
