-- Safely load shade.nvim
local status_ok, shade = pcall(require, "shade")
if not status_ok then
    vim.notify("Failed to load shade.nvim", vim.log.levels.ERROR)
    return
end

-- Configuration module
local ShadeConfig = {
    -- Core settings
    overlay_opacity = 40,       -- Slightly higher for a more noticeable effect
    opacity_step = 1,           -- Smooth transitions
    keys = {
        toggle = "<leader>ss",  -- Toggle shading
        brighter = "<leader>s+", -- Increase brightness
        dimmer = "<leader>s-"    -- Decrease brightness
    },

    -- Excluded filetypes and buftypes
    exclude_filetypes = {
        "NvimTree",
        "neo-tree",
        "Outline",
        "Trouble",
        "qf",           -- Quickfix
        "help",
        "terminal",
        "alpha",        -- Dashboard
        "toggleterm",
    },
    exclude_buftypes = {
        "nofile",
        "prompt",
        "terminal",
    },

    -- Appearance
    overlay_color = "#1a1a1a",  -- Dark gray matching X.com-like aesthetic
    animate = true,             -- Enable smooth fading
    animation_duration = 150,   -- Faster animation (in ms)

    -- Initialization
    init = function()
        shade.setup({
            overlay_opacity = ShadeConfig.overlay_opacity,
            opacity_step = ShadeConfig.opacity_step,
            keys = ShadeConfig.keys,
            exclude_filetypes = ShadeConfig.exclude_filetypes,
            exclude_buftypes = ShadeConfig.exclude_buftypes,
            overlay_color = ShadeConfig.overlay_color,
            animate = ShadeConfig.animate,
            animation_duration = ShadeConfig.animation_duration,
        })

        -- Register keymappings
        local map = vim.keymap.set
        map("n", ShadeConfig.keys.toggle, shade.toggle, { desc = "Toggle Shade" })
        map("n", ShadeConfig.keys.brighter, function() shade.brightness(ShadeConfig.opacity_step) end, 
            { desc = "Increase Shade Brightness" })
        map("n", ShadeConfig.keys.dimmer, function() shade.brightness(-ShadeConfig.opacity_step) end, 
            { desc = "Decrease Shade Brightness" })
    end,

    -- Utility function to get status
    get_status = function()
        return {
            enabled = shade.is_enabled(),
            current_opacity = shade.get_opacity(),
        }
    end,
}

-- Initialize configuration
ShadeConfig.init()

-- Add custom command for status checking
vim.api.nvim_create_user_command("ShadeStatus", function()
    local status = ShadeConfig.get_status()
    vim.notify("Shade Status: " .. vim.inspect(status), vim.log.levels.INFO)
end, { desc = "Show shade status" })

-- Notify on successful setup
vim.schedule(function()
    vim.notify("Shade.nvim configured successfully", vim.log.levels.INFO)
end)

-- Return module for potential external use
return ShadeConfig
