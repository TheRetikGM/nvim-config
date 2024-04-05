-- Table containing most of custom plugins and their setups
PLUGINS = {}

PLUGIN_TEMPLATE = {
  -- Table to pass to Packer's `use` function.
  packer = {},
  setup = function() end,
  after = 'plugin name',
  before = 'plugin name',
  keymaps = function() end,
}
