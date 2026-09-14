-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local no_name_augroup =
    vim.api.nvim_create_augroup("CleanupNoName", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = no_name_augroup,
    desc = "Wipe leftover empty [No Name] buffers when a real file is opened",
    callback = function()
        if vim.api.nvim_buf_get_name(0) == "" then
            return
        end
        local visible = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            visible[vim.api.nvim_win_get_buf(win)] = true
        end
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            local is_unused = vim.api.nvim_buf_is_valid(bufnr)
                and vim.bo[bufnr].buflisted
                and vim.api.nvim_buf_get_name(bufnr) == ""
                and vim.bo[bufnr].buftype == ""
                and not vim.bo[bufnr].modified
                and not visible[bufnr]
                and vim.api.nvim_buf_line_count(bufnr) <= 1
            if is_unused then
                pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
            end
        end
    end,
})

-- Switch the input method back to the US layout when leaving insert mode
if vim.fn.executable("fcitx5-remote") == 1 then
    local fcitx_augroup =
        vim.api.nvim_create_augroup("FcitxGroup", { clear = true })

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = fcitx_augroup,
        desc = "Switch to US layout",
        callback = function()
            vim.system({ "fcitx5-remote", "-s", "keyboard-us" })
        end,
    })
end
