local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

-- Enhanced color palette for better visual appeal
local colors = {
  bg = {
    main = "#141423",       -- Darker background
    float = "#16182D",      -- Slightly lighter for float
    border = "#1E2240",     -- Border background
  },
  fg = {
    normal = "#E0E0E0",     -- Standard text
    muted = "#A0A0B0",      -- Dimmed text
    bright = "#FFFFFF",     -- Highlighted text
  },
  accent = {
    primary = "#4ECDC4",    -- Teal accent
    secondary = "#FF6B6B",  -- Red accent
    tertiary = "#9D65FF",   -- Purple accent
    success = "#78DBA9",    -- Green accent
  }
}

-- Custom highlights for better terminal appearance
vim.api.nvim_set_hl(0, "TermCursor", { fg = colors.accent.secondary, bg = colors.accent.primary })
vim.api.nvim_set_hl(0, "TermNormal", { fg = colors.fg.normal, bg = colors.bg.main })
vim.api.nvim_set_hl(0, "TermBorder", { fg = colors.accent.primary, bg = colors.bg.border })
vim.api.nvim_set_hl(0, "TermTitle", { fg = colors.accent.tertiary, bg = colors.bg.border, bold = true })
vim.api.nvim_set_hl(0, "TermFooter", { fg = colors.fg.muted, bg = colors.bg.border, italic = true })
vim.api.nvim_set_hl(0, "TermSelection", { fg = colors.fg.bright, bg = colors.accent.tertiary })

-- Calculate ideal terminal dimensions based on screen size
local function get_terminal_dimensions()
  local width = vim.o.columns
  local height = vim.o.lines
  
  return {
    horizontal = {
      height = math.floor(height * 0.35),
      width = width,
    },
    vertical = {
      height = height - 4, -- Account for status line and padding
      width = math.floor(width * 0.4),
    },
    float = {
      height = math.floor(height * 0.85),
      width = math.floor(width * 0.85),
      row = math.floor((height - math.floor(height * 0.85)) / 2),
      col = math.floor((width - math.floor(width * 0.85)) / 2),
    }
  }
end

local dimensions = get_terminal_dimensions()

-- Prepare title formatting function
local function terminal_title(title)
  local padding = string.rep(" ", 2)
  return padding .. title .. padding
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return dimensions.horizontal.height
    elseif term.direction == "vertical" then
      return dimensions.vertical.width
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 3,           -- Increased for more contrast
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  autochdir = true,             -- Automatically change to project directory
  
  -- Visual padding for horizontal and vertical terminals
  padding = true,               -- Add padding around the terminal content
  
  -- Enhanced title configuration
  title_colors = {
    fg = colors.fg.bright,
    bg = colors.bg.border,
  },
  
  highlights = {
    Normal = {
      guibg = colors.bg.main,
    },
    NormalFloat = {
      guibg = colors.bg.float,
    },
    FloatBorder = {
      guifg = colors.accent.primary,
      guibg = colors.bg.border,
    },
    StatusLine = {
      guibg = colors.bg.border,
      guifg = colors.fg.muted,
    }
  },
  
  -- Enhanced floating window settings
  float_opts = {
    border = "rounded",
    winblend = 3,
    title_pos = "center",
    
    -- Apply internal padding within the float
    width = dimensions.float.width,
    height = dimensions.float.height,
    row = dimensions.float.row,
    col = dimensions.float.col,
    
    highlights = {
      border = "TermBorder",
      background = "TermNormal",
      title = "TermTitle",
    },
  },
  
  -- Visual enhancements
  winbar = {
    enabled = true,
    name_formatter = function(term)
      return terminal_title("Terminal " .. term.id)
    end,
  },
})

-- Improved terminal keymaps
function _G.set_terminal_keymaps()
  local opts = { noremap = true, silent = true }
  
  -- Navigation
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  
  -- Quick exit
  vim.api.nvim_buf_set_keymap(0, 't', '<C-q>', [[<C-\><C-n>:q<CR>]], opts)
  
  -- Copy/paste
  vim.api.nvim_buf_set_keymap(0, 't', '<C-v>', [[<C-\><C-n>pi]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-S-v>', [[<C-\><C-n>pi]], opts)
  
  -- Scrolling
  vim.api.nvim_buf_set_keymap(0, 't', '<C-u>', [[<C-\><C-n><C-u>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-d>', [[<C-\><C-n><C-d>]], opts)
  
  -- Clear terminal
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l><C-l>', [[<C-l>]], opts)
end

-- Enhanced buffer handling and appearance
vim.cmd([[
  augroup TerminalSettings
    autocmd!
    autocmd TermOpen term://* lua set_terminal_keymaps()
    autocmd TermOpen term://* setlocal nobuflisted nonumber norelativenumber signcolumn=no
    autocmd TermEnter term://* startinsert
    
    " Set cursor style
    autocmd TermEnter term://* setlocal guicursor=a:ver20-TermCursor
    autocmd TermLeave term://* setlocal guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    
    " Add fancy border with title (removed the problematic line)
  augroup END
]])
local Terminal = require("toggleterm.terminal").Terminal
-- Enhanced lazygit with custom styling
local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "rounded",
    width = dimensions.float.width,
    height = dimensions.float.height,
    title = terminal_title("  LazyGit  "),
    title_pos = "center",
  },
  highlights = {
    FloatBorder = {
      guifg = colors.accent.primary,
    },
    NormalFloat = {
      guibg = colors.bg.float,
    }
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

-- Node terminal with custom styling
local node = Terminal:new({
  cmd = "node",
  direction = "float",
  float_opts = {
    border = "double",
    title = terminal_title("  Node.js  "),
    title_pos = "center",
  },
  highlights = {
    Normal = { guibg = "#1A2E2E" },
    FloatBorder = { guifg = "#98D8AA" },
  },
})

function _NODE_TOGGLE()
  node:toggle()
end

-- Python terminal with custom styling
local python = Terminal:new({
  cmd = "python",
  direction = "float",
  float_opts = {
    border = "single",
    title = terminal_title("  Python  "),
    title_pos = "center",
  },
  highlights = {
    Normal = { guibg = "#232753" },
    FloatBorder = { guifg = "#FFD166" },
  },
})

function _PYTHON_TOGGLE()
  python:toggle()
end

-- Bottom terminal with fancy frame
local bottom_term = Terminal:new({
  cmd = "btm",  -- Bottom is a system monitor
  hidden = true,
  direction = "float",
  float_opts = {
    border = "shadow",
    width = dimensions.float.width,
    height = dimensions.float.height,
    title = terminal_title("  System Monitor  "),
    title_pos = "center",
  },
  highlights = {
    FloatBorder = {
      guifg = colors.accent.tertiary,
    },
    NormalFloat = {
      guibg = "#171C3C",
    }
  },
})

function _BOTTOM_TOGGLE()
  bottom_term:toggle()
end

-- Register keymaps to open specific terminal types
vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>tb", "<cmd>lua _BOTTOM_TOGGLE()<CR>", {noremap = true, silent = true})

-- Create a helpful terminal selector menu
function _SELECT_TERMINAL()
  local actions = require('telescope.actions')
  local actions_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local dropdown = require('telescope.themes').get_dropdown()
  
  local terminal_options = {
    { name = "General Terminal", cmd = "toggleterm" },
    { name = "LazyGit", cmd = "_LAZYGIT_TOGGLE()" },
    { name = "Node REPL", cmd = "_NODE_TOGGLE()" },
    { name = "Python REPL", cmd = "_PYTHON_TOGGLE()" },
    { name = "System Monitor", cmd = "_BOTTOM_TOGGLE()" },
  }
  
  pickers.new(dropdown, {
    prompt_title = 'Select Terminal',
    finder = finders.new_table {
      results = terminal_options,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = actions_state.get_selected_entry().value
        
        if selection.cmd == "toggleterm" then
          vim.cmd([[ToggleTerm]])
        else
          vim.cmd("lua " .. selection.cmd)
        end
      end)
      return true
    end,
  }):find()
end

-- Register the terminal selector
vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua _SELECT_TERMINAL()<CR>", {noremap = true, silent = true})

-- Create a statusline component for terminals
local function terminal_statusline()
  local term_count = #require("toggleterm.terminal").get_all()
  if term_count > 0 then
    return " TERM:" .. term_count .. " "
  else
    return ""
  end
end

-- Export the statusline component for use in lualine if needed
_G.terminal_statusline = terminal_statusline

return {
  -- Export functions to be used by other modules
  toggle_lazygit = _LAZYGIT_TOGGLE,
  toggle_node = _NODE_TOGGLE,
  toggle_python = _PYTHON_TOGGLE,
  toggle_bottom = _BOTTOM_TOGGLE,
  select_terminal = _SELECT_TERMINAL,
  terminal_statusline = terminal_statusline
}
