# AI tooling

Sets up pi (coding agent) integrations, generated AGENTS.md instructions, and the lat.md CLI.

## Symlink cleanup

Pi file modules use `safe_ln` instead of bare `ln -sfn`. Before creating a symlink, it removes the old one and any macOS " 2", " 3" duplicates.

## MCP server

`modules/ai/default.nix` symlinks `modules/ai/mcp.json` to `.pi/mcp.json` and `post-edit-hook.ts` to `.pi/extensions/post-edit-hook.ts` via `enter-shell.sh`.

The default server is `mcp.devenv.sh` (HTTP). Consumers add servers via `devenv-base.ai.mcp.extraServers`.

Claude Code is force-disabled. `devenv-base.modules.ai.enable = false` disables this module.

## Post-edit hook

`modules/ai/post-edit-hook.ts` is a pi extension that runs `prek` on files after any `edit` or `write` tool call. On failure, injects the failing hook names into the tool result so the LLM can fix issues before committing.

Invokes prek directly via `.devenv/profile/bin/prek` (avoids devenv shell overhead), and reads prek results from stdout (where prek writes them).

## AGENTS.md

`modules/agents-md/default.nix` writes generated `AGENTS.md` to the repo root via `enter-shell.sh`.

Contains base agent instructions for devenv and tickets only. It leaves lat.md workflow text to `lat init`, which edits repo-local agent instructions. Consumers append entries via `devenv-base.agents-md.extraEntries`. The script removes the old `.pi/agent/AGENTS.md` symlink if present. `devenv-base.modules.agents-md.enable = false` disables it.

## lat.md CLI

`modules/lat-md/default.nix` installs the `lat` CLI (v0.11.0) only. It has no `enterShell` hook and ships no Pi skill or extension templates.

`lat init` owns repo-local agent integration files such as `.pi/extensions/lat.ts`, `.pi/skills/lat-md/SKILL.md`, and lat.md workflow text in `AGENTS.md`. Keeping these files writable avoids Nix-store symlink collisions.

`devenv-base.modules.lat-md.enable = false` disables this module.

## Ticket tool

`modules/tk/default.nix` installs `tk` (v0.3.2) from [wedow/ticket](https://github.com/wedow/ticket). Provides CLI ticket and task management. `devenv-base.modules.tk.enable = false` disables it.
