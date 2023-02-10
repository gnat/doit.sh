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
  # $0 docker/install_check # Optionally run an online script. See below.
}

all() {
  required && clean && build && deploy a b c # Continues chain on success.
}

# Run any online script from your own URL.
online() {
  echo "Not found: '$1' Trying online..."
  # Add your own public or private repositories!
  # { curl -fsSL https://YOUR_PRIVATE_GITHUB/main/$1.sh -H "Authorization: Token YOUR_PRIVATE_ACCESS_CODE" | bash --login -s -- ${@:2}; } || 
  { curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/$1.sh | bash --login -s -- ${@:2}; } && exit 1 || echo "Not found: '$1'"
}

[ "$#" -gt 0 ] || echo "Usage: doit task [optional args]" && { "$@" || online "$@"; } # 🟢 DO IT!
