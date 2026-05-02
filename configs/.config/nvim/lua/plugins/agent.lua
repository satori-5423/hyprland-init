return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        http = {
          deepseek_pro = function()
            return require("codecompanion.adapters").extend("deepseek", {
              name = "deepseek_pro",
              schema = {
                model = {
                  default = "deepseek-v4-pro",
                },
              },
            })
          end,
          deepseek_flash = function()
            return require("codecompanion.adapters").extend("deepseek", {
              name = "deepseek_flash",
              schema = {
                model = {
                  default = "deepseek-v4-flash",
                },
              },
            })
          end,
        },
      },

      interactions = {
        chat = {
          adapter = "deepseek_flash",
          opts = {
            system_prompt = function(ctx)
              return ctx.default_system_prompt
                .. string.format(
                  [[Additional context:
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
</exploration_instructions>]],
                  os.getenv("LANG") or os.getenv("LC_ALL") or os.getenv("LC_MESSAGES") or "en_US.UTF-8",
                  ctx.cwd,
                  ctx.date,
                  ctx.nvim_version,
                  ctx.os
                )
            end,
          },
          tools = {
            ["read_file"] = {
              opts = {
                require_approval_before = false,
              },
            },
            ["grep_search"] = {
              opts = {
                require_approval_before = false,
              },
            },
            ["file_search"] = {
              opts = {
                require_approval_before = false,
              },
            },
          },
        },
        inline = {
          adapter = "deepseek_flash",
        },
      },

      display = {
        action_palette = { width = 95, height = 10 },
        chat = {
          window = {
            layout = "float",
            relative = "editor",
            width = 0.8,
            height = 0.8,
            row = math.floor((vim.o.lines - (vim.o.lines * 0.8)) / 2) - 1,
            border = "rounded",
          },
          keymaps = {
            close = {
              modes = { n = "q" },
              callback = function(chat)
                chat:toggle()
              end,
              description = "Close Chat",
            },
          },
        },
      },

      opts = {
        send_code = true,
        use_diagnostic_context = false,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat" })
  end,
}
