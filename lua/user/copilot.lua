-- Configuration for Copilot.lua
local copilot_setup = function()
  local status_ok, copilot = pcall(require, "copilot")
  if status_ok then
    copilot.setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          -- Define keymaps for suggestions
          accept = "<M-i>",         -- Alt+i to accept suggestion
          accept_word = "<M-w>",    -- Alt+w to accept word
          accept_line = "<M-l>",    -- Alt+l to accept line
          next = "<M-]>",           -- Alt+] to navigate to next suggestion
          prev = "<M-[>",           -- Alt+[ to navigate to previous suggestion
          dismiss = "<C-]>",        -- Ctrl+] to dismiss suggestion
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-p>"
        },
      },
      filetypes = {
        -- Enable for all filetypes
        ["*"] = true,
      },
    })
    return true
  end
  return false
end

-- Run the setup
local copilot_lua_ok = copilot_setup()

-- Print status message
if copilot_lua_ok then
  vim.notify("Copilot.lua successfully configured", vim.log.levels.INFO)
else
  vim.notify("Copilot.lua not found. Make sure it's installed.", vim.log.levels.WARN)
end
