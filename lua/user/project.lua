-- Safely load project_nvim
local status, project = pcall(require, "project_nvim")
if not status then
  vim.notify("Failed to load project_nvim", vim.log.levels.ERROR)
  return
end

-- Dependencies
local has_neotree, neotree = pcall(require, "neo-tree")
local has_telescope, telescope = pcall(require, "telescope")

-- XCOM-inspired theme
local xcom_theme = {
  bg_dark = "#1A1B26",      -- Dark, tactical background
  fg_white = "#D8DEE9",     -- Crisp white text
  neon_orange = "#F2A272",  -- Neon orange for highlights
  neon_blue = "#00D4FF",    -- Neon blue for prompts
  border_gray = "#3B4252",  -- Metallic border
}

-- Configuration module
local ProjectConfig = {
  -- Core settings
  manual_mode = false,
  detection_methods = { "lsp", "pattern" }, -- Fast LSP + pattern detection
  patterns = {
    -- General VCS
    ".git", ".hg", ".svn",
    -- App-specific markers
    "package.json",       -- Node.js/Next.js
    "go.mod",             -- Go
    "Cargo.toml",         -- Rust
    "pyproject.toml",     -- Python
    "Gemfile",            -- Ruby/Rails
    "composer.json",      -- PHP/Laravel
    "Makefile",           -- Generic build
    "next.config.js",     -- Next.js specific
    "app/",               -- Rails/Next.js app dir
  },
  ignore_lsp = {},        -- Allow all LSP roots
  exclude_dirs = {
    "~/.cargo/*",
    "~/.npm/*",
    "~/node_modules/*",
    "~/.next/*",        -- Next.js build dir
    "/tmp/*",
  },
  show_hidden = true,     -- Reveal hidden files for flexibility
  silent_chdir = false,   -- Notify on chdir for feedback
  scope_chdir = "tab",    -- Tab-local roots for multi-project workflows
  datapath = vim.fn.stdpath("data") .. "/project_nvim",

  -- Open project in explorer
  open_in_explorer = function(path)
    if not path then
      vim.notify("No project root detected", vim.log.levels.WARN)
      return
    end

    vim.fn.chdir(path)
    vim.notify("Deployed to: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO, { title = "Mission Control" })

    if has_neotree then
      vim.cmd("Neotree reveal action=focus dir=" .. path)
    else
      vim.cmd("Explore " .. path)
    end
  end,

  -- Telescope picker for project selection
  select_project = function()
    if not has_telescope then
      vim.notify("Telescope required for project selection", vim.log.levels.ERROR)
      return
    end

    local projects = require("project_nvim.project")
    local project_list = projects.get_projects() or {}

    if #project_list == 0 then
      vim.notify("No projects detected", vim.log.levels.WARN)
      return
    end

    telescope.register_extension({
      setup = function() end,
      exports = {
        projects = function(opts)
          opts = opts or {}
          require("telescope.pickers").new(opts, {
            prompt_title = "Mission Select",
            finder = require("telescope.finders").new_table({
              results = project_list,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = vim.fn.fnamemodify(entry, ":t") .. " [" .. entry .. "]",
                  ordinal = entry,
                }
              end,
            }),
            sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
            previewer = require("telescope.previewers").vim_buffer_cat.new({}),
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                ProjectConfig.open_in_explorer(selection.value)
              end)
              return true
            end,
          }):find()
        end,
      },
    })
    vim.cmd("Telescope projects")
  end,

  -- Initialization
  init = function()
    project.setup(ProjectConfig)

    -- Commands
    vim.api.nvim_create_user_command("ProjectOpen", function()
      local root = require("project_nvim.project").get_project_root()
      ProjectConfig.open_in_explorer(root)
    end, { desc = "Open current project in explorer" })

    vim.api.nvim_create_user_command("ProjectSelect", function()
      ProjectConfig.select_project()
    end, { desc = "Select project with Telescope" })

    -- Keymaps for fast navigation
    vim.keymap.set("n", "<leader>po", "<cmd>ProjectOpen<CR>", {
      desc = "Open Project Explorer",
      silent = true,
    })
    vim.keymap.set("n", "<leader>ps", "<cmd>ProjectSelect<CR>", {
      desc = "Select Project",
      silent = true,
    })
    vim.keymap.set("n", "<leader>pr", function()
      local root = require("project_nvim.project").get_project_root()
      if root then
        vim.notify("Current root: " .. root, vim.log.levels.INFO)
      end
    end, { desc = "Show Project Root" })
  end,
}

-- Initialize configuration
ProjectConfig.init()

-- XCOM-inspired Telescope UI (if loaded)
if has_telescope then
  telescope.load_extension("projects")
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = xcom_theme.neon_blue, bold = true })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = xcom_theme.neon_orange, bold = true })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = xcom_theme.accent_green, bold = true })
end

-- Notify on successful setup
vim.schedule(function()
  vim.notify("Project.nvim: Tactical navigation online", vim.log.levels.INFO, { title = "XCOM Uplink" })
end)

return ProjectConfig
