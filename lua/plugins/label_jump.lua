return {
  enabled = true,
  'folke/flash.nvim',
  config = function()
    local flash = require('flash')

    flash.setup({
      label = {
        uppercase = false,      -- Dont make uppercase labels (I don't want to press shift)
        format = function(opts) -- Make label visuals uppercase to make them easier to see sometimes
          return { { string.upper(opts.match.label), opts.hl_group } }
        end
      },
      modes = {
        char = {
          enabled = false, -- Do not use the `f`, `F`, `t`, `T`, `;` and `,` motions, because we use mini.jump plugin for that
        }
      }
    })

    vim.keymap.set('n', '<leader>j', flash.jump, { desc = "[J]ump to label" })
  end,
}
