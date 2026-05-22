return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("codecompanion").setup({
        interactions = {
          chat = {
            adapter = "deepseek",
            opts = {
              system_prompt = function(ctx)
                return ctx.default_system_prompt .. require("agent_prompt").build(ctx)
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
            adapter = "deepseek",
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
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
}
