-- Detect nested neovim sessions and open them in the parent instsance instead
PLUGINS.flatten = {
  ignore = false,
  packer = { 'willothy/flatten.nvim' },
  setup = function()
    require('flatten').setup({
      window = {
        open = 'current',
      }
    })
  end,
}
