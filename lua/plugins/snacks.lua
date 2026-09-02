local function cmd(name, fn)
  vim.api.nvim_create_user_command(name, function() fn() end, { nargs = 0 })
end

--  Similar to mini.nvim
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    indent = { enabled = false },
    input = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          auto_close = false,
        },
        -- lsp_references = {
        --   -- Dock the references picker as a bottom split, and keep it open
        --   -- when jumping so you can hop between references without reopening.
        --   layout = { preset = "ivy_split" },
        --   jump = { close = false },
        --   confirm = "jump"
        -- },
      }
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = true },
  },
  config = function(_, opts)
    local snacks = require('snacks')
    snacks.setup(opts)

    cmd('SelectInExplorer', snacks.explorer.reveal)
    cmd('Pickers', snacks.picker)
    cmd('ClipHistPicker', snacks.picker.cliphist)
    cmd('GitLogPicker', snacks.picker.git_log)
    cmd('FilesPicker', snacks.picker.files)
    cmd('DiagAllPicker', snacks.picker.diagnostics)
    cmd('DiagPicker', snacks.picker.diagnostics_buffer)
    cmd('JumpPicker', snacks.picker.jumps)
    cmd('LspConfigPicker', snacks.picker.lsp_config)
    cmd('NotificationsPicker', snacks.picker.notifications)
    cmd('IncomingCallsPicker', snacks.picker.lsp_incoming_calls)
    cmd('OutgoingCallsPicker', snacks.picker.lsp_outgoing_calls)
  end
}
