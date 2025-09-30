-- Fancier statusline
PLUGINS.lualine = {
  packer = 'nvim-lualine/lualine.nvim',
  setup = function()
    vim.o.laststatus = 3
    -- See `:help lualine.txt`
    require('lualine').setup {
      -- Unused because of noice config alternative
      -- sections = {
      --   lualine_x = {
      --     { -- show @recording messages in lualine
      --       require("noice").api.status.mode.get,
      --       cond = require("noice").api.status.mode.has,
      --       color = { fg = "#ff9e64" },
      --     },
      --   },
      -- },
      options = {
        icons_enabled = true,
        theme = LUALINE_THEME,
        component_separators = '|',
        section_separators = '',
      },
    }
  end,
  prio = -40,
}
