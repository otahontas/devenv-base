# devenv-base

Shared [devenv](https://devenv.sh) setup. Bundles my base choice of languages, formatters, git hooks, neovim config, gitignore management, and ai tooling.

## Prerequisites

- [devenv](https://devenv.sh) (duh)

## Install

### 1. Create `devenv.yaml`

**All four inputs are required.** `treefmt-nix` and `git-hooks` are peer dependencies consumed directly by devenv-base.

```yaml
inputs:
  devenv-base:
    url: github:otahontas/devenv-base
    flake: false
  git-hooks:
    url: github:cachix/git-hooks.nix
    inputs:
      nixpkgs:
        follows: nixpkgs
  nixpkgs:
    url: github:cachix/devenv-nixpkgs/rolling
  treefmt-nix:
    url: github:numtide/treefmt-nix
    flake: false
imports:
  - devenv-base
```

### 2. Create `devenv.nix`

Uses all defaults:

```nix
_: {}
```

### 3. Enter the shell

```sh
devenv shell
```

(or by autoactivation)

## Defaults

### Languages

Nix, shell, and Lua via `languages.*.enable`.

### Formatters (treefmt)

[nixfmt](https://github.com/NixOS/nixfmt), [prettier](https://github.com/prettier/prettier), [shfmt](https://github.com/mvdan/sh), and [stylua](https://github.com/JohnnyMorganz/StyLua) run on every commit via a treefmt pre-commit hook.

### Git hooks

These hooks run on every commit:

- **check-merge-conflicts** — unresolved conflict markers
- **deadnix** — unused Nix stuff
- **detect-private-keys** — private keys
- **shellcheck** — shell script lint
- **typos** — spelling mistakes
- **commitlint** — [conventional commits](https://www.conventionalcommits.org/)
- **gitleaks** — secrets in staged files
- **statix** — Nix anti-patterns

### Neovim

A `.nvim.lua` with LSPs for Nix (nixd), Shell (bashls), and Lua (lua_ls).

### Gitignore

A read-only, locked (`chflags uchg`) `.gitignore` covers the base-devenv stuff.

### ai tooling

- `.pi/mcp.json` symlinked with devenv MCP server (`mcp.devenv.sh`)
- `.pi/extensions/post-edit-hook.ts` symlinked — runs `prek` after AI edits

### `tk` ticket tool

[`tk`](https://github.com/wedow/ticket) for ai markdown ticket setup.

## Adding a new language

Add the language, a formatter, and an LSP to your `devenv.nix`:

```nix
_: {
  # 1. Enable the language (adds python to PATH, venv support, etc.)
  languages.python.enable = true;

  # 2. Add a formatter
  devenv-base.treefmt.programs.black.enable = true;

  # 3. Add an LSP
  devenv-base.nvim.extraLsps = [ "pyright" ];
}
```

Swap `python`/`black`/`pyright` for your language. See [devenv language options](https://devenv.sh/reference/options/#languages) and [treefmt-nix programs](https://github.com/numtide/treefmt-nix/tree/master/programs).

## Configuration reference

### `devenv-base.treefmt` (attrset)

Passed to treefmt-nix. Add formatters or change excludes:

```nix
devenv-base.treefmt = {
  settings.global.excludes = [
    "some/generated/file"
  ];
  programs = {
    fish_indent.enable = true;
    black.enable = true;
  };
};
```

### `devenv-base.nvim.extraLsps` (list of strings)

LSP servers added to `.nvim.lua`:

```nix
devenv-base.nvim.extraLsps = [ "pyright" "ts_ls" ];
```

### `devenv-base.nvim.extraConfig` (string)

Neovim config appended after LSP setup:

```nix
devenv-base.nvim.extraConfig = ''
  vim.opt.tabstop = 4
'';
```

### `devenv-base.gitignore.extraEntries` (list of strings)

Patterns appended to `.gitignore`:

```nix
devenv-base.gitignore.extraEntries = [
  "node_modules"
  "*.pyc"
];
```

## GitHub Actions

A reusable composite action installs Nix, configures the Cachix devenv cache, and installs devenv:

```yaml
- uses: otahontas/devenv-base/.github/actions/setup-devenv@main
```

Full example:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: otahontas/devenv-base/.github/actions/setup-devenv@main
      - run: devenv ci
```
