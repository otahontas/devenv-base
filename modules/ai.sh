#!/usr/bin/env bash

root="${DEVENV_ROOT:-$PWD}"

if [ -f "$root/.mcp.json" ]; then
  mkdir -p "$root/.pi"
  ln -sfn "$root/.mcp.json" "$root/.pi/mcp.json"
fi
