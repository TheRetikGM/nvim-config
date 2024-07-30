PLUGINS.label_jump = {
  packer = { 'folke/flash.nvim' },
  setup = function()
    require('flash').setup()
  end,
  keymaps = function()
    local flash = require('flash')
    vim.keymap.set('n', '<leader>j', flash.jump, { desc = "[J]ump to label" })
  end
}
