#!/usr/bin/env bash
set -euo pipefail

agents_md_file="$1"

mkdir -p "${DEVENV_ROOT}/.pi/agent"
[[ -e "${DEVENV_ROOT}/.pi/agent/AGENTS.md" ]] || ln -sfn "$agents_md_file" "${DEVENV_ROOT}/.pi/agent/AGENTS.md"
