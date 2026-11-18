-- Opening a directory shows the explorer, so the dashboard is not needed
local arg = vim.fn.argv(0) --[[@as string]]
local directory = vim.fn.argc(-1) == 1 and vim.fn.isdirectory(arg) == 1

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = not directory,
        preset = {
          header = "",
        },
      },
    },
  },
}
