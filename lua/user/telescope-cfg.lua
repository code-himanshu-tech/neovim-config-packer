-- Safely load Telescope
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("Failed to load telescope.nvim", vim.log.levels.ERROR)
  return
end

-- Load dependencies
local actions = require("telescope.actions")
local icons = require("user.icons") or {
  ui = {
    Search = "⛬",      -- Tactical search symbol
    ChevronRight = "❯", -- Sharp caret
    Folder = "🗀",      -- Folder icon for Next.js navigation
    File = "🗎",        -- File icon
  },
}

-- XCOM-inspired theme palette
local telescope_theme = {
  bg_dark = "#1A1B26",      -- Deep, dark XCOM-like background
  fg_white = "#D8DEE9",     -- Crisp white for readability
  neon_blue = "#00D4FF",    -- Neon blue for prompts
  neon_orange = "#F2A272",  -- Neon orange for selections (XCOM accent)
  border_gray = "#3B4252",  -- Subtle, metallic border
  accent_green = "#98C379", -- Green for active elements
}

-- Custom function for Next.js-friendly file finding
local function find_files_in_cwd(opts)
  opts = opts or {}
  local cwd = vim.fn.getcwd() -- Current working directory
  local custom_args = {
    "rg",
    "--files",
    "--color=never",
    "--hidden",          -- Include hidden files
    "--no-heading",
    "--with-filename",
    "--smart-case",
  }

  -- Toggle gitignore respect
  if opts.ignore_gitignore then
    table.insert(custom_args, "--no-ignore")
  end

  -- Restrict to current directory (no recursion unless specified)
  if not opts.recurse then
    table.insert(custom_args, "--max-depth=1")
  end

  require("telescope.builtin").find_files({
    cwd = cwd,
    find_command = custom_args,
    prompt_title = opts.ignore_gitignore and "Files (No Gitignore)" or "Files in " .. vim.fn.fnamemodify(cwd, ":t"),
    hidden = true,
    follow = true,
  })
end

-- Telescope setup
telescope.setup({
  defaults = {
    -- General settings
    prompt_prefix = icons.ui.Search .. " ",
    selection_caret = icons.ui.ChevronRight .. " ",
    entry_prefix = icons.ui.File .. " ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    winblend = 0,
    path_display = { "truncate" }, -- Clean, truncated paths for Next.js
    file_ignore_patterns = {
      "^.next/",        -- Next.js build folder
      "^node_modules/",
      "^dist/",
      "^build/",
      "%.lock",
      "%.min%.",
    },

    -- Layout: Tactical, compact HUD
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.45,
        width = 0.9,
        height = 0.8,
      },
      vertical = {
        mirror = false,
        width = 0.8,
        height = 0.9,
      },
      preview_cutoff = 100,
    },

    -- XCOM-inspired styling
    border = true,
    borderchars = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" }, -- Sharp, double-line borders
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },

    -- Search and preview
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    -- Key mappings: Intuitive for Next.js navigation
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<C-f>"] = function() find_files_in_cwd({ ignore_gitignore = true }) end, -- Ignore gitignore
        ["<C-r>"] = function() find_files_in_cwd({ recurse = true }) end,          -- Recursive in cwd
      },
      n = {
        ["q"] = actions.close,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["f"] = function() find_files_in_cwd({ ignore_gitignore = true }) end,     -- Ignore gitignore
        ["r"] = function() find_files_in_cwd({ recurse = true }) end,             -- Recursive in cwd
      },
    },
  },

  -- Picker-specific configurations
  pickers = {
    find_files = {
      hidden = true,
      follow = true,
      prompt_title = "Mission Files", -- XCOM-style title
    },
    live_grep = {
      additional_args = { "--hidden" },
      prompt_title = "Live Recon", -- Tactical grep
    },
    buffers = {
      sort_lastused = true,
      previewer = false,
      prompt_title = "Active Units", -- Buffer list as "units"
    },
  },

  -- Extensions
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Load extensions
local extensions_to_load = { "fzf" }
for _, ext in ipairs(extensions_to_load) do
  pcall(telescope.load_extension, ext)
end

-- XCOM-inspired UI highlights
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = telescope_theme.bg_dark, fg = telescope_theme.fg_white })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = telescope_theme.border_gray, bg = telescope_theme.bg_dark })
vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = telescope_theme.neon_blue })
vim.api.nvim_set_hl(0, "TelescopePrompt", { bg = telescope_theme.border_gray, fg = telescope_theme.fg_white })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = telescope_theme.border_gray, fg = telescope_theme.neon_orange, bold = true })
vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = telescope_theme.neon_orange })
vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = telescope_theme.accent_green, bold = true })
vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = telescope_theme.neon_blue, bold = true })

-- Keymaps for easy access
vim.keymap.set("n", "<leader>ff", function() find_files_in_cwd() end, { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fi", function() find_files_in_cwd({ ignore_gitignore = true }) end, { desc = "Find Files (ignore gitignore)" })
vim.keymap.set("n", "<leader>fr", function() find_files_in_cwd({ recurse = true }) end, { desc = "Find Files (recursive)" })

-- Notify on successful setup
vim.schedule(function()
  vim.notify("Telescope: Tactical UI deployed", vim.log.levels.INFO)
end)
