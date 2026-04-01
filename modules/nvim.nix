{
  lib,
  config,
  ...
}:
{
  options.devenv-base.nvim = {
    extraLsps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config =
    let
      baseLsps = [
        "nixd"
        "bashls"
        "lua_ls"
      ];
      allLsps = baseLsps ++ config.devenv-base.nvim.extraLsps;
      lspLines = map (lsp: ''vim.lsp.enable("${lsp}")'') allLsps;
      lines = [
        "vim.cmd([[set runtimepath+=.nvim]])"
      ]
      ++ lspLines
      ++ lib.optional (config.devenv-base.nvim.extraConfig != "") config.devenv-base.nvim.extraConfig;
    in
    {
      files.".nvim.lua".text = lib.concatStringsSep "\n" lines + "\n";
    };
}
