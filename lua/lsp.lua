-------------------
--- Setup LSP
-------------------

-- Remove default keymaps
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'grx')

-- Setup diagnostics
vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    -- Another fucking place where I have to set rounded border. Fuck my life mann
    -- For now these are the places where I had to set it:
    -- + vim.diagnostics.config() (here)
    -- + cmp.setup
    -- + vim.g.rustaceanvim.tools.float_win_config
    -- + noice plugin config
    border = G.border,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "LspDiagnosticsSignError",
      [vim.diagnostic.severity.WARN] = "LspDiagnosticsSignWarning",
      [vim.diagnostic.severity.INFO] = "LspDiagnosticsSignHint",
      [vim.diagnostic.severity.HINT] = "LspDiagnosticsSignInformation",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "LspDiagnosticsSignError",
      [vim.diagnostic.severity.WARN] = "LspDiagnosticsSignWarning",
      [vim.diagnostic.severity.INFO] = "LspDiagnosticsSignHint",
      [vim.diagnostic.severity.HINT] = "LspDiagnosticsSignInformation",
    },
  }
})

G.lsp_on_attach = function(_, bufnr)
  -- Init our keymaps
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  local pick = require('picker')

  nmap('gd', pick.definition, '[G]oto [D]efinition')
  nmap('gr', pick.references, '[G]oto [R]eferences')
  nmap('gR', pick.references_dock, '[G]oto [R]eferences (dock)')
  nmap('gi', pick.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', pick.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', pick.document_symbol, '[D]ocument [S]ymbols')
  nmap('<leader>ss', pick.workspace_symbol, '[S]earch [S]ymbols')
  nmap('<leader>ws', pick.workspace_symbol, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', pick.declaration, '[G]oto [D]eclaration')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    require('conform').format({ async = true, lsp_format = 'fallback' })
  end, { desc = 'Format current buffer' })

  vim.api.nvim_buf_create_user_command(bufnr, 'TypstSetMainFile', function()
    local main_file = vim.fn.input('Path to main file: ', vim.fn.getcwd() .. '/', 'file')

    vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", {
      command = "typst-lsp.doPinMain",
      arguments = { vim.uri_from_fname(main_file) },
    }, 1000)
  end, { desc = "Set main file for typst lsp" })

  vim.api.nvim_buf_create_user_command(bufnr, 'DiagErrorsBuf', function()
    require('trouble').open({
      mode = "diagnostics",
      filter = {
        buf = 0,
        severity = vim.diagnostic.severity.ERROR
      }
    })
  end, { desc = "Diagnostic errors for current buffer" })

  vim.api.nvim_buf_create_user_command(bufnr, 'DiagErrorsAll', function()
    require('trouble').open({
      mode = "diagnostics",
      filter = {
        severity = vim.diagnostic.severity.ERROR
      },
    })
  end, { desc = "Diagnostic errors" })

  vim.api.nvim_buf_create_user_command(bufnr, 'DiagWarn', function()
    require('trouble').open({
      mode = "diagnostics",
      filter = {
        severity = vim.diagnostic.severity.WARN   -- This can take function if we want more types
      }
    })
  end, { desc = "Diagnostic warnings" })
end

-------------------------
--- Setup capabilities
-------------------------

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require('mini.completion').get_lsp_capabilities()  -- For testing only
local capabilities = require('blink-cmp').get_lsp_capabilities() -- For testing only
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     -- delay update diagnostics
--     update_in_insert = true,
--   }
-- )
vim.diagnostic.config({
  update_in_insert = true,
})

-------------------------
--- Default server setups
-------------------------

local mason_lspconfig = require 'mason-lspconfig'
for _, server_name in pairs(mason_lspconfig.get_installed_servers()) do
  vim.lsp.enable(server_name)

  if LSP_SERVERS[server_name] == 'ignore' then
    vim.lsp.enable(server_name, false)
    goto continue
  end

  vim.lsp.config(server_name, {
    capabilities = capabilities,
    on_attach = G.lsp_on_attach,
    settings = LSP_SERVERS[server_name],
  })

  ::continue::
end

-------------------------
--- Custom server setups
-------------------------

-- -- Setup PyLSP
-- vim.lsp.enable('pylsp')
-- vim.lsp.config('pylsp', {
--   capabilities = capabilities,
--   on_attach = G.lsp_on_attach,
--   -- settings = LSP_SERVERS["pylsp"],
--   root_dir = require 'lspconfig'.util.root_pattern('.')
-- })

-- Setup clangd
local clangd_opts = require('lsp.clangd')
local clangd_on_attach = clangd_opts.on_attach
clangd_opts.on_attach = function(client, bufnr)
  clangd_on_attach(client, bufnr)
  G.lsp_on_attach(client, bufnr)

  vim.keymap.set('n', '<C-s>', function() vim.cmd('LspClangdSwitchSourceHeader') end, {
    -- buffer = bufnr,
    desc = 'Switch [S]ource header',
    remap = true
  })
end
vim.lsp.enable('clangd')
vim.lsp.config('clangd', clangd_opts)

-- Setup C#
vim.lsp.config('roslyn', {
  cmd = {
    "roslyn-language-server",
    "--stdio",
  },
  capabilities = capabilities,
  on_attach = G.lsp_on_attach,
  settings = LSP_SERVERS['roslyn'],
})
