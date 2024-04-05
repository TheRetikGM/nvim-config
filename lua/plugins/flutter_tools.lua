local flutter_format = true;

local function flutter_on_lsp_attach(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>ff', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  require('telescope').load_extension("flutter")
  nmap('<leader>ff', function()
    require('telescope').extensions.flutter.commands()
  end, '[F]lutter commands');

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_buf_create_user_command(bufnr, 'FormatOnWriteOff', function(_)
    flutter_format = false;
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_buf_create_user_command(bufnr, 'FormatOnWriteOn', function(_)
    flutter_format = true;
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = {"*.dart"},
    callback = function(_)
      if flutter_format then
        vim.lsp.buf.format()
      end
    end,
  })
end

-- Flutter compatibility
PLUGINS.flutter_tools = {
  packer = {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim'
    }
  },
  setup = function()
    require("flutter-tools").setup({
      color = {
        enabled = true,
        background = true,
        virtual_text = true,
      },
      lsp = {
        settings = {
          -- See  https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
          showTodos = true,
          completeFunctionCalls = true,
          -- analysisExcludedFolders = {"<path-to-flutter-sdk-packages>"},
          renameFilesWithClasses = "prompt", -- "always"
          enableSnippets = true,
          updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
          lineLength = 100,
        },
        on_attach = flutter_on_lsp_attach,
      }
    })
  end
}
