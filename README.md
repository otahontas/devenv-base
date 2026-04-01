# otahontas devenv base

Shared [devenv](https://devenv.sh) setup used in my public projects. Feel free to use and adapt it.

## Usage

Add this repo as an input in your `devenv.yaml` and import it:

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

Then configure the modules in your `devenv.nix`. For example:

```nix
_: {
  devenv-base.treefmt = {
    settings.global.excludes = [ "some-file" ];
    programs = {
      shfmt.enable = true;
      stylua.enable = true;
    };
  };
}
```
