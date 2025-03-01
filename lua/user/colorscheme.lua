-- Define the colorscheme
local colorscheme = "tokyonight"

-- Function to set up the colorscheme with custom X.com-inspired tweaks
local function setup_colorscheme()
  -- Load TokyoNight with custom settings
  require("tokyonight").setup({
    style = "night",                -- Deep, dark base like X's UI
    transparent = true,             -- Matches X's minimal, lightweight feel
    terminal_colors = true,         -- Consistent colors in terminal
    styles = {
      comments = { italic = true }, -- Subtle italics for readability
      keywords = { bold = true },   -- Bold keywords for emphasis
    },
    on_colors = function(colors)
      -- Customize colors to mimic X.com's aesthetic
      colors.bg = "#000000"         -- Pure black background like X
      colors.fg = "#ffffff"         -- Bright white text for contrast
      colors.blue = "#1d9bf0"       -- X’s signature blue for links/accents
      colors.comment = "#666666"    -- Muted gray for comments
      colors.border = "#1a1a1a"     -- Slightly lighter black for borders
    end,
    on_highlights = function(highlights, colors)
      -- Custom highlights for an X-like vibe
      highlights.Normal = { bg = colors.bg, fg = colors.fg }
      highlights.LineNr = { fg = "#444444" }            -- Subtle line numbers
      highlights.CursorLineNr = { fg = colors.blue }    -- Blue accent for current line
      highlights.StatusLine = { bg = "#1a1a1a", fg = colors.fg }
      highlights.StatusLineNC = { bg = "#1a1a1a", fg = "#666666" }
      highlights.Visual = { bg = "#1d9bf0", fg = "#000000" } -- X blue for selections
    end,
  })

  -- Apply the colorscheme
  local status_ok, err = pcall(vim.cmd.colorscheme, colorscheme)
  if not status_ok then
    vim.notify("Failed to load colorscheme '" .. colorscheme .. "': " .. tostring(err), vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Execute the setup and handle errors
if not setup_colorscheme() then
  -- Fallback to a default theme if TokyoNight fails
  vim.notify("Falling back to default 'dark' theme", vim.log.levels.WARN)
  vim.o.background = "dark"
end
