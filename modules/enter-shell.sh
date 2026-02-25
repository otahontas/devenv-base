#!/usr/bin/env bash

root="${DEVENV_ROOT:-$PWD}"

gitignore="$root/.gitignore"
touch "$gitignore"

gitignore_block=$'# devenv generated files & local overrides\n.devenv*\n.direnv\n.pre-commit-config.yaml\n.claude/\n.mcp.json\n.pi/mcp.json\ndevenv.local.nix\ndevenv.local.yaml'

if ! awk -v block="$gitignore_block" '
  BEGIN { content = "" }
  { content = content $0 ORS }
  END { exit(index(content, block) > 0 ? 0 : 1) }
' "$gitignore"; then
  tmp_gitignore="$(mktemp)"
  printf '%s\n' "$gitignore_block" >"$tmp_gitignore"
  if [ -s "$gitignore" ]; then
    printf '\n' >>"$tmp_gitignore"
    awk '1' "$gitignore" >>"$tmp_gitignore"
  fi
  mv "$tmp_gitignore" "$gitignore"
fi

if [ -f "$root/.mcp.json" ]; then
  mkdir -p "$root/.pi"
  ln -sfn "$root/.mcp.json" "$root/.pi/mcp.json"
fi
