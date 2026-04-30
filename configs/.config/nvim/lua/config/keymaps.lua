-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

local map = vim.keymap.set

map("n", "q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "Q", "q", { noremap = true, desc = "Record Macro" })

-- m (<leader>ac)
map({ "n", "v" }, "m", "<leader>ac", { remap = true, desc = "AI Chat Toggle" })

-- R (<leader>sr)
map({ "n", "v" }, "R", "<leader>sr", { remap = true, desc = "Search/Replace" })

-- f (<leader>ff)
map("n", "f", "<leader>ff", { remap = true, desc = "Find Files" })

-- F (<leader>sg)
map("n", "F", "<leader>sg", { remap = true, desc = "Live Grep" })

-- t (<leader>cs)
map("n", "t", "<leader>cs", { remap = true, desc = "Document Symbols" })

-- T (<leader>cd)
map("n", "T", "<leader>cd", { remap = true, desc = "Line Diagnostics" })
