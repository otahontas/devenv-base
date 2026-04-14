# AI tooling

Sets up pi (coding agent) integrations: MCP server, post-edit hook, AGENTS.md, and lat.md extension.

## MCP server

`modules/ai/default.nix` symlinks `modules/ai/mcp.json` to `.pi/mcp.json`. The default server is `mcp.devenv.sh` (HTTP). Consumers add servers via `devenv-base.ai.mcp.extraServers`.

Claude Code is force-disabled.

## Post-edit hook

`modules/ai/post-edit-hook.ts` is a pi extension that runs `prek` on files after any `edit` or `write` tool call. On failure, injects the failing hook names into the tool result so the LLM can fix issues before committing.

Uses `devenv shell --quiet` to suppress setup noise, and reads prek results from stdout (where prek writes them).

## AGENTS.md

`modules/agents-md/default.nix` symlinks `modules/agents-md/BASE_AGENTS.md` to `.pi/agent/AGENTS.md`. Contains base agent instructions for devenv, tickets, and lat.md workflow. Consumers append entries via `devenv-base.agents-md.extraEntries`.

## lat.md extension

`modules/lat-md/default.nix` installs the `lat` CLI (v0.11.0) and symlinks two files into `.pi/`:

- `modules/lat-md/SKILL.md` → `.pi/skills/lat-md/SKILL.md` — authoring guide for lat.md files
- `modules/lat-md/lat.ts` → `.pi/extensions/lat.ts` — pi extension that registers lat tools (`lat_search`, `lat_section`, `lat_locate`, `lat_check`, `lat_expand`, `lat_refs`) and injects a pre-work reminder and post-work `lat check`.

## Ticket tool

`modules/tk/default.nix` installs `tk` (v0.3.2) from [wedow/ticket](https://github.com/wedow/ticket). Provides CLI ticket and task management.
