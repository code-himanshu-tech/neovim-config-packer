-- File: ~/.config/nvim/lua/plugins.lua (or wherever you manage your plugins)
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- nvim-web-devicons for file icons
  use {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        -- Customize icons here (optional)
        override = {
          -- Example: Custom icon for JavaScript files
          js = {
            icon = "󰌞",
            color = "#ffca28",
            name = "JavaScript",
          },
          -- Add more custom icons as needed
        },
        default = true, -- Enable default icons
      })
    end,
  }

  -- Optional: Add nvim-tree for file explorer with icons
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- Dependency for icons
    },
    config = function()
      require('nvim-tree').setup({
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "", -- Default folder icon
              symlink = "󰉒", -- Symlink folder icon
              folder = {
                arrow_closed = "", -- Closed folder arrow
                arrow_open = "", -- Open folder arrow
                default = "", -- Default folder icon
                open = "", -- Open folder icon
                empty = "󰉖", -- Empty folder icon
                empty_open = "󰷏", -- Empty open folder icon
                symlink = "󰉒", -- Symlink folder icon
                symlink_open = "󰉒", -- Symlink open folder icon
              },
              git = {
                unstaged = "󰄱", -- Unstaged changes icon
                staged = "󰄴", -- Staged changes icon
                unmerged = "󰘬", -- Unmerged changes icon
                renamed = "󰁕", -- Renamed file icon
                untracked = "󰞒", -- Untracked file icon
                deleted = "󰩹", -- Deleted file icon
                ignored = "󰛑", -- Ignored file icon
              },
            },
          },
          highlight_git = true,
          highlight_opened_files = "all",
          indent_markers = {
            enable = true,
          },
        },
      })
    end,
  }
end)
