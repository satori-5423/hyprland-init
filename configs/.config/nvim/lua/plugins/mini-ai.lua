-- Record the text object identifiers used by mini.ai so m / M can replay them.
return {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
        local record = require("config.textobject").record
        for id, spec in pairs(opts.custom_textobjects or {}) do
            if vim.is_callable(spec) then
                opts.custom_textobjects[id] = function(ai_type, ...)
                    record(ai_type, id)
                    return spec(ai_type, ...)
                end
            end
        end
    end,
}
