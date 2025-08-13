-- Cool notifications
PLUGINS.notify = {
  packer = { 'rcarriga/nvim-notify' },
  setup = function()
    local notify = require('notify')

    notify.setup {
      background_colour = "#000000",
      merge_duplicates = true
    }

    vim.notify = notify
  end
}
