-- Cycle to the next / previous occurrence of the last used text object (m / M).
-- The keymaps for it live in config/keymaps.lua.

local M = {}

---@type table|nil { ai_type = "a", id = "f" } of the last used text object
local last = nil

---Text objects that Vim resolves itself, because mini.ai hands single Latin
---letters back to Neovim (see `H.get_default_textobject()`). Cycling those means
---moving with Vim and re-selecting.
---  `motion`    – the step motion (`is` / `as` are motion approximations)
---  `pair`      – block delimiters; only a brace with a matching one counts
---  `paragraph` – no Vim primitive for it, scanned line wise
local BUILTIN = {
    w = { motion = { next = "w", prev = "b" } },
    W = { motion = { next = "W", prev = "B" } },
    s = { motion = { next = ")", prev = "(" } },
    B = { pair = { "{", "}" } },
    p = { paragraph = true },
}

---@param ai_type string
---@param id string
function M.record(ai_type, id)
    last = { ai_type = ai_type, id = id }
end

---mini.ai does not wrap around the buffer, so the search has to cover all of it.
---@return integer
local function n_lines()
    return math.max(vim.api.nvim_buf_line_count(0), 50)
end

---@return table|nil Region of the current Visual selection
local function selection()
    if not vim.fn.mode():find("[vV\22]") then
        return nil
    end
    local a, b = vim.fn.getpos("v"), vim.fn.getpos(".")
    local from, to = { line = a[2], col = a[3] }, { line = b[2], col = b[3] }
    if to.line < from.line or (to.line == from.line and to.col < from.col) then
        from, to = to, from
    end
    return { from = from, to = to }
end

---Empty region before the first / after the last text object, used as the
---reference for the wrapping search.
---@param kind "next"|"prev"
---@return table
local function edge(kind)
    if kind == "next" then
        return { from = { line = 1, col = 1 } }
    end
    local n = vim.api.nvim_buf_line_count(0)
    local text = vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1] or ""
    return { from = { line = n, col = math.max(#text, 1) } }
end

---Move to the first (`next`) / last (`prev`) non-blank character of the buffer.
---@param kind "next"|"prev"
---@return boolean found
local function goto_edge(kind)
    vim.cmd(kind == "next" and "normal! gg0" or "normal! G$")
    -- `c` counts a match under the cursor: it stays put when already non-blank
    return vim.fn.search("\\S", kind == "next" and "cW" or "cbW") > 0
end

---@param line integer
---@return boolean Blank line (nothing but white space)
local function blank(line)
    return vim.fn.getline(line):find("%S") == nil
end

---Move to the first line of the next / previous paragraph, following `ip` / `ap`
---(where a line of white space counts as a boundary too).
---@param kind "next"|"prev"
---@return boolean moved
local function goto_paragraph(kind)
    local n = vim.api.nvim_buf_line_count(0)
    local l = vim.fn.line(".")
    if kind == "next" then
        while l <= n and not blank(l) do
            l = l + 1
        end
        while l <= n and blank(l) do
            l = l + 1
        end
    else
        while l > 1 and not blank(l - 1) do
            l = l - 1
        end
        l = l - 1
        while l >= 1 and blank(l) do
            l = l - 1
        end
        while l > 1 and not blank(l - 1) do
            l = l - 1
        end
    end
    if l < 1 or l > n then
        return false
    end
    vim.fn.cursor(l, 1)
    return true
end

---Step to the next / previous opening delimiter that has a matching closing one:
---`iB` gives a degenerate region for a lone `{`, and `searchpairpos(..., 'nW')`
---tells them apart without moving the cursor. `c` counts a match under the cursor
---and is dropped after the first candidate so that the walk always advances.
---@param spec table One entry of `BUILTIN`
---@param flags string Flags for `search()`, e.g. `"W"`, `"bW"`, `"cW"`
---@return boolean found
local function find_pair(spec, flags)
    local open, close = spec.pair[1], spec.pair[2]
    local first = true
    while true do
        local cur_flags = first and flags or (flags:gsub("c", ""))
        first = false
        if vim.fn.search("\\V" .. open, cur_flags) == 0 then
            return false
        end
        if vim.fn.searchpairpos(open, "", close, "nW")[1] > 0 then
            return true
        end
    end
end

---Is there a text object of this kind in the buffer at all? `search()` with `'n'`
---cannot walk over the candidates, so the scan starts at the top and the view is
---put back afterwards.
---@param spec table One entry of `BUILTIN`
---@return boolean
local function exists(spec)
    if spec.pair == nil then
        return vim.fn.search("\\S", "nw") > 0
    end
    -- A pair needs both delimiters: rules out most empty cases without moving
    local open, close = spec.pair[1], spec.pair[2]
    if
        vim.fn.search("\\V" .. open, "nw") == 0
        or vim.fn.search("\\V" .. close, "nw") == 0
    then
        return false
    end
    local view = vim.fn.winsaveview()
    vim.cmd("normal! gg0")
    local found = find_pair(spec, "cW") -- `c`: a `{` in the first column counts
    vim.fn.winrestview(view)
    return found
end

---@param kind "next"|"prev"
local function cycle_builtin(kind)
    local spec = BUILTIN[last.id]
    -- Nothing of this kind here: return before mode, cursor or view are touched
    if not exists(spec) then
        return
    end
    local save_cursor, save_view = vim.fn.getpos("."), vim.fn.winsaveview()
    -- `v` plus a text object leaves the cursor at the object end, where the steps
    -- below start. A `pair` step starts at the start instead, so that it sees the
    -- object's own delimiter. Without a selection, the object under the cursor is
    -- selected once to learn where its ends are.
    local region = selection()
    if region == nil then
        vim.cmd("normal! v" .. last.ai_type .. last.id)
        region = selection()
    end
    vim.cmd("normal! \28\14") -- back to Normal mode, like mini.ai does
    if region then
        local pos = (kind == "prev" and spec.pair) and region.from or region.to
        vim.fn.cursor(pos.line, pos.col)
    end
    local flags = kind == "next" and "W" or "bW"
    local moved
    if spec.paragraph then
        moved = goto_paragraph(kind)
    else
        -- Backwards needs two steps, the first only reaches the object's start.
        -- Blank landings are stepped over: `)` / `(` stop there between sentences.
        local steps = kind == "next" and 1 or (region and 2 or 1)
        moved = true
        for i = 1, steps + 3 do
            if i > steps and not blank(vim.fn.line(".")) then
                break
            end
            local pos = vim.fn.getpos(".")
            if spec.pair then
                moved = find_pair(spec, flags)
            else
                vim.cmd("normal! " .. spec.motion[kind])
                moved = not vim.deep_equal(pos, vim.fn.getpos("."))
            end
            if not moved then
                break
            end
        end
    end
    if not moved then
        -- At the buffer edge: continue from the opposite end
        local found = goto_edge(kind)
        if spec.pair then
            found = find_pair(spec, kind == "next" and "cW" or "cbW")
        end
        if not found then
            -- Safety net, unreachable while `exists()` and these searches agree
            vim.fn.setpos(".", save_cursor)
            vim.fn.winrestview(save_view)
            return
        end
    end
    vim.cmd("normal! zv")
    vim.cmd("normal! v" .. last.ai_type .. last.id)
end

---Select the next / previous occurrence of the last used text object.
---@param kind "next"|"prev"
function M.cycle(kind)
    if not last then
        return
    end
    if BUILTIN[last.id] then
        cycle_builtin(kind)
        return
    end
    local mini = require("mini.ai")
    local opts = { n_lines = n_lines(), search_method = kind }
    opts.reference_region = selection()
        or { from = { line = vim.fn.line("."), col = vim.fn.col(".") } }
    -- A failed search echoes a message, so silence both attempts; restore the
    -- flag even if a resolver raises.
    local silent = mini.config.silent
    mini.config.silent = true
    local ok, err = xpcall(function()
        mini.select_textobject(last.ai_type, last.id, opts)
        if not vim.fn.mode():find("[vV\22]") then
            -- Nothing left in that direction: wrap around from the buffer edge
            opts.reference_region = edge(kind)
            opts.search_method = kind == "next" and "cover_or_next" or "cover_or_prev"
            mini.select_textobject(last.ai_type, last.id, opts)
        end
    end, debug.traceback)
    mini.config.silent = silent
    if not ok then
        error(err, 0)
    end
end

---Record the text objects that mini.ai resolves. Wraps the public
---`MiniAi.find_textobject`, which `MiniAi.select_textobject` calls internally;
---a lookup that resolves nothing does not count as used.
local watched = false
local function watch()
    if watched then
        return
    end
    local mini = require("mini.ai")
    local find = mini.find_textobject
    mini.find_textobject = function(ai_type, id, opts)
        local region = find(ai_type, id, opts)
        if region ~= nil then
            M.record(ai_type, id)
        end
        return region
    end
    watched = true
end

---@type string[] Ids of the text objects that Vim resolves itself
M.builtin_ids = vim.tbl_keys(BUILTIN)
table.sort(M.builtin_ids)

---Install the recorder; the `m` / `M` keymaps live in `config/keymaps.lua`.
function M.setup()
    watch()
end

return M
