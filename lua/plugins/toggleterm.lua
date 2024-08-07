-- Terminal
PLUGINS.toggleterm = {
  packer = { 'akinsho/toggleterm.nvim', tag = '*' },
  setup = function() require('toggleterm').setup() end,
  keymaps = function()
    vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=horizontal<cr>', { desc = 'Toggle bottom terminal' })
    vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<cr>', { desc = 'Toggle floating terminal' })
    vim.keymap.set('n', '<F7>', ':ToggleTerm<cr>', { desc = 'Toggle terminal' })
    vim.keymap.set('t', '<F7>', [[<cmd>ToggleTerm<cr>]], { desc = 'Toggle terminal' })
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Escape from terminal mode' })
    vim.keymap.set('t', '<C-h>', [[<esc><cmd>wincmd h<cr>]], { desc = 'Move to left split' })
    vim.keymap.set('t', '<C-j>', [[<esc><cmd>wincmd j<cr>]], { desc = 'Move to down split' })
    vim.keymap.set('t', '<C-k>', [[<esc><cmd>wincmd k<cr>]], { desc = 'Move to up split' })
    vim.keymap.set('t', '<C-l>', [[<esc><cmd>wincmd l<cr>]], { desc = 'Move to right split' })
  end,
  prio = 70,
}
