require('../plugin_common.lua')

-- Automaticaly expand pairs
-- Before        Input         After
-- ------------------------------------
-- {|}           <CR>          {
--                                |
--                             }
-- ------------------------------------
PLUGINS.autopairs = {
  packer = { 'windwp/nvim-autopairs' },
  setup = function()
    require('nvim-autopairs').setup{}
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
  after = 'cmp',
}

