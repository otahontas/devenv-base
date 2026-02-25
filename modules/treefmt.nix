{ pkgs, inputs, ... }:
let
  treefmt-nix = import inputs.treefmt-nix;
  treefmtEval = treefmt-nix.evalModule pkgs {
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
    };
  };
in
{
  packages = [
    treefmtEval.config.build.wrapper
  ];

  git-hooks.hooks.treefmt = {
    enable = true;
    package = treefmtEval.config.build.wrapper;
  };
}
