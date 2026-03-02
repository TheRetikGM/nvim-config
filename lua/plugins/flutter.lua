local flutter_format = true;

local function flutter_on_lsp_attach(i, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Global LSP defaults
  G.lsp_on_attach(i, bufnr)

  -- Specific flutter commands
  require('telescope').load_extension("flutter")
  nmap('<leader>ff', function()
    require('telescope').extensions.flutter.commands()
  end, '[F]lutter commands');

  -- Auto formatting toggle commands
  vim.api.nvim_buf_create_user_command(bufnr, 'FormatOnWriteOff', function(_)
    flutter_format = false;
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_buf_create_user_command(bufnr, 'FormatOnWriteOn', function(_)
    flutter_format = true;
  end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { "*.dart" },
    callback = function(_)
      if flutter_format then
        vim.lsp.buf.format()
      end
    end,
  })
end

return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- We use the ./pretty_dialos.lua for this
    -- 'stevearc/dressing.nvim',     -- optional for vim.ui.select
  },
  options = {
  },
  config = function()
    require('flutter-tools').setup({
      lsp = {
        color = {
          enabled = true,
          background = true,
          virtual_text = true,
        },
        settings = {
          -- See  https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
          showTodos = true,
          completeFunctionCalls = true,
          -- analysisExcludedFolders = {"<path-to-flutter-sdk-packages>"},
          renameFilesWithClasses = "prompt", -- "always"
          enableSnippets = true,
          updateImportsOnRename = true,    -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
          lineLength = 100,
        },
        on_attach = flutter_on_lsp_attach,
      }
    })
  end,
}
