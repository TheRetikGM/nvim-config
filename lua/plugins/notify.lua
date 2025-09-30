-- Cool notifications
-- NOTE: Disabled because noice.nvim interferes with mini lsp windows and
--       there is no other reason to use this plugin instead of
--       mini.notify when we aren't using noice also
return {
  'rcarriga/nvim-notify',
  enabled = true,
  opts = {
    background_colour = "#000000",
    merge_duplicates = true
  },
  config = function()
    vim.notify = require('notify')
  end
}
