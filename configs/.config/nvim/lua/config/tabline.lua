-- Label the bufferline offset above the sidebar with the browsed directory.
-- The explorer hooks live in plugins/explorer.lua.

local M = {}

---The bufferline offset for the picker sidebar
local function offset()
  local ok, config = pcall(require, "bufferline.config")
  if not ok then
    return nil
  end
  for _, item in ipairs(config.options.offsets or {}) do
    if item.filetype == "snacks_layout_box" then
      return item
    end
  end
end

---@param cwd string Directory shown in the explorer
function M.set(cwd)
  local item = offset()
  if not item then
    return
  end
  item.text = vim.fn.fnamemodify(cwd, ":~")
  vim.cmd("redrawtabline")
end

function M.clear()
  local item = offset()
  if not item then
    return
  end
  item.text = ""
  vim.cmd("redrawtabline")
end

return M
