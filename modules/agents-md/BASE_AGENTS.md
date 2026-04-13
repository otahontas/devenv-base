## This project

- Uses devenv for environment management. All tooling runs through `devenv shell`.
  - `devenv shell -- <cmd>` to run commands in the dev environment
  - `devenv tasks run <task>` to run defined tasks
  - `devenv up` for process services
- Uses `tk` CLI for ticket/task management. Run `tk help` for usage.
- Git hooks enforce: conventional commits, formatting (treefmt), secret detection (gitleaks), shellcheck, nix linting.
  - Format everything: `devenv tasks run nix:format`
- Post-edit hook auto-runs `prek` on changed files.
