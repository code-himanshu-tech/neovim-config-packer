-- Configure nvim-ts-autotag for improved HTML/JSX autocompletion
local status_ok, autotag = pcall(require, "nvim-ts-autotag")
if not status_ok then
  return
end

autotag.setup({
  -- Global options
  opts = {
    enable_close = true,            -- Auto close tags
    enable_rename = true,           -- Auto rename pairs of tags
    enable_close_on_slash = true,   -- Auto close on trailing </
    filetypes = {                   -- Enable for these filetypes
      'html', 'xml', 'javascript', 'javascriptreact', 'typescript', 
      'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
      'php', 'markdown', 'astro', 'handlebars', 'hbs', 'heex', 'eruby',
    },
    skip_tags = {                   -- Don't auto-close these tags
      'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 
      'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr'
    }
  },
  
  -- Filetype-specific configurations (overrides global options)
  per_filetype = {
    -- React/Next.js specific settings
    ["typescriptreact"] = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
    ["javascriptreact"] = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
    -- HTML specific settings
    ["html"] = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
  }
})

-- Add autocompletion integration with nvim-cmp if available
local has_cmp, cmp = pcall(require, "cmp")
if has_cmp then
  -- Get the current sources
  local sources = cmp.get_config().sources or {}
  
  -- Add or ensure HTML/tag sources are present
  local has_html_source = false
  for _, source in ipairs(sources) do
    if source.name == "html-css" or source.name == "tagname" or source.name == "emmet_ls" then
      has_html_source = true
      break
    end
  end
  
  -- If no HTML source is present, add emmet and html sources
  if not has_html_source then
    table.insert(sources, { name = "emmet_ls" })
    table.insert(sources, { name = "html-css" })
    
    -- Update cmp configuration
    cmp.setup({
      sources = sources
    })
  end
end

-- Add LSP server configuration for HTML/JSX if not already set up
local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if has_lspconfig then
  -- Check if the emmet and html LSP servers are configured
  local has_emmet = false
  local has_tsserver = false
  
  for server, _ in pairs(lspconfig) do
    if server == "emmet_ls" then has_emmet = true end
    if server == "tsserver" then has_tsserver = true end
  end
  
  -- Add emmet_ls configuration if not already set up
  if not has_emmet then
    lspconfig.emmet_ls.setup({
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "vue", "tsx", "jsx" },
      init_options = {
        html = {
          options = {
            -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts
            ["bem.enabled"] = true,
          },
        },
      }
    })
  end
  
  -- Enhance tsserver for better JSX support if not already configured
  if not has_tsserver then
    lspconfig.tsserver.setup({
      filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
      settings = {
        typescript = {
          suggest = {
            completeFunctionCalls = true,
            includeAutomaticOptionalChainCompletions = true,
            includeCompletionsForImportStatements = true,
          },
        },
        javascript = {
          suggest = {
            completeFunctionCalls = true,
            includeAutomaticOptionalChainCompletions = true,
            includeCompletionsForImportStatements = true,
          },
        },
      }
    })
  end
end
