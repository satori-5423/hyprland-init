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
      interactions = {
        chat = {
          adapter = "deepseek_pro",
          agent = {
            tools = {
              ["files"] = {
                opts = {
                  allow_silent_execution = true,
                  ignored_directories = {
                    ".git",
                    "node_modules",
                    ".venv",
                    "env",
                    "__pycache__",
                    "target",
                    "build",
                  },
                },
              },
              ["ripgrep"] = {
                opts = {
                  allow_silent_execution = true,
                },
              },
              ["buffer_editor"] = {
                opts = {
                  allow_silent_execution = false,
                },
              },
              "shell",
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

      adapters = {
        http = {
          deepseek_pro = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "DeepSeek Reasoner",
              env = {
                url = "https://api.deepseek.com",
                api_key = vim.env.DEEPSEEK_API_KEY,
              },
              schema = {
                model = {
                  default = "deepseek-reasoner",
                },
                parameters = {
                  max_tokens = { default = 8192 },
                  temperature = { default = 1.0 },
                },
              },
            })
          end,

          deepseek_flash = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "DeepSeek Flash",
              env = {
                url = "https://api.deepseek.com",
                api_key = vim.env.DEEPSEEK_API_KEY,
              },
              schema = {
                model = {
                  default = "deepseek-chat",
                },
              },
            })
          end,
        },
      },

      opts = {
        send_code = true,
        use_diagnostic_context = false,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Agent" })
  end,
}
