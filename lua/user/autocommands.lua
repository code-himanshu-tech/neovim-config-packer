-- Group related autocommands for better organization and performance
local autocmd_group = vim.api.nvim_create_augroup("CustomAutocommands", { clear = true })

-- Helper function to create autocommands with less repetition
local function create_autocmd(events, pattern, callback_or_command)
  local options = { group = autocmd_group }
  
  if type(pattern) == "table" or type(pattern) == "string" then
    options.pattern = pattern
  end
  
  if type(callback_or_command) == "function" then
    options.callback = callback_or_command
  else
    options.command = callback_or_command
  end
  
  vim.api.nvim_create_autocmd(events, options)
end

-- File type specific configurations
create_autocmd("FileType", { "qf", "help", "man", "lspinfo", "spectre_panel" }, function()
  vim.keymap.set("n", "q", ":close<CR>", { buffer = true, silent = true })
  vim.opt_local.buflisted = false
end)

create_autocmd("FileType", { "gitcommit", "markdown" }, function()
  vim.opt_local.wrap = true
  vim.opt_local.spell = true
end)

-- Window and buffer management
create_autocmd("BufEnter", "*", function()
  -- Auto-close NvimTree if it's the last window
  if vim.fn.winnr("$") == 1 and vim.fn.bufname():match("^NvimTree_" .. vim.fn.tabpagenr()) then
    vim.cmd("quit")
  end
end)

create_autocmd("VimResized", "*", "tabdo wincmd =")

-- Prevent command window from opening (often triggered accidentally)
create_autocmd("CmdWinEnter", "*", "quit")

-- Formatting options and highlighting
create_autocmd("BufWinEnter", "*", function()
  -- Prevent automatic comment insertion on new lines
  vim.opt_local.formatoptions:remove({ "c", "r", "o" })
end)

create_autocmd("TextYankPost", "*", function()
  vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
end)

-- LSP specific commands
create_autocmd("BufWritePost", "*.java", function()
  vim.lsp.codelens.refresh()
end)

-- Theme and highlighting adjustments
create_autocmd("VimEnter", "*", function()
  vim.cmd("hi link illuminatedWord LspReferenceText")
end)

-- Add smart indent for specific file types
create_autocmd("FileType", { "python", "rust", "typescript", "go" }, function()
  vim.opt_local.smartindent = true
  vim.opt_local.expandtab = true
  vim.opt_local.shiftwidth = 4
end)

-- Terminal-specific settings
create_autocmd("TermOpen", "*", function()
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.cmd("startinsert")
end)

-- Restore cursor position when reopening files
create_autocmd("BufReadPost", "*", function()
  if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
    vim.cmd('normal! g`"')
  end
end)
