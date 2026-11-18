-- Close the current buffer, quitting instead when it is the last one. Required
-- from config/keymaps.lua.

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

---@return boolean Only one listed buffer is left
local function last()
  return #vim.fn.getbufinfo({ buflisted = 1 }) == 1
end

function M.close()
  -- pickers (e.g. the explorer) need their main window to open files in
  local keep_window = picker_main()
  if empty() then
    if not keep_window then
      vim.cmd("q")
    end
  elseif not keep_window and last() then
    vim.cmd("qa")
  else
    require("snacks").bufdelete()
  end
end

return M
