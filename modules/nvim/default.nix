{
  lib,
  config,
  ...
}:
let
  moduleCfg = config.devenv-base.modules.nvim;
  nvimCfg = config.devenv-base.nvim;
in
{
  options = {
    devenv-base.modules.nvim.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable .nvim.lua generation.";
    };

    devenv-base.nvim = {
      extraLsps = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };
  };

  config = lib.mkIf moduleCfg.enable (
    let
      baseLsps = [
        "nixd"
        "bashls"
      ];
      baseLines = [
        "vim.cmd([[set runtimepath+=.nvim]])"
      ]
      ++ map (lsp: ''vim.lsp.enable("${lsp}")'') baseLsps;
      extraLines =
        map (lsp: ''vim.lsp.enable("${lsp}")'') nvimCfg.extraLsps
        ++ lib.optional (nvimCfg.extraConfig != "") nvimCfg.extraConfig;
      content =
        "-- ### devenv-base nvim\n"
        + lib.concatStringsSep "\n" baseLines
        + "\n"
        + "-- ### end\n"
        + lib.optionalString (extraLines != [ ]) ("\n" + lib.concatStringsSep "\n" extraLines + "\n");
    in
    {
      files.".nvim.lua".text = content;
    }
  );
}
