-- Add indentation guides even on blank lines
PLUGINS.indent_blankline = {
  packer = 'lukas-reineke/indent-blankline.nvim',
  setup = function()
    require("ibl").setup{
      scope = {
        show_start = false,
      }
    }
  end
}
