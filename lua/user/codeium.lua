-- Check the operating system to map the correct keybinding
if vim.fn.has("mac") == 1 then
    -- For Mac, use <C-i> to accept Codeium suggestion
    vim.api.nvim_set_keymap('i', '<C-i>', 'codeium#Accept()', { noremap = true, silent = true, expr = true })
  else
    -- For other systems, use <M-i> (Alt + i) to accept Codeium suggestion
    vim.api.nvim_set_keymap('i', '<M-i>', 'codeium#Accept()', { noremap = true, silent = true, expr = true })
  end

  -- Disable tab key for mapping to Codeium
  vim.g.codeium_no_map_tab = true
