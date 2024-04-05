-- Fancier statusline
PLUGINS.lualine = {
  packer = 'nvim-lualine/lualine.nvim',
  setup = function()
    -- See `:help lualine.txt`
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'vscode',
        component_separators = '|',
        section_separators = '',
      },
    }
  end
}
