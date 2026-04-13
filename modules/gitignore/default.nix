{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.devenv-base.gitignore.extraEntries = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config =
    let
      baseEntries = [
        ".devenv*"
        ".gitignore"
        ".nvim.lua"
        ".pre-commit-config.yaml"
        ".pi"
        "devenv.local.nix"
        "devenv.local.yaml"
        "lat.md/.cache/"
        "result"
      ];
      gitignoreFile = pkgs.writeText "gitignore" (
        "### devenv-base gitignore\n"
        + (lib.concatStringsSep "\n" baseEntries)
        + "\n"
        + "### end\n"
        + (lib.optionalString (config.devenv-base.gitignore.extraEntries != [ ]) (
          "\n" + lib.concatStringsSep "\n" config.devenv-base.gitignore.extraEntries + "\n"
        ))
      );
    in
    {
      enterShell = "bash ${./enter-shell.sh} ${gitignoreFile}";
    };
}
