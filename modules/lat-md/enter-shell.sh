#!/usr/bin/env bash
set -euo pipefail

skill_file="$1"
extension_file="$2"

root="${DEVENV_ROOT:-$PWD}"

mkdir -p "$root/.pi/skills/lat-md"
ln -sfn "$skill_file" "$root/.pi/skills/lat-md/SKILL.md"

mkdir -p "$root/.pi/extensions"
ln -sfn "$extension_file" "$root/.pi/extensions/lat.ts"
