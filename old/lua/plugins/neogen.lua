-- Doxygen highlights and generation.
PLUGINS.neogen = {
  packer = { 'danymat/neogen' },
  setup = function()
    require('neogen').setup({
      -- snippet_engine = "luasnip",
      snippet_engine = "vsnip"
    })
  end,
  keymaps = function()
    vim.keymap.set('n', '<leader>dg', require('neogen').generate, { desc = "Generate [D]oxy[G]en comments", noremap = true, silent = true, })
  end,
  prio = 20,
}
