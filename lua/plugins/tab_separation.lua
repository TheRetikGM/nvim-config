return {
  'tiagovla/scope.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  init = function()
    -- Extension to allow the usage of the plugin with session managers.
    -- -- for it to work with session restore???
    vim.opt.sessionoptions = {
      "buffers",
      "tabpages",
      "globals",
    }
  end,
  config = function()
    require('scope').setup({})
    require('telescope').load_extension('scope')
  end,
}
