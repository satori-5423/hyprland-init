-- Bufferline: hide the close icons, and label the offset above the sidebar
return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    opts.options.show_buffer_close_icons = false
    opts.options.show_close_icon = false
    for _, offset in ipairs(opts.options.offsets or {}) do
      if offset.filetype == "snacks_layout_box" then
        offset.text = ""
        offset.text_align = "left"
        offset.highlight = "Directory"
      end
    end
  end,
}
