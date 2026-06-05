{ lib, config, ... }:
{
  options.devenv-base.modules.languages.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable base Nix and shell language support.";
  };

  config = lib.mkIf config.devenv-base.modules.languages.enable {
    languages = {
      nix.enable = true;
      shell.enable = true;
    };
  };
}
