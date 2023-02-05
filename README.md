# Build without bullshit.
![party-palpatine](https://user-images.githubusercontent.com/24665/174114761-42dfba9c-dcae-473b-8d83-aee59629f7aa.gif)

## 🏴‍☠️ Anti-features
* No installation
* No dependencies
* No overhead
* Extend locally, or from anywhere using `curl`

Replace your convoluted build system with vanilla bash.

## Show me

```bash
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
  required && clean && build && deploy a b c # Continues chain on success.
}

# Optionally, run any script from your own URL.
extend() {
  echo "Not found: '$1' Trying remote..."
  { curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/extend/$1.sh | bash -s -- ${@:2}; } || echo "Not found: '$1'"
  # Add your own public or private repositories!
}

[ "$#" -gt 0 ] && { "$@" || extend "$@"; } || echo "Usage: $0 name [args]" # DO IT!
```
Save as `doit.sh` use `chmod +x ./doit.sh`

Do it: `./doit.sh`
Or, do a task: `./doit.sh build`

## Alias setup
* `echo "alias doit='./doit.sh'" >> ~/.bashrc`
* Open new shell.
* You can now use `doit`

## Nice snippets

### Generate help message
```bash
# Hide functions by starting name with "_". You can still call them directly.
[ "$#" -gt 0 ] || printf "Usage:\n\t$0 ($(compgen -A function | grep '^[^_]' | paste -sd '|' -))\n"
```

### Helper library
```bash
# Include file.
. $(dirname $0)/helpers.sh
```

### Timestamps
```bash
# Generate human readable, sortable file timestamp to the second.
timestamp() { echo "$(date -u +"%Y_%m_%d__%H_%M_%S")"; }
# EXAMPLE=$(timestamp); echo $EXAMPLE;
# 2021_05_04__10_31_12
```

## Helpful

* [Bash Cheat Sheet](https://bertvv.github.io/cheat-sheets/Bash.html)
* [Bash Variable Parameter Expansions](https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html)
* [Why "pipefail"?](https://mobile.twitter.com/b0rk/status/1314345978963648524)


## Original concept and special thanks
* Forked from [do](https://github.com/8gears/do) and [run](https://github.com/icetbr/run)
* Inspired by [shell](https://github.com/netkiller/shell)

## Related Tools

* [Task](http://taskfile.org/#/usage) a task runner / simpler Make alternative written in Go
* [Robo](https://github.com/tj/robo) Simple Go / YAML-based task runner for the team.
* [godo](https://github.com/go-godo/godo) godo is a task runner and file watcher for golang in the spirit of rake, gulp. It has kind of same name.
* [just](https://github.com/casey/just) A better make in rust.
