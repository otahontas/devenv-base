{
  lib,
  pkgs,
  config,
  ...
}:
let
  version = "0.11.0";
  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/lat.md/-/lat.md-${version}.tgz";
    hash = "sha256-Q342aMq1f4Fdm+xtuWdX0TtcZQX452LhmM6CzU1/ao8=";
  };
  lat-md = pkgs.buildNpmPackage {
    pname = "lat-md";
    inherit version src;
    sourceRoot = "package";
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';
    npmDepsHash = "sha256-1n3XaT63b+rFl2KsS4mUz/Y4ko6+bit+a3etHk1r0C4=";
    dontBuild = true;
  };
in
{
  options.devenv-base.modules.lat-md.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable lat.md CLI.";
  };

  config = lib.mkIf config.devenv-base.modules.lat-md.enable {
    packages = [
      lat-md
    ];
  };
}
