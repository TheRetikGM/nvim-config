-- Inject lsp diagnostics, code actions and more. Also format code.
-- NOTE: Replacement for null-ls
--
-- Make these features from LSP available (??)
PLUGINS.none_ls = {
  packer = {
    'nvimtools/none-ls.nvim',
    requires = {
      'jay-babu/mason-null-ls.nvim'
    }
  },
  setup = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      -- on_init = function(new_client, _)
        -- Fix the multiple offset_encoding when using the lsp_signature plugin.
        -- new_client.offset_encoding = 'utf-8'
      -- end,
    })
  end
}
