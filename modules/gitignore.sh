#!/usr/bin/env bash

root="${DEVENV_ROOT:-$PWD}"
# shellcheck disable=SC1091
source "$root/modules/lib/managed-block.sh"

gitignore="$root/.gitignore"
gitignore_block=$'.devenv*\n.direnv\n.pre-commit-config.yaml\n.claude/\n.mcp.json\n.pi/mcp.json\ndevenv.local.nix\ndevenv.local.yaml\nresult'

ensure_block_at_top \
  "$gitignore" \
  "$gitignore_block" \
  "# devenv-base gitignore start" \
  "# devenv-base gitignore end"
