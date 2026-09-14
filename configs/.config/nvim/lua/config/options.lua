-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.spelllang = { "en", "cjk" }
vim.g.autoformat = false

-- Kitty overlay (NVIM_OVERLAY=1): no statusline and no command line
if vim.env.NVIM_OVERLAY then
    vim.opt.laststatus = 0
    vim.opt.cmdheight = 0
end
