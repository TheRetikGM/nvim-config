-- Pretty folding
PLUGINS.ufo = {
  packer = { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' },
  init = function()
    -- Enable treesitter folding using nvim-ufo
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  setup = function()
    require('ufo').setup({
      provider_selector = function(_, _, _)
        return {'treesitter', 'indent'}
      end
    })
  end,
  keymaps = function()
    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  end,
  prio = 10,
}
