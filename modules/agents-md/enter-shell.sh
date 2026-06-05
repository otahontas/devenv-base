#!/usr/bin/env bash
set -euo pipefail

agents_md_file="$1"
root="${DEVENV_ROOT:-$PWD}"
target="$root/AGENTS.md"
old_target="$root/.pi/agent/AGENTS.md"

[ -L "$old_target" ] && unlink "$old_target"
[ -L "$target" ] && unlink "$target"

if ! cmp -s "$agents_md_file" "$target"; then
  install -m 644 "$agents_md_file" "$target"
else
  chmod 644 "$target"
fi
