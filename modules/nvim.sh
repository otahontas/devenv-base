#!/usr/bin/env bash

root="${DEVENV_ROOT:-$PWD}"
# shellcheck disable=SC1091
source "$root/modules/lib/managed-block.sh"

nvim_lua="$root/.nvim.lua"
nvim_block=$'vim.cmd([[set runtimepath+=.nvim]])\nvim.lsp.enable("nixd")\nvim.lsp.enable("bashls")'

ensure_block_at_top \
  "$nvim_lua" \
  "$nvim_block" \
  "-- devenv-base nvim setup start" \
  "-- devenv-base nvim setup end"
