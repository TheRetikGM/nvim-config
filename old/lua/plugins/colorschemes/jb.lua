PLUGINS.jb = {
  packer = { 'nickkadutskyi/jb.nvim' },
  setup = function()
    U.add_light_dark_variants('jb', 'jb', {})
  end,
  prio = -41, -- before lualine
}
