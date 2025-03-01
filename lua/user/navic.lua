-- Safely load nvim-navic
local present, navic = pcall(require, "nvim-navic")
if not present then
  return
end

-- Load icons
local icons = require("user.icons")

-- XCOM-inspired theme
local xcom_theme = {
  fg_white = "#D8DEE9",     -- Crisp white for text
  neon_orange = "#F2A272",  -- Neon orange for highlights
  neon_blue = "#00D4FF",    -- Neon blue for active elements
  bg_dark = "#1A1B26",      -- Dark tactical background
}

-- Navic setup
navic.setup({
  icons = icons.kind or {
    File = "📄 ",
    Module = "📦 ",
    Namespace = "🛡️ ",
    Package = "📚 ",
    Class = "🏛️ ",
    Method = "⚙️ ",
    Property = "🏷️ ",
    Field = "🌾 ",
    Constructor = "🛠️ ",
    Enum = "🔢 ",
    Interface = "🔗 ",
    Function = "λ ",
    Variable = "📋 ",
    Constant = "🔒 ",
    String = "🧵 ",
    Number = "🔟 ",
    Boolean = "🔲 ",
    Array = "📑 ",
    Object = "🗳️ ",
    Key = "🔑 ",
    Null = "∅ ",
    EnumMember = "⚓ ",
    Struct = "🏗️ ",
    Event = "⚡ ",
    Operator = "➕ ",
    TypeParameter = "📐 ",
  },

  highlight = true,                -- Enable highlight groups
  separator = " ❯ ",               -- Rounded, chevron-style separator
  depth_limit = 5,                 -- Limit depth for brevity
  depth_limit_indicator = "…",     -- Soft ellipsis for overflow
  safe_output = true,              -- Prevent errors in winbar
})

-- Custom winbar with rounded styling
vim.opt.winbar = "%#NavicBackground# %{%v:lua.require'nvim-navic'.get_location()%} "

-- Define XCOM-inspired highlights
vim.api.nvim_set_hl(0, "NavicBackground", { bg = xcom_theme.bg_dark, fg = xcom_theme.fg_white })
vim.api.nvim_set_hl(0, "NavicIconsFile", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsModule", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsNamespace", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsPackage", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsClass", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsMethod", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsProperty", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsField", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsConstructor", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsEnum", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsInterface", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsFunction", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsVariable", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsConstant", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsString", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsNumber", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsBoolean", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsArray", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsObject", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsKey", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsNull", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsStruct", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsEvent", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicIconsOperator", { fg = xcom_theme.neon_blue })
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicSeparator", { fg = xcom_theme.neon_orange })
vim.api.nvim_set_hl(0, "NavicText", { fg = xcom_theme.fg_white })

-- Notify on successful setup
vim.schedule(function()
  vim.notify("Navic: Tactical breadcrumbs deployed", vim.log.levels.INFO, { title = "XCOM HUD" })
end)
