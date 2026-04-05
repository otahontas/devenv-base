---
id: db-xp5o
status: closed
deps: []
links: []
created: 2026-04-05T08:56:03Z
type: feature
priority: 2
assignee: Otto Ahoniemi
tags: [ready-for-development]
---

# Add pi.mcp.servers option to merge custom MCP servers into .pi/mcp.json

The AI module (modules/ai/) currently symlinks .pi/mcp.json to a static nix store file containing only mcp.devenv.sh. Projects that need additional MCP servers must break the symlink and manage the entire file themselves.

Add a `devenv-base.ai.mcp.extraServers` option (attribute set of JSON objects) that merges project-defined servers into the base config. This follows the same extension pattern used by gitignore (extraEntries) and nvim (extraLsps, extraConfig).

Files to modify:

- modules/ai/default.nix — add options, generate merged JSON, write it instead of symlinking
- modules/ai/enter-shell.sh — write file content instead of creating symlink (like gitignore does)
- modules/ai/mcp.json — keep as base config reference

API design (in project's devenv.nix):

```nix
{
  devenv-base.ai.mcp.extraServers = {
    playwright = {
      command = "npx";
      args = ["@playwright/mcp@latest"];
      lifecycle = "lazy";
    };
  };
}
```

The option type should be `lib.types.attrsOf lib.types.attrs` — raw attribute sets that get serialized to JSON as-is. No nix-level validation of MCP fields; pi validates at runtime. This keeps it simple: project writes JSON-like nix attrs, we merge them under mcpServers and write the file.

## Acceptance Criteria

1. devenv.nix can set devenv-base.ai.mcp.extraServers with additional MCP server definitions
2. Generated .pi/mcp.json contains base servers (mcp.devenv.sh) merged with any extra servers
3. When no extra servers are defined, .pi/mcp.json content is identical to current mcp.json (backwards compatible)
4. enter-shell.sh writes the file (like gitignore does) instead of creating a symlink
5. .pi/mcp.json is listed in .gitignore so generated content is not tracked
6. Option type is attrsOf attrs — no field-level nix validation, just serialize to JSON
7. Existing post-edit-hook.ts symlink behavior is unchanged
8. Tested in a worktree (not main branch): add a trivial MCP server via `devenv-base.ai.mcp.extraServers` in devenv.nix, run `devenv shell`, verify the generated .pi/mcp.json contains both base and extra servers, and confirm the extra server is listed as usable by pi agent (`mcp({ server: "<name>" })`)
9. Worktree cleaned up after test passes and solution is committed to main branch

## Notes

**2026-04-05T09:21:19Z**

Added devenv-base.ai.mcp.extraServers option (attrsOf attrs) to modules/ai/default.nix. Merges project-defined servers with base mcpServers and writes to .pi/mcp.json via install instead of symlink. Backwards compatible — identical output when no extra servers defined. Tested in worktree with test-server, verified merged JSON output.
