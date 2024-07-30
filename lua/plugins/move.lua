-- Move lines and blocks around
PLUGINS.move = {
  packer = { 'fedepujol/move.nvim' },
  setup = function() require('move').setup() end,
  keymaps = function()
    vim.keymap.set('n', '<A-j>', ':MoveLine(1)<cr>', { desc = 'Move line up' })
    vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<cr>', { desc = 'Move line down' })
    vim.keymap.set('n', '<A-h>', ':MoveHChar(1)<cr>', { desc = 'Move character right' })
    vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<cr>', { desc = 'Move character left' })
    vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<cr>', { desc = 'Move block up' })
    vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<cr>', { desc = 'Move block down' })
    vim.keymap.set('v', '<A-h>', ':MoveHBlock(1)<cr>', { desc = 'Move block right' })
    vim.keymap.set('v', '<A-h>', ':MoveHBlock(1)<cr>', { desc = 'Move block right' })
  end,
  prio = 60,
}
