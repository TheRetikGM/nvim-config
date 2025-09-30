PLUGINS.scope = {
  packer = { 'tiagovla/scope.nvim' },
  init = function()
    -- Extension to allow the usage of the plugin with session managers.
    -- -- for it to work with session restore???
    vim.opt.sessionoptions = {
      "buffers",
      "tabpages",
      "globals",
    }
  end,
  setup = function()
    require('scope').setup({})
    require('telescope').load_extension('scope')
  end,
  keymaps = function() end,
  prio = 99,  -- Before auto_session
}
