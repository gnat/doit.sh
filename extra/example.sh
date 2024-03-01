#!/bin/bash
set -euo pipefail

echo "Hello world! You passed $# arguments."

# Nice pattern: Run child scripts!

#{ curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/example.sh | bash; } || echo "Not found."
#{ curl -fsSL https://raw.githubusercontent.com/gnat/doit/main/online/example.sh | bash; } || echo "Not found."
