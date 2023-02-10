#!/bin/bash
set -euo pipefail

SCRIPT=$(curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/extend/example/choice.sh) && bash --login -s -i -c "$SCRIPT" -- ${@:2} || echo "Not found!"

echo "✅"
