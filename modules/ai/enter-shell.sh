#!/usr/bin/env bash
set -euo pipefail

mcp_config="$1"
post_edit_hook="$2"

root="${DEVENV_ROOT:-$PWD}"
mkdir -p "$root/.pi/extensions"
[[ -e "$root/.pi/mcp.json" ]] || ln -sfn "$mcp_config" "$root/.pi/mcp.json"
[[ -e "$root/.pi/extensions/post-edit-hook.ts" ]] || ln -sfn "$post_edit_hook" "$root/.pi/extensions/post-edit-hook.ts"
