neotree_open = false -- used by dapui
function neotree_toggle(_)
  neotree_open = not neotree_open
  vim.cmd('Neotree toggle')
end

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,                    -- neo-tree will lazily load itself
    opts = {
    },
    config = function(lazy_plugin, opts)
      require('neo-tree').setup({
        source_selector = {
          winbar = true, -- toggle to show selector on winbar
          statusline = false, -- toggle to show selector on statusline
          show_scrolled_off_parent_node = false, -- boolean
          sources = { -- table
            {
              source = "filesystem", -- string
              display_name = " 󰉓 Files " -- string | nil
            },
            {
              source = "git_status", -- string
              display_name = " 󰊢 Git " -- string | nil
            },
            {
              source = "document_symbols",
              display_name = "   Symbols "
            }
          },
          content_layout = "start", -- string
          tabs_layout = "equal", -- string
          truncation_character = "…", -- string
          tabs_min_width = nil, -- int | nil
          tabs_max_width = nil, -- int | nil
          padding = 0, -- int | { left: int, right: int }
          separator = { left = "▏", right = "▕" }, -- string | { left: string, right: string, override: string | nil }
          separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
          show_separator_on_edge = false, -- boolean
          highlight_tab = "NeoTreeTabInactive", -- string
          highlight_tab_active = "NeoTreeTabActive", -- string
          highlight_background = "NeoTreeTabInactive", -- string
          highlight_separator = "NeoTreeTabSeparatorInactive", -- string
          highlight_separator_active = "NeoTreeTabSeparatorActive", -- string
        },
      })

      vim.keymap.set('n', '<leader>e', neotree_toggle, { desc = 'Toggle File [E]xplorer' })

      vim.api.nvim_create_user_command('SelectInExplorer', function()
        vim.cmd('Neotree reveal_force_cwd')
      end, { nargs = 0 })
    end
  }
}
