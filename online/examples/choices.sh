#!/bin/bash
set -euo pipefail

# PLEASE NOTE: cURL to bash pipes (curl "..." | bash) will break user input prompts such as read!
#
# To fix, load this type of script using one of the alternatives:
#
# A) Include.
# . <(curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/$1.sh)
# 
# B) Just run.
# bash --login -s -c "$(curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/$1.sh)" -- ${@:2}
#
# C) Run, and allow chaining:
# { _SCRIPT=$(curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/$1.sh) && bash --login -s -c "$_SCRIPT" -- ${@:2}; } || echo "Not found!"

read -p "❓ Do you want to choose yes or no? (y/n)" CHOICE
if [[ "$CHOICE" == "y" ]]; then
  echo "YES" 
elif [[ "$CHOICE" == "n" ]]; then
  echo "NO" 
fi

echo "Entered: $CHOICE"
echo "✅"


