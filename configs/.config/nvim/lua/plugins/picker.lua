-- <C-q>: quit everything, also from inside a picker
local function quit_all(picker)
  picker:close()
  vim.schedule(function()
    vim.cmd("qa")
  end)
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = {
        quit_all = quit_all,
      },
      win = {
        input = {
          keys = {
            ["<C-q>"] = { "quit_all", mode = { "n", "i" } },
          },
        },
        list = {
          keys = { ["<C-q>"] = "quit_all" },
        },
        preview = {
          keys = { ["<C-q>"] = "quit_all" },
        },
      },
    },
  },
}
