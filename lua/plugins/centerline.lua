-- lua/plugins/centerline.lua

local M = {}

-- Default configuration
local defaults = {
  scrolloff = 999,           -- Large value to keep cursor centered
  bufferline_separator = "🌟", -- Default emoji separator for bufferline
}

-- Plugin setup function
function M.setup(opts)
  -- Merge user options with defaults
  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  -- Keep active line centered
  vim.opt.scrolloff = opts.scrolloff
  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    callback = function()
      vim.opt.scrolloff = opts.scrolloff
    end,
    desc = "Keep cursor line centered in insert mode",
  })

  -- Customize bufferline separator
  local bufferline_status_ok, bufferline = pcall(require, "bufferline")
  if bufferline_status_ok then
    -- Get existing bufferline options or initialize an empty table
    local current_config = bufferline.get_config and bufferline.get_config() or { options = {} }
    local options = current_config.options or {}

    -- Update separator style with emoji
    options.separator_style = { opts.bufferline_separator, opts.bufferline_separator }

    -- Apply the updated configuration
    bufferline.setup({
      options = options,
    })
  end
end

return M
