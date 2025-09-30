-- Requred by session-lens
PLUGINS.auto_session = {
  packer = {
    'rmagatti/auto-session',
  },
  setup = function()
    require('auto-session').setup {
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
  end,
  prio = 100,
}
