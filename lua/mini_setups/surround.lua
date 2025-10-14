return {
  setup = function()
    require('mini.surround').setup({
      -- Number of lines within which surrounding is searched
      n_lines = 60
    })
  end
}
