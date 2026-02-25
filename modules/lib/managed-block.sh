#!/usr/bin/env bash

ensure_block_at_top() {
  local file="$1"
  local block="$2"
  local start_marker="$3"
  local end_marker="$4"

  touch "$file"

  local tmp_cleaned tmp_with_block
  tmp_cleaned="$(mktemp)"
  tmp_with_block="$(mktemp)"

  awk -v start_marker="$start_marker" -v end_marker="$end_marker" '
    BEGIN { skip = 0 }
    $0 == start_marker { skip = 1; next }
    $0 == end_marker { skip = 0; next }
    skip == 0 { print }
  ' "$file" >"$tmp_cleaned"

  # Strip leading blank lines so they don't accumulate across runs
  local tmp_stripped
  tmp_stripped="$(mktemp)"
  awk 'NF {found=1} found' "$tmp_cleaned" >"$tmp_stripped"
  mv "$tmp_stripped" "$tmp_cleaned"

  {
    printf '%s\n' "$start_marker"
    printf '%s\n' "$block"
    printf '%s\n' "$end_marker"
    if [ -s "$tmp_cleaned" ]; then
      printf '\n'
      awk '1' "$tmp_cleaned"
    fi
  } >"$tmp_with_block"

  if ! cmp -s "$file" "$tmp_with_block"; then
    mv "$tmp_with_block" "$file"
  fi

  if command -v trash >/dev/null 2>&1; then
    if [ -f "$tmp_cleaned" ]; then
      trash "$tmp_cleaned" >/dev/null 2>&1 || true
    fi

    if [ -f "$tmp_with_block" ]; then
      trash "$tmp_with_block" >/dev/null 2>&1 || true
    fi
  fi
}
