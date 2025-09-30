LUALINE_THEME = 'habamax'

-- Fancier statusline
return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = true,
      theme = LUALINE_THEME,
      component_separators = '|',
      section_separators = '',
    },
  },
  init = function()
    vim.o.laststatus = 3
  end,
}
