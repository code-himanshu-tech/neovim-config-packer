local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end
-- Setup comment plugin with multi-language support
comment.setup({
  -- Enable context-aware commenting for different filetypes
  pre_hook = function(ctx)
    -- Get the language context
    local U = require("Comment.utils")
    
    -- Handle JSX/TSX files with special context awareness
    if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
      local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"
      
      local location = nil
      if ctx.ctype == U.ctype.blockwise then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end
      
      return require("ts_context_commentstring.internal").calculate_commentstring({
        key = type,
        location = location,
      })
    end
    
    -- For all other filetypes, use standard commenting
    return require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()(ctx)
  end,
  
  -- Additional comment configuration options
  padding = true,          -- Add a space between comment and text
  sticky = true,           -- Whether the cursor should stay at its position
  ignore = nil,            -- Lines to be ignored while (un)comment
  toggler = {              -- LHS of toggle mappings in NORMAL mode
    line = 'gcc',          -- Line-comment toggle keymap
    block = 'gbc',         -- Block-comment toggle keymap
  },
  opleader = {             -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    line = 'gc',           -- Line-comment keymap
    block = 'gb',          -- Block-comment keymap
  },
  mappings = {
    basic = true,          -- Enable default mappings
    extra = true,          -- Enable extra mappings
  },
})

local status_highlight, _ = pcall(function()
  vim.cmd([[
    augroup CommentHighlight
      autocmd!

      " Set comment highlight with blue background and yellow border
      autocmd FileType * highlight Comment guibg=#4d4dff guifg=#ffff00 gui=bold
    augroup END
  ]])
end)

if not status_highlight then
  vim.notify("Failed to set comment highlighting", vim.log.levels.WARN)
end

-- Set up specific filetype associations
vim.cmd([[
  " Ensure .tsx files are properly detected
  autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
  
  " Ensure Next.js pages are properly detected
  autocmd BufNewFile,BufRead */pages/*.js,*/pages/*.jsx,*/pages/*.ts,*/pages/*.tsx set filetype=typescriptreact
]])

