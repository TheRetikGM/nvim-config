PLUGINS.label_jump = {
  packer = { 'folke/flash.nvim' },
  setup = function()
    require('flash').setup({
      label = {
        uppercase = false, -- Dont make uppercase labels (I don't want to press shift)
        format = function(opts) -- Make label visuals uppercase to make them easier to see sometimes
          return { { string.upper(opts.match.label), opts.hl_group } }
        end
      }
    })
  end,
  keymaps = function()
    local flash = require('flash')
    vim.keymap.set('n', '<leader>j', flash.jump, { desc = "[J]ump to label" })
  end
}
