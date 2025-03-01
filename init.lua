-- init.lua
-- Existing core requirements
require("user.options")
require("user.plugins")
require("user.keymaps")
require("user.lsp")
require("user.treesitter")
require("user.cmp")
require("user.autocommands")
require("user.colorscheme")
require("user.telescope-cfg")
require("user.gitsigns")
require("user.autopairs")
require("user.comment")
require("user.nvim-tree")
require("user.bufferline")
require("user.lualine")
require("user.toggleterm")
require("user.project")
vim.loader.enable()
require("user.illuminate")
require("user.indentline")
require("user.alpha")
require("user.luasnip_setup")
require("user.codeium")
require("user.commands")
require("user.navic")
require("user.noice")
require("user.todo-comments")
require("user.winbar")
require("user.whichKey")
require("scope").setup()
require("user.comment")
require("user.colorizer")
require("user.nvim-ts-autotag")
require("pets").setup({})

-- Additional essential plugins
require("user.leap") -- Fast navigation
require("user.oil") -- File management
require("user.mini") -- Collection of minimal plugins
require("user.diffview") -- Git diff viewer
require("user.harpoon") -- File marking and quick navigation
require("user.persistence") -- Session management
require("user.vim-matchup") -- Enhanced % matching
require("user.markdown-preview") -- Markdown preview
require("user.spectre") -- Search and replace
require("user.symbols-outline") -- Symbol viewer
require("user.ufo") -- Better folding
require("user.barbecue") -- VS Code like winbar


require("plugins.devicons")

-- UI Enhancements
require("notify").setup({ -- Notification manager
  background_colour = "#000000",
  timeout = 3000,
  max_width = 80,
})

require("image").setup({ -- Image viewer
  backend = "ueberzug",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" },
    },
  },
})

require("spider").setup() -- Better word navigation

require("various-textobjs").setup({ -- Additional text objects
  useDefaultKeymaps = true,
})

-- Development helpers
require("user.neotest") -- Testing framework
require("user.rest-nvim") -- HTTP client
require("user.nvim-surround") -- Surround text objects
require("user.hardtime") -- Better Vim habits

-- Language specific
require("user.typescript-tools") -- Enhanced TypeScript support
require("user.rustaceanvim") -- Rust development

-- Core settings
vim.cmd([[:set laststatus=3]])
vim.cmd([[colorscheme tokyonight-night]])

-- Performance optimizations
require("user.lazy-loader").setup({
  -- Modules to lazy load
  modules = {
    "neotest",
    "rest-nvim",
    "markdown-preview",
    "image",
  },
  -- Load when these events occur
  events = { "BufRead", "BufNewFile" },
})
