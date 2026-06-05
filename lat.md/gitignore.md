# Gitignore

Generates a writable `.gitignore` on shell entry. Configured in `modules/gitignore/default.nix`, written by `modules/gitignore/enter-shell.sh`.

## Base entries

`.devenv*`, `.gitignore`, `.nvim.lua`, `.pre-commit-config.yaml`, `.pi`, `devenv.local.nix`, `devenv.local.yaml`, `lat.md/.cache/*`, `!lat.md/.cache/lat_init.json`, `result`.

## Writable file

The file is written with mode 644. `enter-shell.sh` clears macOS `uchg` if an older generated `.gitignore` is still immutable.

## Options

`devenv-base.gitignore.extraEntries` appends patterns after the base entries. `devenv-base.modules.gitignore.enable = false` disables generation.

```nix
devenv-base.gitignore.extraEntries = [ "node_modules" "*.pyc" ];
devenv-base.modules.gitignore.enable = false;
```
