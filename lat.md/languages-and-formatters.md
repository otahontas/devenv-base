# Languages and formatters

Enables Nix and shell by default. Formats on every commit via treefmt.

## Languages

`modules/languages/default.nix` enables `languages.nix` and `languages.shell`. `devenv-base.modules.languages.enable = false` disables these defaults.

## Formatters

`modules/treefmt/default.nix` imports [treefmt-nix](https://github.com/numtide/treefmt-nix) and enables three formatters:

- [nixfmt](https://github.com/NixOS/nixfmt) — Nix
- [prettier](https://github.com/prettier/prettier) — JS/TS/JSON/YAML/Markdown
- [shfmt](https://github.com/mvdan/sh) — shell

Lock files (`*.lock`, `*.lockb`, `package-lock.json`, `pnpm-lock.yaml`) and `.devenv*` are excluded from formatting.

## Configuration

`devenv-base.treefmt` is an attrset passed to treefmt-nix. `devenv-base.modules.treefmt.enable = false` disables the package, task, and hook.

Add formatters or change excludes:

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

`devenv tasks run nix:format` runs `treefmt -v` outside of git hooks. The treefmt hook is added only when both `treefmt` and `git-hooks` modules are enabled.
