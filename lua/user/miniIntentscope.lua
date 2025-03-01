local status_ok, indentscope = pcall(require, "mini.indentscope")
if not status_ok then
  return
end

-- Configure mini.indentscope with improved visual options
indentscope.setup({
  -- Use a more visible symbol for indent guides
  symbol = "┠", -- You could also try: "│", "┃", "▎", or "▌"
  
  -- Core options
  draw = {
    -- Animation style for showing scope
    animation = {
      type = "easing", -- 'none', 'easing', or 'linear'
      duration_ms = 500,
    },
    -- How to prioritize scope selection
    priority = 2,
  },
  
  -- Scope options
  options = {
    border = "both", -- 'top', 'bottom', 'both', or 'none'
    indent_at_cursor = true,
    try_as_border = true,
  },
  
  -- Symbol mappings
  mappings = {
    -- Motions, default: goto_top = '[i', goto_bottom = ']i'
    object_scope = 'ii',
    object_scope_with_border = 'ai',
  },
  
  -- Exclude certain filetypes and buffer types
  symbol_empty = '',
  
  -- Exclude list
  exclude = {
    filetypes = {
      "help",
      "packer",
      "NvimTree",
      "toggleterm",
      "TelescopePrompt",
      "dashboard",
      "alpha",
      "lspinfo",
      "lsp-installer",
      "markdown",
    },
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
      "prompt",
    },
  },
})

-- Set up yellow highlighting for the indent symbol
vim.cmd([[
  highlight MiniIndentscopeSymbol guifg=#FFCC00 gui=nocombine
  highlight MiniIndentscopePrefix guifg=#FFCC00 gui=nocombine
]])

-- Optional: Add animation ease out function for smoother animation
vim.cmd([[
  augroup IndentScopeHighlight
    autocmd!
    autocmd ColorScheme * highlight MiniIndentscopeSymbol guifg=#FFCC00 gui=nocombine
    autocmd ColorScheme * highlight MiniIndentscopePrefix guifg=#FFCC00 gui=nocombine
  augroup END
]])
