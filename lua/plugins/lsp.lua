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
  -- C#
  roslyn = {
    -- https://github.com/seblyng/roslyn.nvim?tab=readme-ov-file#example
  },
  -- Razor
  rzls = {},
}

return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup({
        ensure_installed = vim.tbl_keys(LSP_SERVERS),
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",  -- Roslyn and rzls
          "github:nvim-java/mason-registry",
        },
      })

      require('mason-lspconfig').setup({
        automatic_enable = {
          exclude = {
            'rust_analyzer',
          }
        }
      })
    end
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
