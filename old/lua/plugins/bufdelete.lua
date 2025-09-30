-- Close buffers without messing up the layout
PLUGINS.bufdelete = {
  packer = { 'famiu/bufdelete.nvim' },
  keymaps = function()
    vim.keymap.set('n', '<leader>c', function() vim.cmd('Bwipeout') end, { desc = 'Close current buffer' })
    vim.keymap.set('n', '<leader>cc', function() vim.cmd('Bwipeout!') end, { desc = 'Forcefuly Close current buffer' })
    vim.keymap.set('n', '<leader>q', function() vim.cmd('Bwipeout!') end, { desc = 'Forcefuly Close current buffer' })
  end,
  prio = 40,
}
