{ lib, ... }:
{
  claude.code.enable = lib.mkDefault true;
  claude.code.hooks.git-hooks-run.enable = lib.mkDefault false;
  enterShell = builtins.readFile ./ai.sh;
}
