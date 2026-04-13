{
  lib,
  pkgs,
  config,
  ...
}:
let
  baseContent = builtins.readFile ./BASE_AGENTS.md;

  agentsMdContent =
    baseContent
    + (lib.optionalString (config.devenv-base.agents-md.extraEntries != [ ]) (
      "\n\n" + (lib.concatStringsSep "\n" config.devenv-base.agents-md.extraEntries) + "\n"
    ));
in
{
  options.devenv-base.agents-md.extraEntries = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    enterShell = "bash ${./enter-shell.sh} ${pkgs.writeText "agents-md" agentsMdContent}";
  };
}
