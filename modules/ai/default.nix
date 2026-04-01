{
  lib,
  pkgs,
  ...
}:
let
  mcpConfig = pkgs.writeText "mcp.json" (builtins.readFile ./mcp.json);
  postEditHook = pkgs.writeText "post-edit-hook.ts" (builtins.readFile ./post-edit-hook.ts);
in
{
  claude.code.enable = lib.mkForce false;

  enterShell = ''
    root="''${DEVENV_ROOT:-$PWD}"
    mkdir -p "$root/.pi/extensions"
    ln -sfn ${mcpConfig} "$root/.pi/mcp.json"
    ln -sfn ${postEditHook} "$root/.pi/extensions/post-edit-hook.ts"
  '';
}
