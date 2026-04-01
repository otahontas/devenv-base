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
          ".envrc"
          "*.lock"
          ".devenv*"
          ".direnv/"
        ];
        programs = {
          nixfmt.enable = true;
          prettier.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
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

    git-hooks.hooks.treefmt = {
      enable = true;
      package = treefmtEval.config.build.wrapper;
    };
  };
}
