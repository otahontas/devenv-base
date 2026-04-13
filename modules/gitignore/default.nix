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
        ".pi/mcp.json"
        ".pi/extensions/post-edit-hook.ts"
        ".pi/agent/AGENTS.md"
        "devenv.local.nix"
        "devenv.local.yaml"
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
