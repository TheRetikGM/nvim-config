-- "gc" to comment visual regions/lines
PLUGINS.comment = {
  packer = 'numToStr/Comment.nvim',
  setup = function() require('Comment').setup() end,
  prio = -20,
}
