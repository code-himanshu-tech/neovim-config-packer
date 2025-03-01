require("conform").setup({
  -- Formatter configurations by file type
  formatters_by_ft = {
    -- Lua
    lua = { "stylua" },
    
    -- Web development
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    javascriptreact = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },
    css = { { "prettierd", "prettier" } },
    scss = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    
    -- Data formats
    json = { { "prettierd", "prettier" } },
    yaml = { { "prettierd", "prettier" } },
    graphql = { { "prettierd", "prettier" } },
    
    -- Documentation
    markdown = { { "prettierd", "prettier" } },
    md = { { "prettierd", "prettier" } },
    txt = { { "prettierd", "prettier" } },
    
    -- Shell
    sh = { "beautysh" },
    bash = { "beautysh" },
    zsh = { "beautysh" },
  },
  
  -- Custom formatter configurations
  formatters = {
    stylua = {
      args = { "--indent-width", "4", "--indent-type", "Spaces", "-" },
    },
    prettierd = {
      env = {
        PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/utils/linter-config/.prettierrc.json"),
      },
    },
    prettier = {
      -- Fallback prettier config if prettierd fails
      args = {
        "--config-precedence", "prefer-file",
        "--print-width", "100",
        "--tab-width", "2",
        "--use-tabs", "false",
        "--semi", "true",
        "--single-quote", "false",
        "--bracket-spacing", "true",
        "--bracket-same-line", "false",
        "--prose-wrap", "preserve",
      },
    },
    beautysh = {
      args = { "--indent-size", "2", "-" },
    },
  },
  
  -- Format on save options (commented out by default, uncomment to enable)
  -- format_on_save = {
  --   -- Timeout in milliseconds
  --   timeout_ms = 500,
  --   -- Fall back to LSP formatting if formatter not available
  --   lsp_fallback = true,
  --   -- Filetypes to ignore formatting on save
  --   ignore_filetypes = {
  --     "sql",
  --   },
  -- },
  
  -- Format on keystroke (for formatting as you type)
  -- format_on_keystroke = {
  --   -- Timeout in milliseconds
  --   timeout_ms = 500,
  --   -- Filetypes to enable format on keystroke
  --   enabled_filetypes = {
  --     "lua",
  --     "javascript",
  --     "typescript",
  --   },
  -- },
  
  -- Notify on formatting errors
  notify_on_error = true,
})

-- Key mappings for manual formatting
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Format visual selection
vim.keymap.set("v", "<leader>f", function()
  require("conform").format({
    async = true,
    lsp_fallback = true,
    range = {
      start = vim.fn.getpos("'<"),
      ["end"] = vim.fn.getpos("'>"),
    },
  })
end, { desc = "Format selection" })
