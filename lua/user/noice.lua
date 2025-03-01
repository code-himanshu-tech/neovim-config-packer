local present, noice = pcall(require, "noice")

if not present then
  return
end

noice.setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    opts = {
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      position = {
        row = "50%",
        col = "50%",
      },
    },
  },
  format = {
    icons = {
      ["/"] = { icon = " ", hl_group = "DiagnosticWarn" },
      ["?"] = { icon = " ", hl_group = "DiagnosticWarn" },
      [":"] = { icon = " ", hl_group = "DiagnosticInfo" },
      ["!"] = { icon = " ", hl_group = "DiagnosticError" },
      ["="] = { icon = "󰨞 ", hl_group = "DiagnosticInfo" },
    },
    cmdline = { pattern = "^:", icon = "", lang = "vim" },
    search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
    search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
    filter = { pattern = "^:%s*!", icon = " ", lang = "bash" },
    lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
    help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
  },
  views = {
    cmdline_popup = {
      size = {
        width = "40%",
        height = "auto",
      },
      win_options = {
        winhighlight = {
          Normal = "NormalFloat",
          FloatBorder = "FloatBorder",
        },
      },
    },
    popupmenu = {
      relative = "editor",
      size = {
        width = "40%",
        height = "auto",
      },
      win_options = {
        winhighlight = {
          Normal = "NormalFloat",
          FloatBorder = "FloatBorder",
        },
      },
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    {
      filter = {
        event = "msg_show",
        kind = "search_count",
      },
      opts = { skip = true },
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = true,
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = {
      enabled = true,
      view = "hover",
      opts = {
        border = "rounded",
        size = {
          max_width = 80,
          max_height = 20,
        },
      },
    },
    signature = {
      enabled = true,
      view = "hover",
      opts = {
        border = "rounded",
      },
    },
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  messages = {
    enabled = true,
    view = "mini",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = "virtualtext",
  },
  popupmenu = {
    enabled = true,
    backend = "cmp",
  },
  smart_move = {
    enabled = true,
    excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
  },
})
