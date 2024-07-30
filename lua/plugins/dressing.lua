-- Pretty message boxes. For example when you want to rename a variable.
PLUGINS.dressing = {
  packer = { 'stevearc/dressing.nvim' },
  setup = function() require("dressing").setup() end,
  prio = 150,
}
