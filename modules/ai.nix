{ lib, ... }:
{
  claude.code.enable = lib.mkDefault true;
  claude.code.mcpServers = lib.mkDefault { };
  enterShell = builtins.readFile ./ai.sh;
}
