-- Pretty folding
return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async'
  },
  opts = {
    provider_selector = function(_, _, _)
      return { 'treesitter', 'indent' }
    end
  },
  lazy = false,
  priority = 1001, -- Before treesitter
  init = function()
    -- Enable treesitter folding using nvim-ufo
    vim.o.foldcolumn = '0' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  keys = {
    -- {'zR', require('nvim-ufo').openAllFolds, mode = 'n', desc = 'Open all folds'},
    -- {'zM', require('nvim-ufo').closeAllFolds, mode = 'n', desc = 'Close all folds'}
  },
  config = true   -- When config = true or opts is set, the default require(MAIN).config(opts) is used here.
}
