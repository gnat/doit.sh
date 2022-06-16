# Do it with vanilla bash.
![party-palpatine](https://user-images.githubusercontent.com/24665/174114761-42dfba9c-dcae-473b-8d83-aee59629f7aa.gif)

## Anti-features
* No installation
* No dependencies
* No overhead

## Show me

```bash
#!/bin/bash
set -euo pipefail # Error handling: -e stops the script on errors # -u stops the script unset variables # -o pipefail stops pipelines on command fail: https://mobile.twitter.com/b0rk/status/1314345978963648524

build() {
	echo "I am ${FUNCNAME[0]}ing"
	command docker -v || (echo "Error: Docker is not installed"; exit 0) # Check for command.
}

test() {
	echo "I am ${FUNCNAME[0]}ing in just one line."
}

deploy() {
	# >/do.sh deploy a b c
	echo "I am ${FUNCNAME[0]}ing with args '$1 $2 $3'" # I am deploying with Arg 1=a Arg 2=b and Arg 3=c
}

_hidden() { echo "I am a hidden task because I start with _. You can still call me directly"; }

all() {
	build && test && deploy
}

"$@" # <- Do it.

[ "$#" -gt 0 ] || build # Default
```

## Nice snippets

### Generate help
Print out a help message with all the available tasks in this build file if no tasks were selected.
```bash
[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
```

### Helper functions
```bash
source $(dirname $0)/helpers.sh # Include file.
```

### Timestamps
```bash
timestampHHMMSS() { echo "$(( ${1} / 3600 ))h $(( (${1} / 60) % 60 ))m $(( ${1} % 60 ))s"; }
```

## Helpful

* [Bash Cheat Sheet](https://bertvv.github.io/cheat-sheets/Bash.html)
* [Why "pipefail"?](https://mobile.twitter.com/b0rk/status/1314345978963648524)


## Original concept and special thanks
* Forked from [do](https://github.com/8gears/do) and [run](https://github.com/icetbr/run)
