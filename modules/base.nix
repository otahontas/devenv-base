{
  pkgs,
  inputs,
  lib,
  ...
}:

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

  tk = pkgs.stdenvNoCC.mkDerivation {
    pname = "tk";
    version = "v0.3.2";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wedow/ticket/v0.3.2/ticket";
      hash = "sha256-QI8sET7MO8BxUHWTp4OG8bTMdDvmSRyenyYn79TZkCs=";
    };
    dontUnpack = true;
    installPhase = ''
      install -Dm755 $src $out/bin/tk
    '';
  };
in
{
  claude.code.enable = lib.mkDefault true;

  languages = {
    nix.enable = true;
    shell.enable = true;
  };

  enterShell = builtins.readFile ./enter-shell.sh;

  packages = [
    treefmtEval.config.build.wrapper
    tk
  ];

  git-hooks.hooks = {
    check-merge-conflicts.enable = true;
    deadnix.enable = true;
    detect-private-keys.enable = true;
    typos.enable = true;
    statix = {
      enable = true;
      entry = "${pkgs.statix}/bin/statix check --format errfmt --ignore .devenv,.devenv.*,.direnv .";
      pass_filenames = false;
    };

    shellcheck = {
      enable = true;
      entry = "${pkgs.shellcheck}/bin/shellcheck";
      files = "\\.sh$";
    };
    treefmt = {
      enable = true;
      package = treefmtEval.config.build.wrapper;
    };
    commitlint = {
      enable = true;
      stages = [ "commit-msg" ];
      entry = "${pkgs.commitlint}/bin/commitlint --extends @commitlint/config-conventional --edit";
    };
    gitleaks = {
      enable = true;
      entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged --verbose";
    };
  };
}
