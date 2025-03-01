-- Safely load trouble.nvim
local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
    vim.notify("Failed to load trouble.nvim", vim.log.levels.ERROR)
    return
end

trouble.setup({
    -- UI Configuration
    position = "bottom",
    height = 20, -- Increased height for larger error lists
    width = 50,  -- Slightly wider for better readability
    icons = true,
    padding = true,
    group = true,
    indent_lines = true,
    win_config = { border = "rounded" }, -- Add rounded border for better UI
    
    -- Default mode to show all workspace diagnostics
    mode = "workspace_diagnostics",
    
    -- Enhanced custom signs with more modern styling
    signs = {
        error = "󰅚", -- More prominent error symbol
        warning = "", -- Warning triangle
        hint = "󰌶", -- Lightbulb for hints
        information = "󰋽", -- Info symbol
        other = "󰗡", -- Generic symbol
    },
    
    -- Key mappings similar to VSCode with some enhancements
    action_keys = {
        close = { "q", "<Esc>" },
        cancel = "<C-c>",
        refresh = "r",
        jump = { "<cr>", "<tab>" },
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = { "o" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = { "zM" },
        open_folds = { "zR" },
        toggle_fold = { "za" },
        previous = "k",
        next = "j",
        -- Add some additional useful keys
        first = "gg",
        last = "G",
        help = "?",
    },
    
    -- Behavior
    auto_open = false,    -- Don't open automatically
    auto_close = false,   -- Keep open until manually closed
    auto_preview = true,  -- Preview on hover like VSCode
    auto_fold = false,
    auto_jump = { "lsp_definitions", "lsp_type_definitions" },
    focus_on_open = true, -- Focus the list when opened
    
    -- Folding
    fold_open = "󰅀", -- More modern folding symbols
    fold_closed = "󰁙",
    
    -- Integration with LSP diagnostics
    use_diagnostic_signs = true, -- Use LSP client signs if available
    
    -- Enhanced diagnostics filtering for TS/Next.js
    diagnostics = {
        -- Improved filter to catch more Next.js and TypeScript errors
        filter = function(_, source, code, severity, _)
            -- Always include errors
            if severity == vim.diagnostic.severity.ERROR then
                return true
            end
            
            -- Include TypeScript and Next.js specific diagnostics
            local ts_sources = {
                "typescript", 
                "tsserver", 
                "eslint",
                "javascript",
                "next",
                "nextjs",
                "react"
            }
            
            -- Check if source is from our target TS/Next.js sources
            for _, ts_source in ipairs(ts_sources) do
                if source and source:lower():match(ts_source) then
                    return true
                end
            end
            
            -- Include common TypeScript error codes
            local ts_error_codes = {
                2304, -- Cannot find name
                2307, -- Cannot find module
                2322, -- Type error
                2339, -- Property does not exist
                2345, -- Argument type mismatch
                2554, -- Expected n arguments but got m
                2571, -- Object is possibly null
                2741, -- Property is missing
                7016, -- Could not find declaration file
                7031, -- Module has no default export
            }
            
            for _, err_code in ipairs(ts_error_codes) do
                if code == err_code then
                    return true
                end
            end
            
            -- Include warnings for specified sources
            if severity == vim.diagnostic.severity.WARN then
                for _, ts_source in ipairs({"typescript", "tsserver", "eslint"}) do
                    if source and source:lower():match(ts_source) then
                        return true
                    end
                end
            end
            
            return false
        end
    },
    
    -- Sorting to prioritize errors
    sort_keys = {
        "severity", -- Sort by severity first (errors before warnings)
        "filename", -- Then group by filename
        "lnum",     -- Then by line number
    },
})

-- Enhanced keybindings to mimic VSCode workflow with better descriptions
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble workspace_diagnostics<cr>", 
    { desc = "Open workspace TypeScript/Next.js diagnostics" })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", 
    { desc = "Open current file diagnostics" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", 
    { desc = "Show all project warnings and errors" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", 
    { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>", 
    { desc = "Open location list" })
vim.keymap.set("n", "<leader>xt", "<cmd>TroubleToggle<cr>", 
    { desc = "Toggle Trouble panel" })
vim.keymap.set("n", "<leader>xr", function() 
    trouble.refresh()
    vim.notify("Refreshed TypeScript diagnostics", vim.log.levels.INFO)
end, { desc = "Refresh diagnostics" })

-- Auto refresh on specific events for TS/Next.js files
vim.api.nvim_create_augroup("TroubleAutoRefresh", { clear = true })

-- Refresh on file save for TypeScript/JavaScript/Next.js files
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "TroubleAutoRefresh",
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "next.config.js", "*.mdx" },
    callback = function()
        if trouble.is_open() then
            vim.defer_fn(function()
                trouble.refresh()
                vim.notify("TypeScript diagnostics refreshed", vim.log.levels.INFO, {
                    title = "Trouble.nvim"
                })
            end, 500) -- Small delay to allow LSP to update diagnostics
        end
    end,
    desc = "Refresh Trouble diagnostics after saving TS/JS/Next.js files",
})

-- Refresh on entering TypeScript/Next.js files when Trouble is open
vim.api.nvim_create_autocmd("BufEnter", {
    group = "TroubleAutoRefresh",
    pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "next.config.js" },
    callback = function()
        if trouble.is_open() then
            vim.defer_fn(function()
                trouble.refresh()
            end, 300)
        end
    end,
    desc = "Refresh Trouble when entering TS/Next.js files",
})

-- Command to explicitly focus on Next.js errors
vim.api.nvim_create_user_command("NextJSErrors", function()
    trouble.open({
        mode = "workspace_diagnostics",
        filter = function(_, source, _, severity, _)
            return (source and source:lower():match("next")) or 
                  (source and source:lower():match("typescript") and severity == vim.diagnostic.severity.ERROR)
        end
    })
end, { desc = "Show only Next.js and TypeScript errors" })

-- Command to show all TypeScript warnings
vim.api.nvim_create_user_command("TSWarnings", function()
    trouble.open({
        mode = "workspace_diagnostics",
        filter = function(_, source, _, severity, _)
            return (source and source:lower():match("typescript") and severity == vim.diagnostic.severity.WARN)
        end
    })
end, { desc = "Show only TypeScript warnings" })

-- Notify on successful setup
vim.schedule(function()
    vim.notify("Enhanced Trouble.nvim configured for TypeScript and Next.js diagnostics", 
              vim.log.levels.INFO, 
              { title = "Trouble.nvim Setup" })
end)

-- Return the module for use in other files
return trouble
