-- Learn vim the hard way
PLUGINS.hardtime = {
  packer = 'm4xshen/hardtime.nvim',
  setup = function()
    require("hardtime").setup{
      disabled_keys = {
        ["<Up>"] = false,
        ["<Down>"] = false,
        ["<Left>"] = false,
        ["<Right>"] = false,
      }
    }
  end,
}
