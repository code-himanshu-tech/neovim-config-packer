local present, cmp = pcall(require, "cmp")
if not present then
  return
end

local luasnip_present, luasnip = pcall(require, "luasnip")
if not luasnip_present then
  return
end

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./cool_snippets" } })
require("luasnip.loaders.from_vscode").lazy_load()

-- Set completeopt for better completion behavior
vim.opt.completeopt = "menu,menuone,noselect"

-- Custom border function
local function border(hl_name)
  return {
    { "╭", hl_name }, { "─", hl_name }, { "╮", hl_name },
    { "│", hl_name }, { "╯", hl_name }, { "─", hl_name },
    { "╰", hl_name }, { "│", hl_name },
  }
end

-- Override cmp window info to disable scrolling
local cmp_window = require("cmp.utils.window")
cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
  local info = self:info_()
  info.scrollable = false
  return info
end

-- Default icons if user.icons is unavailable
local icons = require("user.icons") or {
  kind = {
    Text = "", Method = "m", Function = "󰊕", Constructor = "",
    Field = "", Variable = "󰆧", Class = "󰌗", Interface = "",
    Module = "", Property = "", Unit = "", Value = "󰎠",
    Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
    File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
    Constant = "󰇽", Struct = "", Event = "", Operator = "󰆕",
    TypeParameter = "󰊄",
  },
}

-- Main cmp configuration
cmp.setup({
  -- Snippet expansion
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- Window styling
  window = {
    completion = {
      border = border("CmpBorder"),
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,FloatBorder:CmpBorder,Search:None",
      col_offset = -3, -- Adjust for kind icon spacing
      side_padding = 0,
    },
    documentation = {
      border = border("CmpDocBorder"),
      winhighlight = "Normal:CmpPmenu,FloatBorder:CmpDocBorder",
    },
  },

  -- Formatting with icons and source info
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = vim_item.kind
      vim_item.kind = " " .. (icons.kind[kind] or "") .. " "
      vim_item.menu = ({
        nvim_lsp = "󰌖 LSP",
        nvim_lua = "󰢱 Lua",
        luasnip = " Snippet",
        buffer = "󰓩 Buffer",
        path = "󰛗 Path",
        npm = "󰏗 NPM",
        cmdline = "󰘳 Cmd",
      })[entry.source.name] or ""
      return vim_item
    end,
  },

  -- Key mappings
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true, -- Accept first suggestion if none selected
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  -- Sources with priority
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip", priority = 750 },
    { name = "nvim_lua", priority = 500 },
    { name = "path", priority = 250 },
    { name = "buffer", priority = 100 },
    { name = "npm", keyword_length = 4, priority = 200 },
  }),

  -- Experimental features
  experimental = {
    ghost_text = { hl_group = "Comment" }, -- Subtle ghost text
  },
})

-- Cmdline completions
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
  }),
})

-- Setup cmp-npm
require("cmp-npm").setup({})
