-- Table containing most of custom plugins and their setups
PLUGINS = {}

PLUGIN_TEMPLATE = {
  -- Table to pass to Packer's `use` function.
  packer = {},
  -- Setuping function for this plugin. NOTE: You need to require the plugin.
  setup = function() end,
  -- Name of the plugin to setup after
  after = 'plugin name',
  -- Name of the plugin to setup before
  before = 'plugin name',
  -- Function that setups the keymapping.
  keymaps = function() end,
}
