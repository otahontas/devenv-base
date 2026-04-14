# Git hooks

Pre-commit hooks that run on every commit. Configured in `modules/git-hooks/default.nix`.

## Hooks

Nine hooks run on every commit: check-merge-conflicts, commitlint, deadnix, detect-private-keys, gitleaks, shellcheck, statix, treefmt, typos.

| Hook                  | Purpose                                                      |
| --------------------- | ------------------------------------------------------------ |
| check-merge-conflicts | Unresolved conflict markers                                  |
| deadnix               | Unused Nix bindings                                          |
| detect-private-keys   | Private keys in staged files                                 |
| shellcheck            | Shell script lint (fails on warnings and errors)             |
| typos                 | Spelling mistakes (excludes `.tickets/`)                     |
| commitlint            | [Conventional commits](https://www.conventionalcommits.org/) |
| gitleaks              | Secrets in staged files                                      |
| statix                | Nix anti-patterns (ignores `.devenv`, `.devenv.*`)           |
| treefmt               | Formats staged files                                         |
