## Devenv

- This repo uses devenv for reproducible development environments
- Use `devenv shell -- <cmd>` to run commands in the dev environment
- Use `devenv tasks run <task>` to run defined tasks
- Use `devenv up` for process services
- Always use devenv to install tools and services or to define tasks.
- This devenv setup imports collection of extensible modules from `otahontas/devenv-base` repository.
  - When you need to customize something in devenv, check first how to use `devenv-base` and if it has a module that can be extended.

## Tickets and tasks

- Use `tk` CLI for ticket and task management. Run `tk help` for usage.
