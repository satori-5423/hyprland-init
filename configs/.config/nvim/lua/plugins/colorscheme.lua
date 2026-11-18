-- Tokyo Night theme: transparent background and brighter line numbers
return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(hl, c)
      hl.LineNr = { fg = "#dfdfdf" }
      hl.SnacksPickerInputBorder = { fg = "#82aaff" }
      hl.SnacksPickerInputTitle = { fg = "#82aaff" }
      hl.DiagnosticFloatNormal = { fg = c.fg_float, bg = c.bg_popup }
    end,
  },
}
