{
  lib,
  pkgs,
  config,
  ...
}:
let
  moduleCfg = config.devenv-base.modules.ai;
  aiCfg = config.devenv-base.ai;
  baseServers = (builtins.fromJSON (builtins.readFile ./mcp.json)).mcpServers;
  merged = baseServers // aiCfg.mcp.extraServers;
  mcpConfig = pkgs.writeText "mcp.json" (builtins.toJSON { mcpServers = merged; });
  postEditHook = pkgs.writeText "post-edit-hook.ts" (builtins.readFile ./post-edit-hook.ts);
in
{
  options = {
    devenv-base.modules.ai.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable pi MCP config and post-edit hook setup.";
    };

    devenv-base.ai.mcp.extraServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf moduleCfg.enable {
    claude.code.enable = lib.mkForce false;

    enterShell = "bash ${./enter-shell.sh} ${mcpConfig} ${postEditHook}";
  };
}
