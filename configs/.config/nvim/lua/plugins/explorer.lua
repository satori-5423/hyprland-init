-- Snacks explorer: hide the search box, keep the tree open on <Esc>
local function esc_input(picker)
  if picker.input:get() == "" then
    picker:focus("list")
    return
  end
  picker.input:set("", "")
  picker:find({ refresh = false })
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          on_show = function(picker)
            require("config.tabline").set(picker:cwd())
          end,
          on_close = function()
            require("config.tabline").clear()
          end,
          layout = {
            preset = "sidebar",
            preview = false,
            auto_hide = { "input" },
          },
          win = {
            input = {
              keys = {
                ["<Esc>"] = {
                  "explorer_esc",
                  mode = { "n", "i" },
                },
              },
            },
            list = {
              keys = { ["<Esc>"] = "explorer_keep_open" },
            },
          },
          actions = {
            explorer_esc = esc_input,
            explorer_keep_open = function() end,
          },
        },
      },
    },
  },
}
