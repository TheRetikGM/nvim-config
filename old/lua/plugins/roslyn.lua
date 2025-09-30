PLUGINS.roslyn = {
  packer = { 'seblyng/roslyn.nvim' },
  setup = function()
    require('roslyn').setup({})

    vim.lsp.config("roslyn", {
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      on_attach = LSP_ON_ATTACH,
      settings = {
        -- See https://github.com/dotnet/vscode-csharp/blob/main/test/lsptoolshost/unitTests/configurationMiddleware.test.ts
        -- and https://github.com/seblyng/roslyn.nvim?tab=readme-ov-file#background-analysis
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      }
    })
  end
}
