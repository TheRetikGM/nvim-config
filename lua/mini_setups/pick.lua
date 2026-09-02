return {
  setup = function()
    require('mini.pick').setup({
      options = {
        use_cache = true,
      }
    })
    require('mini.extra').setup()
  end
}

