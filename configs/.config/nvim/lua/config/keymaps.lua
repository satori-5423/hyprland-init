-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

local close = require("config.close")
local diagnostics = require("config.diagnostics")
local paste = require("config.paste")

-- Install the recorder; every keymap of this feature is defined below.
paste.setup()

-- q / <C-q>: close the current buffer or empty window / quit everything
map("n", "q", close.close, { desc = "Close Buffer" })
map("n", "<C-q>", "<cmd>qa<cr>", { desc = "Quit All" })

-- Q: record a macro
map("n", "Q", "q", { desc = "Record Macro" })

-- U: redo
map("n", "U", "<C-r>", { desc = "Redo" })

-- m / M: toggle a multicursor / follow mode
map({ "n", "x" }, "m", "Q", { desc = "Toggle Multicursor" })
map("n", "M", "q=", { desc = "Toggle Multicursor Follow" })

-- <Esc><Esc>: clear multicursors in the current buffer
map("n", "<Esc><Esc>", function()
    local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")
    vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end, { desc = "Clear Multicursors" })

-- <leader>cd: line diagnostics in an opaque float
map("n", "<leader>cd", diagnostics.float, { desc = "Line Diagnostics" })

-- R: rename the symbol under the cursor (same as <leader>cr)
map("n", "R", vim.lsp.buf.rename, { desc = "Rename" })

-- <M-Up> / <M-Down>: the same as <M-k> / <M-j>
map({ "n", "i", "v" }, "<M-Up>", "<M-k>", {
    desc = "Move Up",
    remap = true,
})
map({ "n", "i", "v" }, "<M-Down>", "<M-j>", {
    desc = "Move Down",
    remap = true,
})

-- <Esc><Esc>: leave the terminal and return to normal mode
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal Normal Mode" })

-- p / P: linewise paste that keeps the cursor column
map("n", "p", function()
    paste.paste("p")
end, { desc = "Paste" })

map("n", "P", function()
    paste.paste("P")
end, { desc = "Paste Before" })
