/**
 * Post-edit hook extension
 *
 * Runs prek hooks on the specific file after any file-mutating tool call.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const FILE_MUTATING_TOOLS = new Set(["edit", "write"]);

export default function (pi: ExtensionAPI) {
  pi.on("tool_result", async (event, ctx) => {
    if (!FILE_MUTATING_TOOLS.has(event.toolName.toLowerCase())) return;
    if (event.isError) return;

    const filePath = (event.input as any)?.path;
    if (!filePath) return;

    const devenvRoot = process.env.DEVENV_ROOT ?? ctx.cwd;
    const result = await pi.exec(
      "bash",
      [
        "-c",
        `cd "${devenvRoot}" && devenv shell -- prek run --files "${filePath}"`,
      ],
      {
        timeout: 30000,
      },
    );

    if (result.code !== 0 && result.stderr) {
      ctx.ui.notify(`prek failed: ${result.stderr.slice(0, 200)}`, "warn");
    }
  });
}
