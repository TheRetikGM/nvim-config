-- Move lines and blocks around
PLUGINS.move = {
  packer = { 'fedepujol/move.nvim' },
  setup = function() require('move').setup() end,
  keymaps = function()
    vim.keymap.set('n', '<A-j>', function() vim.cmd('MoveLine(1)') end, { desc = 'Move line up' })
    vim.keymap.set('n', '<A-k>', function() vim.cmd('MoveLine(-1)') end, { desc = 'Move line down' })
    vim.keymap.set('n', '<A-h>', function() vim.cmd('MoveHChar(1)') end, { desc = 'Move character right' })
    vim.keymap.set('n', '<A-h>', function() vim.cmd('MoveHChar(-1)') end, { desc = 'Move character left' })
    vim.keymap.set('v', '<A-j>', function() vim.cmd('MoveBlock(1)') end, { desc = 'Move block up' })
    vim.keymap.set('v', '<A-k>', function() vim.cmd('MoveBlock(-1)') end, { desc = 'Move block down' })
    vim.keymap.set('v', '<A-h>', function() vim.cmd('MoveHBlock(1)') end, { desc = 'Move block right' })
    vim.keymap.set('v', '<A-h>', function() vim.cmd('MoveHBlock(1)') end, { desc = 'Move block right' })
  end,
  prio = 60,
}
