-- Manage sessions
PLUGINS.session_lens = {
  packer = {
    'rmagatti/session-lens',
    requires = {'nvim-telescope/telescope.nvim'},
  },
  keymaps = function()
    vim.keymap.set('n', '<leader>ss', ':SearchSession<cr>', { desc = '[S]earch [S]ession' })
    vim.keymap.set('n', '<leader>rs', ':SessionRestore<cr>', { desc = '[R]estore [S]ession' })
  end,
  after = 'auto_session',
}
