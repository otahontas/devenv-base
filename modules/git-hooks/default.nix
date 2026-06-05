{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.devenv-base.modules.git-hooks.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable devenv-base git hooks.";
  };

  config = lib.mkIf config.devenv-base.modules.git-hooks.enable {
    git-hooks.hooks = {
      check-merge-conflicts.enable = true;
      deadnix.enable = true;
      detect-private-keys.enable = true;
      shellcheck = {
        enable = true;
        entry = "${pkgs.shellcheck}/bin/shellcheck --severity=warning";
      };
      typos = {
        enable = true;
        excludes = [ "\\.tickets/" ];
      };
      commitlint = {
        enable = true;
        stages = [ "commit-msg" ];
        entry = "${pkgs.commitlint}/bin/commitlint --extends @commitlint/config-conventional --edit";
      };
      gitleaks = {
        enable = true;
        entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged --verbose";
      };
      statix = {
        enable = true;
        entry = "${pkgs.statix}/bin/statix check --format errfmt --ignore .devenv,.devenv.* .";
        pass_filenames = false;
      };
    };
  };
}
