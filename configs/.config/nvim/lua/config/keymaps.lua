-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

local textobject = require("config.textobject")
local paste = require("config.paste")

-- Install the recorders; every keymap of these two features is defined below.
textobject.setup()
paste.setup()

-- q: quit the current window
map("n", "q", "<cmd>q<cr>", { desc = "Quit" })

-- Q: record a macro
map("n", "Q", "q", { desc = "Record Macro" })

-- U: redo
map("n", "U", "<C-r>", { desc = "Redo" })

-- m / M: next / previous occurrence of the last used text object
map({ "n", "x" }, "m", function()
    textobject.cycle("next")
end, { desc = "Next Text Object" })

map({ "n", "x" }, "M", function()
    textobject.cycle("prev")
end, { desc = "Previous Text Object" })

-- iw / aw / iW / iB ...: the text objects that Vim resolves itself (mini.ai
-- hands single Latin letters back to Neovim) are recorded here. The mapping
-- returns its own keys, which without `remap` runs Vim's built-in text object,
-- so selecting them behaves exactly as before.
for _, ai_type in ipairs({ "a", "i" }) do
    for _, id in ipairs(textobject.builtin_ids) do
        map({ "x", "o" }, ai_type .. id, function()
            textobject.record(ai_type, id)
            return ai_type .. id
        end, { expr = true })
    end
end

-- R: rename the symbol under the cursor (same as <leader>cr)
map("n", "R", vim.lsp.buf.rename, { desc = "Rename" })

-- <C-q>: delete the current buffer, keeping the window layout
map("n", "<C-q>", function()
    Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- <Esc><Esc>: leave the terminal and return to normal mode
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal Normal Mode" })

-- p / P: linewise paste that keeps the cursor column
map("n", "p", function()
    paste.paste("p")
end, { desc = "Paste" })

map("n", "P", function()
    paste.paste("P")
end, { desc = "Paste Before" })
