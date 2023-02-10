#!/bin/bash
set -euo pipefail

read -p "❓ Do you want to choose yes or no? (y/n)" CHOICE
if [[ "$CHOICE" == "y" ]]; then
  echo "YES" 
elif [[ "$CHOICE" == "n" ]]; then
  echo "NO" 
fi

echo "Entered: $CHOICE"
echo "✅"
