-- Linewise paste that stays on the column where the text was yanked.
-- Required from config/keymaps.lua.

local M = {}

---@type integer|nil
local col = nil
---@type string|nil
local text = nil

---Remember the cursor column of the last linewise yank.
local function record()
    if vim.v.event.regtype:sub(1, 1) ~= "V" then
        col, text = nil, nil
        return
    end
    col = vim.api.nvim_win_get_cursor(0)[2]
    local contents = vim.v.event.regcontents
    if type(contents) == "table" then
        text = table.concat(contents, "\n")
    else
        text = contents
    end
end

---@param cmd string "p" or "P"
function M.paste(cmd)
    local reg = vim.fn.getreg(vim.v.register):gsub("\r?\n$", "")
    vim.cmd(("normal! %d%s"):format(vim.v.count1, cmd))
    if not col or reg ~= text then
        return
    end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    local last = math.max(#line - 1, 0)
    vim.api.nvim_win_set_cursor(0, { row, math.min(col, last) })
end

---Set up the `TextYankPost` recorder. The `p` / `P` keymaps live in
---`config/keymaps.lua`.
function M.setup()
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("PasteKeepCol", { clear = true }),
        desc = "Remember the column of a linewise yank",
        callback = record,
    })
end

return M
