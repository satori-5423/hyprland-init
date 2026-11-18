-- Rebuild the explorer when its editor window is closed behind its back
-- (`:wq`, `ZQ`, `:bd`, ...). Required from config/autocmds.lua.

local M = {}

local healing = false

---@type table<integer, integer> Last buffer shown per window
local shown = {}

---@return any Explorer that lost the window it opens files in
local function orphan()
  for _, picker in ipairs(require("snacks.picker").get()) do
    if not picker.closed then
      local buf = vim.api.nvim_win_get_buf(picker.main)
      if vim.bo[buf].filetype == "snacks_layout_box" then
        return picker
      end
    end
  end
end

---@return integer Windows that are not floating
local function nonfloat()
  local n = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      n = n + 1
    end
  end
  return n
end

---@param skip integer Buffer to leave out
---@return integer? Most recently used listed file buffer, other than `skip`
local function recent(skip)
  local best
  for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    local file = vim.bo[info.bufnr].buftype == ""
    if
      file
      and info.bufnr ~= skip
      and (not best or info.lastused > best.used)
    then
      best = { buf = info.bufnr, used = info.lastused }
    end
  end
  return best and best.buf
end

---@return boolean Nvim is on its way out (`v:exiting` is NIL otherwise)
local function exiting()
  return type(vim.v.exiting) == "number" and vim.v.exiting ~= 0
end

---@param closed integer? Buffer the closed window was showing
local function refill(closed)
  -- only when the sidebar is left alone in the window meant for the editor
  if nonfloat() ~= 1 then
    return
  end
  local other = recent(closed or -1)
  if other then
    vim.api.nvim_win_set_buf(0, other)
  else
    vim.cmd("enew")
  end
  -- closing the window again would need `!` when there are changes
  if closed and vim.api.nvim_buf_is_valid(closed) then
    pcall(vim.api.nvim_buf_delete, closed, { force = true })
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("ExplorerHeal", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = group,
    desc = "Remember the buffer of each window",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      shown[win] = vim.api.nvim_get_current_buf()
    end,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    desc = "Rebuild the explorer when its editor window is closed",
    callback = function(args)
      local win = tonumber(args.match)
      local closed
      if win then
        closed = shown[win]
        shown[win] = nil
      end
      if healing or exiting() then
        return
      end
      vim.schedule(function()
        local picker = orphan()
        if not picker then
          return
        end
        healing = true
        local cwd = picker:cwd()
        picker:close()
        vim.wait(100)
        refill(closed)
        vim.wait(100)
        require("snacks").explorer({ cwd = cwd })
        healing = false
      end)
    end,
  })
end

return M
