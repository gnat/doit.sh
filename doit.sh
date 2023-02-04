#!/bin/bash
set -euo pipefail # Error handling: -e stops on errors. -u stops on unset variables. -o pipefail stops pipelines on fail: https://mobile.twitter.com/b0rk/status/1314345978963648524

build() {
  echo "I am ${FUNCNAME[0]}ing" # doit build ... I am building
}

deploy() {
  echo "I am ${FUNCNAME[0]}ing with args $1 $2 $3" # doit deploy a b c ... I am deploying with args a b c
}

clean() { echo "I am ${FUNCNAME[0]}ing in just one line."; }

required() {
  which docker || { echo "Error: Docker is not installed"; exit 1; }
}

all() {
  required && clean && build # Continues chain on success.
}

# Run any script from your own URL.
remote() {
  echo "Not found: '$1' Trying remote..."
  { curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/ops/$1 ${@:2} | bash; } || echo "Not found: '$1'"
  # Add your own public or private repositories!
}

"$@" || remote $@ # DO IT.
[ "$#" -gt 0 ] || echo "Usage: $0 task [args]" # Or, default.
