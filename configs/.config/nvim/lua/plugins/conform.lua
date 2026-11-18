-- Prettier: keep its indentation in sync with the buffer
return {
    "stevearc/conform.nvim",
    opts = function(_, opts)
        opts.formatters = opts.formatters or {}
        local prettier = opts.formatters.prettier or {}
        prettier.prepend_args = function(_, ctx)
            local bo = vim.bo[ctx.buf]
            local width = bo.shiftwidth > 0 and bo.shiftwidth or bo.tabstop
            local args = { "--tab-width", tostring(width) }
            if not bo.expandtab then
                args[#args + 1] = "--use-tabs"
            end
            return args
        end
        opts.formatters.prettier = prettier
    end,
}
