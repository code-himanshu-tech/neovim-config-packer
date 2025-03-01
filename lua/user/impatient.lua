-- Attempt to load the 'impatient' module to speed up Neovim startup
local status_ok, impatient = pcall(require, "impatient")
if status_ok then
  impatient.enable_profile()
else
  -- Optionally, you can print a message or log the error if 'impatient' fails to load
  vim.notify("Failed to load 'impatient' module. Startup might be slower.", vim.log.levels.WARN)
end
