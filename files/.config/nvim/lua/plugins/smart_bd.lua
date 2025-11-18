return {
  {
    "folke/which-key.nvim",
    lazy = true,
    keys = {
      {
        "<C-x>",
        function()
          local current_buf_nr = vim.api.nvim_get_current_buf()
          local bufs = vim.api.nvim_list_bufs()
          local next_target_buf = nil
          local last_used_timestamp = 0
          local bufs_to_consider = {}

          for _, buf_id in ipairs(bufs) do
            if vim.api.nvim_buf_is_valid(buf_id) then
              local buflisted = vim.api.nvim_get_option_value("buflisted", { buf = buf_id })
              local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
              local name = vim.api.nvim_buf_get_name(buf_id)

              if buflisted then
                local is_special_buf = (
                  filetype == "NvimTree"
                  or filetype == "lazyfile"
                  or filetype == "dashboard"
                  or filetype == "TelescopePrompt"
                  or vim.startswith(name, "[No Name]")
                  or vim.startswith(name, "[Scratch]")
                  or vim.startswith(name, "term://")
                )

                if not is_special_buf and buf_id ~= current_buf_nr then
                  table.insert(bufs_to_consider, buf_id)

                  local buf_info = vim.fn.getbufinfo(buf_id)[1]
                  if buf_info and buf_info.lastused and buf_info.lastused > last_used_timestamp then
                    last_used_timestamp = buf_info.lastused
                    next_target_buf = buf_id
                  end
                end
              end
            end
          end

          if not next_target_buf and #bufs_to_consider > 0 then
            next_target_buf = bufs_to_consider[1]
          end

          if next_target_buf then
            vim.api.nvim_set_current_buf(next_target_buf)
            vim.cmd("bdelete " .. current_buf_nr)
          else
            vim.cmd("bdelete " .. current_buf_nr)
          end
        end,
        mode = { "n", "v" },
        desc = "Smart buffer delete",
      },
    },
  },
}
