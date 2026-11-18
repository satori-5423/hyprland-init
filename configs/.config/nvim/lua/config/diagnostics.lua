-- Line diagnostics in an opaque float window; the keymap lives in
-- config/keymaps.lua.

local M = {}

function M.float()
  local _, win = vim.diagnostic.open_float()
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end
  local winhl = vim.wo[win].winhighlight
  winhl = winhl ~= "" and winhl .. "," or ""
  vim.wo[win].winhighlight = winhl .. "Normal:DiagnosticFloatNormal"
end

return M
