#!/bin/bash
set -euo pipefail # Error handling: -e stops the script on errors # -u stops the script unset variables # -o pipefail stops pipelines on command fail: https://mobile.twitter.com/b0rk/status/1314345978963648524

build() {
  echo "I am ${FUNCNAME[0]}ing"
  command docker -v || (echo "Error: Docker is not installed"; exit 0) # Check for command.
}

deploy() {
  # >/do.sh deploy a b c
  echo "I am ${FUNCNAME[0]}ing with args '$1 $2 $3'" # I am deploying with Arg 1=a Arg 2=b and Arg 3=c
}

test() { echo "I am ${FUNCNAME[0]}ing in just one line."; }

_hidden() {
  echo "I am a hidden task because I start with _. You can still call me directly"
}

all() {
  build && test && deploy
}

"$@" # <- Do it.

[ "$#" -gt 0 ] || build # Default
