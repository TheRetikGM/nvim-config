return {
  setup = function()
    vim.o.laststatus = 3
    require('mini.statusline').setup()
  end
}
