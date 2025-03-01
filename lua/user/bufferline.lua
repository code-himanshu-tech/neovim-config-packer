local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

local M = {}

-- Assuming icons are defined elsewhere; if not, we'll use defaults
local icons = require("user.icons") or {
  ui = {
    BoldLineLeft = "▎",
    Close = "✕",
    Circle = "●",
    BoldClose = "✕",
    ArrowCircleLeft = "◄",
    ArrowCircleRight = "►",
  },
}

-- Buffer kill function
function M.buf_kill(kill_command, bufnr, force)
  kill_command = kill_command or "bd"
  local bo = vim.bo
  local api = vim.api
  local fmt = string.format
  local fn = vim.fn

  bufnr = bufnr or api.nvim_get_current_buf()
  local bufname = api.nvim_buf_get_name(bufnr)

  if not force then
    local choice
    if bo[bufnr].modified then
      choice = fn.confirm(fmt([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")
      if choice == 1 then
        api.nvim_buf_call(bufnr, function()
          vim.cmd("w")
        end)
      elseif choice == 2 then
        force = true
      else
        return
      end
    elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
      choice = fn.confirm(fmt([[Close "%s"?]], bufname), "&Yes\n&No\n&Cancel")
      if choice == 1 then
        force = true
      else
        return
      end
    end
  end

  local windows = vim.tbl_filter(function(win)
    return api.nvim_win_get_buf(win) == bufnr
  end, api.nvim_list_wins())

  if force then
    kill_command = kill_command .. "!"
  end

  local buffers = vim.tbl_filter(function(buf)
    return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
  end, api.nvim_list_bufs())

  if #buffers > 1 and #windows > 0 then
    for i, v in ipairs(buffers) do
      if v == bufnr then
        local prev_buf_idx = i == 1 and #buffers or (i - 1)
        local prev_buffer = buffers[prev_buf_idx]
        for _, win in ipairs(windows) do
          api.nvim_win_set_buf(win, prev_buffer)
        end
      end
    end
  end

  if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
    vim.cmd(fmt("%s %d", kill_command, bufnr))
  end
end

-- Diagnostics indicator
local function diagnostics_indicator(count, level)
  local icon = level:match("error") and " " or " "
  return " " .. icon .. " " .. count
end

-- Consolidated bufferline setup
bufferline.setup {
  options = {
    mode = "buffers",
    numbers = "none",
    close_command = function(bufnr)
      M.buf_kill("bd", bufnr, false)
    end,
    right_mouse_command = "vert sbuffer %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    
    -- Indicator and icons
    indicator = {
      icon = icons.ui.BoldLineLeft,
      style = "icon",
    },
    buffer_close_icon = icons.ui.Close,
    modified_icon = icons.ui.Circle,
    close_icon = icons.ui.BoldClose,
    left_trunc_marker = icons.ui.ArrowCircleLeft,
    right_trunc_marker = icons.ui.ArrowCircleRight,
    
    -- Buffer name formatting
    name_formatter = function(buf)
      if buf.name:match "%.md" then
        return vim.fn.fnamemodify(buf.name, ":t:r")
      end
      return buf.name
    end,
    max_name_length = 18,
    max_prefix_length = 15,
    truncate_names = true,
    tab_size = 18,
    
    -- Diagnostics
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = diagnostics_indicator,
    
    -- Offsets for side panels
    offsets = {
      { filetype = "undotree", text = "Undotree", highlight = "PanelHeading", padding = 1 },
      { filetype = "NvimTree", text = "Explorer", highlight = "PanelHeading", padding = 1 },
      { filetype = "DiffviewFiles", text = "Diff View", highlight = "PanelHeading", padding = 1 },
      { filetype = "flutterToolsOutline", text = "Flutter Outline", highlight = "PanelHeading" },
      { filetype = "lazy", text = "Lazy", highlight = "PanelHeading", padding = 1 },
    },
    
    -- Appearance and behavior
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = false,
    
    -- Hover effects
    hover = {
      enabled = true,
      delay = 200,
      reveal = { "close" },
    },
    
    sort_by = "id",
  },
  
  -- Highlights
  highlights = {
    background = {
      italic = true,
    },
    buffer_selected = {
      bold = true,
    },
  },
}

return M
