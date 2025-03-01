local icons = require("user.icons")

if vim.version().major > 7 then
  require("winbar").setup {
    enabled = true,

    -- Display both file path and symbols
    show_file_path = true,
    show_symbols = true,

    -- Custom format with ASCII separators
    format = function(bufnr)
      local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~:.")
      local filename = vim.fn.fnamemodify(path, ":t")
      local dir = vim.fn.fnamemodify(path, ":h")
      local symbol = require("winbar").get_current_symbol(bufnr) or ""
      
      -- Construct a clean winbar with ASCII
      local components = {}
      if dir ~= "." then
        table.insert(components, dir)
      end
      table.insert(components, filename)
      if symbol ~= "" then
        table.insert(components, symbol)
      end
      return table.concat(components, " > ")  -- Simple ASCII separator
    end,

    colors = {
      -- Subtle colors (ASCII doesn’t affect this)
      path = "#7f849c",      -- Grayish-purple
      file_name = "#c0caf5", -- Soft blue
      symbols = "#f9e2af",   -- Warm yellow
    },

    icons = {
      file_icon_default = icons.ui.File or "F",  -- 'F' for file
      seperator = ">",                          -- ASCII '>'
      editor_state = icons.ui.Pencil or "*",    -- '*' for editing
      lock_icon = icons.ui.Lock or "#",         -- '#' for locked
    },

    -- Buffer status with ASCII
    buffer_status = {
      modified = icons.ui.Circle or "+",       -- '+' for modified
      readonly = icons.ui.Lock or "#",         -- '#' for readonly
    },

    -- Exclusion list remains unchanged
    exclude_filetype = {
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "alpha",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "qf",
      "terminal",
      "neo-tree",
      "diff",
      "fugitive",
    },

    -- Highlights for theme integration
    highlights = {
      WinBar = { link = "StatusLine" },
      WinBarNC = { link = "StatusLineNC" },
    },

    -- Click actions (if supported)
    on_click = {
      file_path = function()
        vim.notify("File path: " .. vim.fn.expand("%:p"), vim.log.levels.INFO)
      end,
      symbols = function()
        vim.cmd("SymbolsOutline")
      end,
    },
  }
else
  return {}
end
