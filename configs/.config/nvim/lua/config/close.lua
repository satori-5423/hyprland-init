-- Close the current buffer, or the current window when it only shows an empty
-- buffer. Required from config/keymaps.lua.

local M = {}

---@return boolean No name, not modified, and a single empty line
local function empty()
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].modified then
        return false
    end
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return #lines == 1 and lines[1] == ""
end

---@return boolean The current window is the one a picker opens files in
local function picker_main()
    local win = vim.api.nvim_get_current_win()
    for _, picker in ipairs(require("snacks.picker").get()) do
        if not picker.closed and picker.main == win then
            return true
        end
    end
    return false
end

function M.close()
    if not empty() then
        require("snacks").bufdelete()
        return
    end
    -- pickers (e.g. the explorer) need their main window to open files in
    if picker_main() then
        return
    end
    vim.cmd("q")
end

return M
