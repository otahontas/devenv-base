# Languages and formatters

Enables Nix, shell, and Lua by default. Formats on every commit via treefmt.

## Languages

`modules/languages/default.nix` enables `languages.nix`, `languages.shell`, and `languages.lua`.

## Formatters

`modules/treefmt/default.nix` imports [treefmt-nix](https://github.com/numtide/treefmt-nix) and enables four formatters:

- [nixfmt](https://github.com/NixOS/nixfmt) — Nix
- [prettier](https://github.com/prettier/prettier) — JS/TS/JSON/YAML/Markdown
- [shfmt](https://github.com/mvdan/sh) — shell
- [stylua](https://github.com/JohnnyMorganz/StyLua) — Lua

Lock files and `.devenv*` are excluded from formatting.

## Configuration

`devenv-base.treefmt` — attrset passed to treefmt-nix. Add formatters or change excludes:

```nix
devenv-base.treefmt = {
  settings.global.excludes = [ "some/generated/file" ];
  programs = {
    fish_indent.enable = true;
    black.enable = true;
  };
};
```

## Format task

`devenv tasks run nix:format` runs `treefmt -v` outside of git hooks.
