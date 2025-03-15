# Build without bullshit.
![party-palpatine](https://user-images.githubusercontent.com/24665/174114761-42dfba9c-dcae-473b-8d83-aee59629f7aa.gif)

## 🏴‍☠️ Anti-features
* No installation
* No dependencies
* No overhead

Replace your convoluted build system with vanilla bash.

## 👁️ What does it look like?

```bash
#!/bin/bash
set -euo pipefail # Error handling: -e stops on errors. -u stops on unset variables. -o pipefail stops pipelines on fail: https://mobile.twitter.com/b0rk/status/1314345978963648524

build() {
  echo "I am ${FUNCNAME[0]}ing" # doit build ... I am building
}

deploy() {
  echo "I am ${FUNCNAME[0]}ing with args $1 $2 $3" # doit deploy a b c ... I am deploying with args a b c
}

clean() { echo "I am ${FUNCNAME[0]}ing in just one line." ;}

required() {
  which docker || { echo "Error: Docker is not installed"; exit 1 ;}
}

all() {
  required && clean && build && deploy a b c # Continues chain on success.
}

[ "$#" -gt 0 ] || echo "Use: doit task [options]" && "$@" # 🟢 DO IT!
```
Save as `doit.sh` use `chmod +x ./doit.sh`

Do task: `./doit.sh build`

## ♻️ Alias setup
* `echo "alias doit='./doit.sh'" >> ~/.bashrc`
* Open new shell.
* You can now use `doit`

## ✂️ Snippets

#### Help
```bash
[ "$#" -gt 0 ] && { "$@"; } || echo -e "Use: $0 task [options]\nTasks:"; printf "\t%s\n" $(compgen -A function) # 🟢 DO IT!
```

#### Help with fancypants comments
```bash
help() { echo -e "Use: $0 task [options]\nTasks:"; awk '/^[a-zA-Z_][a-zA-Z0-9_]*\(\)/ {print $1}' "$0" | sed 's/()//' | while read -r task; do printf "\t$task \t \e[92m $(grep "^$task()" "$0" | head -n1 | grep -oP '(?<=\x23 ).*[^\\n]') \e[0m \n"; done | column -t -s $'\t' ;} # 👁️ Show all tasks.

[ "$#" -gt 0 ] && { "$@"; } || help  # 🟢 DO IT!
```

#### Local script include
```bash
. $(dirname $0)/helpers.sh
```

#### Online scripts
Run script from URL, including public or private github repositories! 
```bash
required() { # Check dependencies.
  which docker || { echo "Error: Docker is not installed"; exit 1 ;}
  $0 docker/install_check # Easily run an online script.
}

online() {
  echo "🌐 Find online? (y/n)"; read CHOICE && [[ $CHOICE = [yY] ]] || (echo "Cancelled"; exit 1)
  { curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/extra/$1.sh | bash --login -s -- ${@:2}; } && exit 1 || echo "Not found: '$1'"
}

[ "$#" -gt 0 ] || echo -e "Use: $0 command [options]" && { "$@" || online "$@"; } # 🟢 DO IT!
```

## ✂️ Online Snippets

```bash
# Run online script.
curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/extra/helpers.sh | bash

# Import online script.
. <(curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/extra/helpers.sh)
```

#### Use private github
```bash
online() {
  URL="https://YOUR_PRIVATE_GITHUB/main/$1.sh"
  echo "🌐 Find online? (y/n) ($URL) "; read CHOICE && [[ $CHOICE = [yY] ]] || (echo "Cancelled"; exit 1)
  { curl -fsSL "$URL -H 'Authorization: Token YOUR_PRIVATE_ACCESS_CODE'" | bash --login -s -- ${@:2}; } ||
  echo "Not found: '$1'"
}
```

#### Use private github, with fallbacks
```bash
online() {
  URLS=(
    "https://YOUR_PRIVATE_GITHUB/main/$1.sh -H 'Authorization: Token YOUR_PRIVATE_ACCESS_CODE'"
    "https://raw.githubusercontent.com/gnat/doit/main/extra/$1.sh"
    "https://raw.githubusercontent.com/gnat/doit_again/main/extra/$1.sh"
  )
  for URL in "${URLS[@]}"; do
    echo "🌐 Find online? (y/n) (${URL%% *}) "; read CHOICE && [[ $CHOICE = [yY] ]] || { echo "Skipping"; continue; }
    { curl -fsSL "$URL" | bash --login -s -- ${@:2}; } && exit # Success
  done
  echo "Not found: '$1'"
}
```

## 📚 Helpful references

* [Bash Manual](https://www.gnu.org/software/bash/manual/html_node/index.html)
* [Bash Source Code](https://github.com/bminor/bash)
* [Bash Cheat Sheet](https://bertvv.github.io/cheat-sheets/Bash.html)
* [Bash Variable Parameter Expansions](https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html)
* [Shell Explainer](https://explainshell.com/)
* [Why "pipefail"?](https://mobile.twitter.com/b0rk/status/1314345978963648524)
* [CURL guide](https://github.com/frizb/HackingWithCurl)

## 🔍 Technical FAQ

#### For online scripts, why are `read` prompts not working ?
* `curl https://URL/script.sh | bash` breaks some user input prompts such as `read`. For workarounds, see [examples/choices](https://github.com/gnat/doit/blob/main/extra/examples/choices.sh). If you do not want to use a different convention for calling online scripts, you may consider passing script arguments only.

#### For online scripts, why `bash --login` ?
* This simulates a user session, and is required to install certain apps such as Rootless Docker.

## ✨ Special thanks
* Forked from [do](https://github.com/8gears/do) and [run](https://github.com/icetbr/run)
* Inspired by [shell](https://github.com/netkiller/shell)

## 👀 Related tools

* [Task](http://taskfile.org/#/usage) a task runner / simpler Make alternative written in Go
* [Robo](https://github.com/tj/robo) Simple Go / YAML-based task runner for the team.
* [godo](https://github.com/go-godo/godo) godo is a task runner and file watcher for golang in the spirit of rake, gulp. It has kind of same name.
* [just](https://github.com/casey/just) A better make in rust.
