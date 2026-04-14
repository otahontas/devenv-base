{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  treefmt-nix = import inputs.treefmt-nix;
  treefmtEval = treefmt-nix.evalModule pkgs {
    imports = [
      {
        projectRootFile = "devenv.nix";
        settings.global.excludes = [
          "*.lock"
          ".devenv*"
        ];
        programs = {
          nixfmt.enable = true;
          prettier.enable = true;
          shfmt.enable = true;
        };
      }
      config.devenv-base.treefmt
    ];
  };
in
{
  options.devenv-base.treefmt = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  config = {
    packages = [
      treefmtEval.config.build.wrapper
    ];

    tasks."nix:format" = {
      description = "Run treefmt formatters";
      exec = "treefmt -v";
    };

    git-hooks.hooks.treefmt = {
      enable = true;
      package = treefmtEval.config.build.wrapper;
    };
  };
}
