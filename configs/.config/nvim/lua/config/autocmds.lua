-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local fc_augroup = vim.api.nvim_create_augroup("FcitxGroup", { clear = true })

-- local auto_restore_im = true 
-- local saved_im = nil

vim.api.nvim_create_autocmd("InsertLeave", {
  group = fc_augroup,
  desc = "Switch to US layout on InsertLeave",
  callback = function()
    -- if auto_restore_im then
    --   local obj = vim.system({ "fcitx5-remote", "-n" }, { text = true }):wait()
    --   if obj.code == 0 then
    --     saved_im = vim.trim(obj.stdout)
    --   end
    -- end
    vim.system({ "fcitx5-remote", "-s", "keyboard-us" })
  end,
})

-- vim.api.nvim_create_autocmd("InsertEnter", {
--   group = fc_augroup,
--   desc = "Restore previous IM on InsertEnter",
--   callback = function()
--     if auto_restore_im and saved_im and saved_im ~= "" then
--       vim.system({ "fcitx5-remote", "-s", saved_im })
--     end
--   end,
-- })
