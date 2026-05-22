-- agent_prompt.lua
-- System prompt module for the AI agent.
-- Edit the `template` below to customize the agent's behavior.
-- Changes take effect after restarting Neovim or re-sourcing the file.

local template = [[Additional context:
Respond in the same language as the user's query. If you cannot determine the primary language (e.g., mixed languages), respond in the language indicated by the user's system locale: %s.
The user's current working directory is %s.
The current date is %s.
The user's Neovim version is %s.
The user is working on a %s machine. Please respond with system specific commands if applicable.

<exploration_instructions>
When exploring the project or searching for files:
1. NEVER use `file_search` with `**/*` blindly as it floods the context window with useless files.
2. If you need to explore the directory structure, use the `run_command` tool with commands like `ls -la` or `tree -L 2`.
   CRITICAL: When using `run_command`, you MUST provide the arguments using exactly this schema: `{"cmd": "your command here", "flag": null}`. Do NOT use `command` or leave the arguments empty.
3. By default, avoid exploring dependency or build directories (e.g., .git, .venv, node_modules, build, __pycache__). However, you MAY inspect them if you specifically need to verify the actual source code or API of a third-party dependency (e.g., checking for updated or deprecated methods).
4. Only inspect files and directories that are highly relevant to the user's request.
</exploration_instructions>]]

local M = {}

--- Build the additional context portion of the system prompt.
--- agent.lua prepends ctx.default_system_prompt to the result.
---@param ctx table CodeCompanion context object
---@return string
function M.build(ctx)
  return string.format(
    template,
    os.getenv("LANG") or os.getenv("LC_ALL") or os.getenv("LC_MESSAGES") or "en_US.UTF-8",
    ctx.cwd,
    ctx.date,
    ctx.nvim_version,
    ctx.os
  )
end

return M
