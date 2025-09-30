return {
  setup = function()
    local bufremove = require('mini.bufremove')
    bufremove.setup()

    vim.keymap.set('n', '<leader>c', function() bufremove.wipeout() end, { desc = 'Close current buffer' })
    vim.keymap.set('n', '<leader>cc', function() bufremove.wipeout(0, true) end, { desc = 'Forcefuly Close current buffer' })
    vim.keymap.set('n', '<leader>q', function() bufremove.wipeout(0, true) end, { desc = 'Forcefuly Close current buffer' })
  end
}
