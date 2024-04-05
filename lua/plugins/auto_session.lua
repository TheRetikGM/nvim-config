-- Requred by session-lens
PLUGINS.auto_session = {
  packer = {
    'rmagatti/auto-session',
    -- There was a bug when some file was renamed and it didn't work
    commit = '8b43922b893790a7f79951d4616369128758d215'
  },
  setup = function()
    require('auto-session').setup {
      auto_save_enabled = true,
      pre_save_cmds = { 'Neotree action=close', "lua require 'dapui'.close()" },
      auto_restore_enabled = false,
    }
  end,
}
