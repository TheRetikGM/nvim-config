-- Rust crates management
PLUGINS.crates = {
  packer = { 'Saecki/crates.nvim', tag = 'stable' },
  setup = function()
    require('crates').setup({
      completion = {
        cmp = {
          enabled = true
        },
      },
      null_ls = {
        enabled = false,
        name = "crates.nvim",
      },
      lsp = {
        enabled = true,
        on_attach = function (client, bufnr)
          LSP_ON_ATTACH(client, bufnr)

          vim.keymap.set('n', 'K', function() require("crates").show_features_popup() end, { buffer = bufnr, remap = true })
        end,
        actions = true,
        completion = true,
        hover = true,
      },
    })
  end,
}
