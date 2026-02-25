{ ... }:
{
  imports = [
    ./modules/languages.nix
    ./modules/treefmt.nix
    ./modules/tk.nix
    ./modules/git-hooks.nix
    ./modules/ai.nix
    ./modules/nvim.nix
    ./modules/gitignore.nix
  ];
}
