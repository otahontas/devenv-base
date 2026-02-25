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
      "*.lock"
      ".devenv*"
      ".direnv/"
    ];
    programs = {
      nixfmt.enable = true;
      prettier.enable = true;
      taplo.enable = true;
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
  enterShell = ''
    root="$DEVENV_ROOT"
    if [ -z "$root" ]; then
      root="$PWD"
    fi

    gitignore="$root/.gitignore"
    touch "$gitignore"

    gitignore_block=$'# devenv generated files & local overrides\n.devenv*\n.direnv\n.pre-commit-config.yaml\n.claude/\n.mcp.json\n.pi/mcp.json\ndevenv.local.nix\ndevenv.local.yaml'

    if ! awk -v block="$gitignore_block" '
      BEGIN { content = "" }
      { content = content $0 ORS }
      END { exit(index(content, block) > 0 ? 0 : 1) }
    ' "$gitignore"; then
      tmp_gitignore="$(mktemp)"
      printf '%s\n' "$gitignore_block" > "$tmp_gitignore"
      if [ -s "$gitignore" ]; then
        printf '\n' >> "$tmp_gitignore"
        awk '1' "$gitignore" >> "$tmp_gitignore"
      fi
      mv "$tmp_gitignore" "$gitignore"
    fi

    if [ -f "$root/.mcp.json" ]; then
      mkdir -p "$root/.pi"
      ln -sfn "$root/.mcp.json" "$root/.pi/mcp.json"
    fi
  '';

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
