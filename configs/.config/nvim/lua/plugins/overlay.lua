-- Kitty overlay (NVIM_OVERLAY=1): no statusline, see config/options.lua
return {
    {
        "nvim-lualine/lualine.nvim",
        enabled = not vim.env.NVIM_OVERLAY,
    },
}
