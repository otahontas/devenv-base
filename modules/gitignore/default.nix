{
  lib,
  pkgs,
  config,
  ...
}:
let
  moduleCfg = config.devenv-base.modules.gitignore;
  gitignoreCfg = config.devenv-base.gitignore;
in
{
  options = {
    devenv-base.modules.gitignore.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable .gitignore generation.";
    };

    devenv-base.gitignore.extraEntries = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf moduleCfg.enable (
    let
      baseEntries = [
        ".devenv*"
        ".gitignore"
        ".nvim.lua"
        ".pre-commit-config.yaml"
        ".pi"
        "devenv.local.nix"
        "devenv.local.yaml"
        "lat.md/.cache/*"
        "!lat.md/.cache/lat_init.json"
        "result"
      ];
      gitignoreFile = pkgs.writeText "gitignore" (
        "### devenv-base gitignore\n"
        + (lib.concatStringsSep "\n" baseEntries)
        + "\n"
        + "### end\n"
        + (lib.optionalString (gitignoreCfg.extraEntries != [ ]) (
          "\n" + lib.concatStringsSep "\n" gitignoreCfg.extraEntries + "\n"
        ))
      );
    in
    {
      enterShell = "bash ${./enter-shell.sh} ${gitignoreFile}";
    }
  );
}
