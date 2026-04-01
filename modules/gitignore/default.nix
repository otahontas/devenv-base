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
        ".pi/mcp.json"
        ".pi/extensions/post-edit-hook.ts"
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
      enterShell = ''
        if ! cmp -s ${gitignoreFile} "$DEVENV_ROOT/.gitignore"; then
          chflags nouchg "$DEVENV_ROOT/.gitignore" 2>/dev/null || true
          install -m 444 ${gitignoreFile} "$DEVENV_ROOT/.gitignore"
          chflags uchg "$DEVENV_ROOT/.gitignore"
        fi
      '';
    };
}
