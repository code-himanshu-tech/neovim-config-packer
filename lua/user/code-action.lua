require("actions-preview").setup {
  -- Optimize diff settings for better performance and readability
  diff = {
    ctxlen = 2,         -- Reduced context length for faster rendering
    algorithm = "minimal", -- Use minimal algorithm for better performance
  },
  
  -- Enable and configure highlight commands for better visual experience
  highlight_command = {
    require("actions-preview.highlight").delta({
      line_numbers = true,
      side_by_side = false, -- Faster rendering in unified view
      syntax_theme = "GitHub", -- Use a clean, high-contrast theme
    }),
    require("actions-preview.highlight").diff_so_fancy(),
  },
  
  -- Set telescope as primary backend for speed and consistency
  backend = { "telescope", "nui" },
  
  -- Optimize telescope configuration for speed and aesthetics
  telescope = vim.tbl_extend(
    "force",
    require("telescope.themes").get_dropdown({
      winblend = 10,             -- Slight transparency for modern look
      width = 0.6,               -- Optimized width for readability
      results_height = 0.4,      -- Balanced height for faster scanning
      previewer = true,          -- Keep previewer for clarity
      prompt_title = "Code Actions", -- Clear title
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, -- Cleaner borders
    }),
    {
      -- Optimize display format for faster recognition
      make_value = function(action)
        return {
          title = action.title:gsub("\r\n", "\\n"):gsub("\n", "\\n"), -- Clean up titles
          client_name = action.client_name,
        }
      end,
      
      -- Enhanced display formatting for better readability
      make_make_display = function(values)
        local displayer = require("telescope.pickers.entry_display").create {
          separator = " │ ",
          items = {
            { width = 4 },  -- Index width
            { width = 30 }, -- Title width (truncated for speed)
            { remaining = true }, -- Client name gets remaining width
          },
        }
        
        return function(entry)
          return displayer {
            { entry.index, "TelescopeResultsNumber" },
            { entry.title, "TelescopeResultsIdentifier" },
            { entry.client_name, "TelescopeResultsComment" },
          }
        end
      end,
    }
  ),
  
  -- Enhanced NUI configuration for improved appearance and performance
  nui = {
    dir = "row",  -- Horizontal layout for better screen usage
    
    -- Fast keyboard navigation
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "q" },
      select = { "<CR>", "<Space>" },
    },
    
    -- Optimized layout for speed and aesthetics
    layout = {
      position = "50%",
      size = {
        width = "80%",   -- Wider layout for better readability
        height = "70%",  -- Not too tall for faster rendering
      },
      min_width = 40,
      min_height = 10,
      relative = "editor",
    },
    
    -- Prettier preview area
    preview = {
      size = "60%",
      border = {
        style = "rounded",
        text = {
          top = " Preview ",
          top_align = "center",
        },
        padding = { 0, 1 },
        highlight = "FloatBorder",
      },
    },
    
    -- Enhanced selection area
    select = {
      size = "40%",
      border = {
        style = "rounded",
        text = {
          top = " Actions ",
          top_align = "center",
        },
        padding = { 0, 1 },
        highlight = "FloatBorder",
      },
      -- Improve item rendering for faster scanning
      win_options = {
        cursorline = true,
        winblend = 10,
      },
    },
  },
  
  -- Add performance optimizations
  debounce = 100,  -- Debounce code actions requests
  timeout = 2000,  -- Timeout for actions after 2 seconds
}
