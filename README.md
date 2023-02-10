# Build without bullshit.
![party-palpatine](https://user-images.githubusercontent.com/24665/174114761-42dfba9c-dcae-473b-8d83-aee59629f7aa.gif)

## 🏴‍☠️ Anti-features
* No installation
* No dependencies
* No overhead
* Script locally, or from anywhere using `curl`

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
  # $0 docker/install_check # Easily run an online script. See below.
}

all() {
  required && clean && build && deploy a b c # Continues chain on success.
}

online() {
  echo "Not found. Trying online..."
  # Run any script from your own online URL, including public or private github repositories! 
  { curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/$1.sh | bash --login -s -- ${@:2}; } && exit 1 || echo "Not found: '$1'"
}

[ "$#" -gt 0 ] || echo "Usage: doit task [optional args]" && { "$@" || online "$@"; } # 🟢 DO IT!
```
Save as `doit.sh` use `chmod +x ./doit.sh`

Do it: `./doit.sh`
Or, do a task: `./doit.sh build`

## Alias setup
* `echo "alias doit='./doit.sh'" >> ~/.bashrc`
* Open new shell.
* You can now use `doit`

## Snippets

### Private github repository, with fallback

```bash
online() {
  echo "Not found. Trying online..."
  { curl -fsSL https://YOUR_PRIVATE_GITHUB/main/$1.sh -H "Authorization: Token YOUR_PRIVATE_ACCESS_CODE" | bash --login -s -- ${@:2}; } || 
  { curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/$1.sh | bash --login -s -- ${@:2}; } && exit 1 || echo "Not found: '$1'"
}
```

### Offline only doit.sh
```bash
[ "$#" -gt 0 ] || echo "Usage: doit task [optional args]" && "$@" # 🟢 DO IT!
```

### Run external scripts from doit.sh
```bash
# Include local script.
. $(dirname $0)/helpers.sh

# Include online script.
. <(curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/helpers.sh)

# Just run online script.
curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/helpers.sh | bash

# Just run online script, using online() fallback.
$0 example
```

### Generate help message
```bash
# Hide functions by starting name with "_". You can still call them directly.
[ "$#" -gt 0 ] || printf "Usage:\n\t$0 ($(compgen -A function | grep '^[^_]' | paste -sd '|' -))\n"
```

## Helpful references

* [Bash Cheat Sheet](https://bertvv.github.io/cheat-sheets/Bash.html)
* [Bash Variable Parameter Expansions](https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html)
* [Why "pipefail"?](https://mobile.twitter.com/b0rk/status/1314345978963648524)
* [CURL guide](https://github.com/frizb/HackingWithCurl)

## FAQ

### For online scripts, why are `read` prompts broken ?
* `curl https://URL/script.sh | bash` breaks some user input prompts such as `read`. For workarounds, see [examples/choices](https://github.com/gnat/doit/blob/main/online/examples/choices.sh). Alternatively, you can consider switching online scripts to using arguments.

### For online scripts, why `bash --login` ?
* This simulates a user session, and is required to install certain apps such as Rootless Docker.

## Special thanks
* Forked from [do](https://github.com/8gears/do) and [run](https://github.com/icetbr/run)
* Inspired by [shell](https://github.com/netkiller/shell)

## Related tools

* [Task](http://taskfile.org/#/usage) a task runner / simpler Make alternative written in Go
* [Robo](https://github.com/tj/robo) Simple Go / YAML-based task runner for the team.
* [godo](https://github.com/go-godo/godo) godo is a task runner and file watcher for golang in the spirit of rake, gulp. It has kind of same name.
* [just](https://github.com/casey/just) A better make in rust.
