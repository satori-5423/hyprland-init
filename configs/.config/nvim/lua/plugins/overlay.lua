if vim.env.NVIM_OVERLAY then
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.opt.laststatus = 0
            vim.opt.cmdheight = 0
        end,
    })

    -- Disable lualine
    return {
        { "nvim-lualine/lualine.nvim", enabled = false },
    }
end

return {}
