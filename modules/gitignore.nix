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
        ".direnv"
        ".gitignore"
        ".nvim.lua"
        ".pre-commit-config.yaml"
        ".claude/"
        ".mcp.json"
        ".pi/mcp.json"
        "devenv.local.nix"
        "devenv.local.yaml"
        "result"
      ];
      allEntries = baseEntries ++ config.devenv-base.gitignore.extraEntries;
      gitignoreFile = pkgs.writeText "gitignore" (lib.concatStringsSep "\n" allEntries + "\n");
    in
    {
      enterShell = ''
        if ! cmp -s ${gitignoreFile} "$DEVENV_ROOT/.gitignore"; then
          install -m 444 ${gitignoreFile} "$DEVENV_ROOT/.gitignore"
        fi
      '';
    };
}
