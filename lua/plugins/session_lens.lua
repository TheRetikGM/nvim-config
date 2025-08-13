-- Manage sessions
PLUGINS.session_lens = {
  packer = {
    'rmagatti/session-lens',
    requires = {'nvim-telescope/telescope.nvim'},
  },
  keymaps = function()
    vim.keymap.set('n', '<leader>rs', function() vim.cmd('SessionRestore') end, { desc = '[R]estore [S]ession' })
  end,
  after = 'auto_session',
  prio = 90,
}
