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

  enterShell = "bash ${./enter-shell.sh} ${mcpConfig} ${postEditHook}";
}
