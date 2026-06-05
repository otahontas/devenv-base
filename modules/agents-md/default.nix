{
  lib,
  pkgs,
  config,
  ...
}:
let
  moduleCfg = config.devenv-base.modules.agents-md;
  baseContent = builtins.readFile ./BASE_AGENTS.md;

  agentsMdContent =
    baseContent
    + (lib.optionalString (config.devenv-base.agents-md.extraEntries != [ ]) (
      "\n\n" + (lib.concatStringsSep "\n" config.devenv-base.agents-md.extraEntries) + "\n"
    ));
in
{
  options = {
    devenv-base.modules.agents-md.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable root AGENTS.md generation.";
    };

    devenv-base.agents-md.extraEntries = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf moduleCfg.enable {
    enterShell = "bash ${./enter-shell.sh} ${pkgs.writeText "agents-md" agentsMdContent}";
  };
}
