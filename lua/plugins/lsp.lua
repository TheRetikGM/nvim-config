LSP_SERVERS = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  pylsp = 'ignore',
  rust_analyzer = 'ignore',
  clangd = 'ignore',
  cmake = {},
  -- intelephense = {
  --   files = {
  --     maxSize = 1000000,
  --   }
  -- },
  tinymist = {
    exportPdf = "never",
  },
  omnisharp = 'ignore',
}

return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = vim.tbl_keys(LSP_SERVERS),
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
        "github:nvim-java/mason-registry",
      },
    },
  },
  {
    -- Connect mason and null-ls to make linteres and formatters work.
    'jay-babu/mason-null-ls.nvim',
    dependencies = {
      -- Inject lsp diagnostics, code actions and more. Also format code.
      -- null-ls (deprecated) alternative
      'nvimtools/none-ls.nvim'
    },
    opts = {},
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
}
