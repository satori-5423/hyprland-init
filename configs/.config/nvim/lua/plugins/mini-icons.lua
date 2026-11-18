-- Directory icons in blue; file icons keep their own colors
return {
  "nvim-mini/mini.icons",
  config = function(_, opts)
    ---@type table
    local icons = require("mini.icons")
    icons.setup(opts)
    local get = icons.get
    icons.get = function(cat, name, ...)
      local glyph, hl, default = get(cat, name, ...)
      if cat == "directory" and hl == "MiniIconsOrange" then
        hl = "MiniIconsBlue"
      end
      return glyph, hl, default
    end
  end,
}
