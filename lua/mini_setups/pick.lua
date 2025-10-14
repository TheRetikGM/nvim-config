return {
  setup = function()
    local minipick = require('mini.pick')
    minipick.setup({
      options = {
        use_cache = true,
      }
   })

    vim.keymap.set('n', '<leader>sf', function() vim.cmd('Pick files tool=git') end, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sb', function() vim.cmd('Pick buffers') end, { desc = '[S]earch [B]uffers' })
    -- vim.keymap.set('n', '<leader>sg', function() vim.cmd('Pick grep_live') end, { desc = '[S]earch with [G]rep' })
    vim.keymap.set('n', '<leader>sh', function() minipick.builtin.help() end, { desc = '[S]earch [H]elp' })

    -- NOTE: Also used in the ON_LSP_ATTACH mappings
    local miniextra = require('mini.extra')
    miniextra.setup()
    local ext = miniextra.pickers

    vim.keymap.set('n', '<leader><leader>', function() ext.commands() end, { desc = 'Search commands' })
    vim.keymap.set('n', '<leader>sd', function() ext.diagnostic() end, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sk', function() ext.keymaps() end, { desc = '[S]earch [K]eymaps' })
  end
}

