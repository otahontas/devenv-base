# Gitignore

Generates a locked `.gitignore` on shell entry. Configured in `modules/gitignore/default.nix`, written by `modules/gitignore/enter-shell.sh`.

## Base entries

`.devenv*`, `.gitignore`, `.nvim.lua`, `.pre-commit-config.yaml`, `.pi`, `devenv.local.nix`, `devenv.local.yaml`, `lat.md/.cache/`, `result`.

## Lock mechanism

The file is set to mode 444 and flagged `uchg` (user immutable). This prevents accidental edits — the gitignore is managed by the module, not by hand.

## Option

`devenv-base.gitignore.extraEntries` — list of patterns appended after the base entries.

```nix
devenv-base.gitignore.extraEntries = [ "node_modules" "*.pyc" ];
```
