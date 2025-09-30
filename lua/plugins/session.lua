return {
  {
    'rmagatti/session-lens',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      vim.keymap.set('n', '<leader>rs', function() vim.cmd('AutoSession restore') end, { desc = '[R]estore [S]ession' })
    end,
  },
  {
    'rmagatti/auto-session',
    opts = {
      auto_save_enabled = true,
      pre_save_cmds = {
        'Neotree action=close',
        "lua require 'dapui'.close()",
        'ScopeSaveState', -- Save state of scope.nvim
      },
      auto_restore_enabled = false,
      post_restore_cmds = {
        'ScopeLoadState' -- Load state of scope.nvim
      }
    }
  },
}
