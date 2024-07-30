-- Close buffers without messing up the layout
PLUGINS.bufdelete = {
  packer = { 'famiu/bufdelete.nvim' },
  keymaps = function()
    vim.keymap.set('n', '<leader>c', ':Bwipeout<cr>', { desc = 'Close current buffer' })
    vim.keymap.set('n', '<leader>cc', ':Bwipeout!<cr>', { desc = 'Forcefuly Close current buffer' })
    vim.keymap.set('n', '<leader>q', ':Bwipeout!<cr>', { desc = 'Forcefuly Close current buffer' })
  end,
  prio = 40,
}
