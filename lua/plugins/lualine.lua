-- Fancier statusline
PLUGINS.lualine = {
  packer = 'nvim-lualine/lualine.nvim',
  setup = function()
    vim.o.laststatus = 3
    -- See `:help lualine.txt`
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'vscode',
        component_separators = '|',
        section_separators = '',
      },
    }
  end,
  prio = -40,
}
