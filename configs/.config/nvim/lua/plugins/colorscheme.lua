-- Tokyo Night theme: transparent background and brighter line numbers
return {
    "folke/tokyonight.nvim",
    opts = {
        transparent = true,
        styles = {
            sidebars = "transparent",
            floats = "transparent",
        },
        on_highlights = function(hl)
            hl.LineNr = { fg = "#DFDFDF" }
        end,
    },
}
