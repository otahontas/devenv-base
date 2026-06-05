#!/usr/bin/env bash
set -euo pipefail

gitignore_file="$1"
target="$DEVENV_ROOT/.gitignore"

chflags nouchg "$target" 2>/dev/null || true

if ! cmp -s "$gitignore_file" "$target"; then
  install -m 644 "$gitignore_file" "$target"
else
  chmod 644 "$target"
fi
