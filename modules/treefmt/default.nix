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
          "*.lockb"
          ".devenv*"
          "package-lock.json"
          "pnpm-lock.yaml"
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
  options = {
    devenv-base.modules.treefmt.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable treefmt packages, task, and git hook.";
    };

    devenv-base.treefmt = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf config.devenv-base.modules.treefmt.enable {
    packages = [
      treefmtEval.config.build.wrapper
    ];

    tasks."nix:format" = {
      description = "Run treefmt formatters";
      exec = "treefmt -v";
    };

    git-hooks.hooks.treefmt = lib.mkIf config.devenv-base.modules.git-hooks.enable {
      enable = true;
      package = treefmtEval.config.build.wrapper;
    };
  };
}
