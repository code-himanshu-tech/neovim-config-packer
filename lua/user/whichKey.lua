-- Safely load which-key
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    vim.notify("Failed to load which-key", vim.log.levels.ERROR)
    return
end

-- Load icons safely
local icons = require("user.icons") or {
    ui = {
        DoubleChevronRight = "»",
        BoldArrowRight = "➜",
        Plus = "+"
    }
}

-- Base configuration
local setup = {
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = true,
            suggestions = 20,
        },
        presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = true,
            nav = true,
            z = true,
            g = true,
        },
    },
    icons = {
        breadcrumb = icons.ui.DoubleChevronRight,
        separator = icons.ui.BoldArrowRight,
        group = icons.ui.Plus,
    },
    keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
    },
    win = {
        no_overlap = true,
        border = "rounded",
        padding = { 2, 2 },
        title = "Keybindings",
        title_pos = "center",
        zindex = 1000,
        height = { min = 4, max = 25 },
        wo = {
            winblend = 0,
        },
    },
    layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
    },
    show_help = true,
    triggers = { "<leader>" },
}

-- Keymap options
local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
}

-- Organized mappings
local mappings = {
    -- Core commands
    { "<leader>a", "<cmd>Alpha<cr>", desc = "Dashboard" },
    { "<leader>b", "<cmd>Telescope buffers theme=dropdown previewer=false<cr>", desc = "Buffers" },
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
    { "<leader>w", "<cmd>w!<cr>", desc = "Save" },
    { "<leader>q", "<cmd>q!<cr>", desc = "Quit" },
    { "<leader>/", "<cmd>lua require('Comment.api').toggle()<cr>", desc = "Toggle Comment" },
    { "<leader>c", "<cmd>lua require('actions-preview').code_actions()<cr>", desc = "Code Action" },
    { "<leader>h", "<cmd>nohlsearch<cr>", desc = "Clear Highlights" },
    { "<leader>P", "<cmd>Telescope projects<cr>", desc = "Projects" },

    -- Find group
    { "<leader>f", group = "Find" },
    { "<leader>ff", "<cmd>Telescope find_files theme=dropdown<cr>", desc = "Files" },
    { "<leader>fg", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },

    -- Git group
    { "<leader>g", group = "Git" },
    { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "Lazygit" },
    { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
    { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage" },
    { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
    { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
    { "<leader>gl", "<cmd>Gitsigns blame_line<cr>", desc = "Blame" },

    -- LSP group
    { "<leader>l", group = "LSP" },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "<leader>lf", "<cmd>lua require('conform').format({async=true})<cr>", desc = "Format" },
    { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP Info" },

    -- Terminal group
    { "<leader>t", group = "Terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
    { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
    { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical" },
    { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node" },
    { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python" },

    -- Plugin Management
    { "<leader>p", group = "Plugins" },
    { "<leader>ps", "<cmd>PackerSync<cr>", desc = "Sync" },
    { "<leader>pu", "<cmd>PackerUpdate<cr>", desc = "Update" },
    { "<leader>pi", "<cmd>PackerInstall<cr>", desc = "Install" },
}

-- Visual mode mappings
local vopts = {
    mode = "v",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
}
local vmappings = {
    { "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle(vim.fn.visualmode())<cr>", desc = "Toggle Comment" },
}

-- Setup and register mappings
which_key.setup(setup)
which_key.add(mappings, opts)
which_key.add(vmappings, vopts)

-- Add some helpful autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = "which_key",
    callback = function()
        vim.wo.cursorline = true
        vim.wo.number = false
    end,
    desc = "Enhance Which-Key window appearance",
})

-- Notify on successful setup
vim.schedule(function()
    vim.notify("Which-Key configured successfully", vim.log.levels.INFO)
end)
