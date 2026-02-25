_:
let
  managedBlockSh = "${./lib/managed-block.sh}";
in
{
  enterShell = builtins.replaceStrings [ "@DEVENV_BASE_MANAGED_BLOCK_SH@" ] [ managedBlockSh ] (
    builtins.readFile ./nvim.sh
  );
}
