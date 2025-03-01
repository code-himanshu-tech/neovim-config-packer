-- Safely attempt to load nvim-treesitter
local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    vim.notify("Failed to load nvim-treesitter", vim.log.levels.ERROR)
    return
end

-- Define language list as a local variable for better performance
local ensured_languages = {
    "c", "cpp", "lua", "javascript", "typescript",
    "python", "bash", "cmake", "json5", "gitignore",
    "java", "go", "css", "vue", "tsx",
    "json", "vim", "dockerfile", "html", "yaml",
    "markdown", "sql"
}

-- Optimized treesitter setup
treesitter.setup({
    -- Language installation
    ensure_installed = ensured_languages,
    ignore_install = {}, -- Empty table instead of string
    sync_install = false, -- Async installation for better startup time

    -- Highlighting module
    highlight = {
        enable = true,
        disable = function(lang, buf)
            -- More efficient disable check
            local disabled = { "css" }
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            
            return vim.tbl_contains(disabled, lang) or 
                   (ok and stats and stats.size > max_filesize)
        end,
        additional_vim_regex_highlighting = false,
    },

    -- Auto-pairs module
    autopairs = {
        enable = true,
    },

    -- Indentation module
    indent = {
        enable = true,
        disable = { "python", "css" },
    },

    -- Context commentstring module
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        -- Add common configurations
        config = {
            javascript = '// %s',
            typescript = '// %s',
            css = '/* %s */',
            html = '<!-- %s -->',
        },
    },

    -- Rainbow delimiters module
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000, -- Set reasonable default instead of nil
        disable = function(lang, buf)
            -- Disable for large files
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize
        end,
    },

    -- Auto-tag module
    autotag = {
        enable = true,
        filetypes = { -- Specify supported filetypes
            "html", "javascript", "typescript", "vue",
            "tsx", "xml", "markdown"
        },
    },

    -- Additional performance optimization
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
})

-- Optional: Add diagnostic message on successful setup
vim.schedule(function()
    vim.notify("Tree-sitter setup completed", vim.log.levels.INFO)
end)
