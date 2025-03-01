local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  vim.notify("Failed to load 'colorizer.nvim'. Ensure it’s installed.", vim.log.levels.ERROR)
  return
end

colorizer.setup({
  -- Filetypes to enable colorizer for
  filetypes = {
    "*",                          -- Default for all files
    css = { css = true, css_fn = true },  -- Full CSS support
    html = { names = true },      -- Enable named colors for HTML
    javascript = { rgb_fn = true, hsl_fn = true },
    lua = { RRGGBBAA = true },    -- Extra precision for Lua
    "!txt",                       -- Exclude plain text files
  },
  -- User default options applied globally unless overridden
  user_default_options = {
    RGB = true,                   -- #RGB hex codes (e.g., #f00)
    RRGGBB = true,                -- #RRGGBB hex codes (e.g., #ff0000)
    names = false,                -- Disable named colors globally (clutters unless needed)
    RRGGBBAA = true,              -- #RRGGBBAA hex codes (e.g., #ff0000aa)
    rgb_fn = true,                -- CSS rgb() and rgba() (e.g., rgb(255, 0, 0))
    hsl_fn = true,                -- CSS hsl() and hsla() (e.g., hsl(0, 100%, 50%))
    css = false,                  -- Disable full CSS unless specified
    css_fn = false,               -- Disable CSS functions unless specified
    mode = "virtualtext",         -- Default to virtual text for a cleaner, X.com-like minimal UI
    virtualtext = "■",            -- Sleek square symbol to indicate color
    tailwind = true,              -- Support Tailwind CSS classes (e.g., bg-blue-500)
    sass = { enable = true },     -- Support Sass variables (e.g., $primary: #ff0000)
    always_update = false,        -- Avoid unnecessary updates for performance
  },
  -- Buffer-specific options
  buftypes = {
    "*",                          -- Apply to all buffer types
    "!terminal",                  -- Exclude terminals for clarity
    "!prompt",                    -- Exclude prompt buffers
  },
}, {
  -- Optional: Override defaults for specific cases (kept for compatibility with your original)
  mode = "background",            -- Fallback to background mode if virtualtext isn’t supported
})
