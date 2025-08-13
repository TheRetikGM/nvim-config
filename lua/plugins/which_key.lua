PLUGINS.which_key = {
  packer = { 'folke/which-key.nvim' },
  keymaps = function()
    vim.keymap.set('n', '<leader>?', function() require('which-key').show({ global = false }) end, { desc = 'Buffer Local Keymaps (which-key)' })
  end
}
