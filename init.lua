
-- Install plugins
require('plugins')

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false
-- Make line numbers default
vim.wo.number = true
-- Enable mouse mode
vim.o.mouse = 'a'
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
-- Set colorscheme
vim.o.termguicolors = true
local c = require('vscode.colors')
require('vscode').setup({
    style = 'dark',
    transparent = false,
    italic_comments = true,
    underline_links = true,
    disable_nvimtree_bg = false,
        -- Override colors (see ./lua/vscode/colors.lua)
})
require('vscode').load()
-- vim.cmd [[colorscheme vscode]]
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect,preview'
-- Set relative line numbering
vim.o.relativenumber = true
-- Set command line height to 0
vim.o.cmdheight = 0
-- Highlight current line
vim.o.cursorline = true
-- DEL: Enable treesitter folding using nvim-ufo
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- vim.cmd([[
--   " When switching buffers, preserve window view.
--   if v:version >= 700
--     au BufLeave * if !&diff | let b:winview = winsaveview() | endif
--     au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | unlet! b:winview | endif
--   endif
-- ]])

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
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

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local lsp_on_attach = function(client, bufnr)
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

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- DEL: Set arguments for C/C++ DAP debugger
vim.api.nvim_create_user_command('SetDebugArgs', function(ctx)
  local dap = require('dap')
  local args = {}
  for arg in ctx.args:gmatch('%S+') do
    table.insert(args, arg)
  end
  dap.configurations.cpp[0].args = args
  dap.configurations.c[0].args = args
end, { desc = 'Set arguments to use when debugging' })

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {
    flags = {allow_incremental_sync = true, debounce_text_changes = 500},
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "-j 8",
      "--malloc-trim",
      "--pch-storage=memory",
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  rust_analyzer = {},
  cmake = {},
  omnisharp = {},
  -- intelephense = {
  --   files = {
  --     maxSize = 1000000,
  --   }
  -- },
  typst_lsp = {
    exportPdf = "never";
  },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- delay update diagnostics
    update_in_insert = true,
  }
)

-- Setup mason so it can manage external tooling
require('mason').setup()
require('mason-null-ls').setup({
  handlers = {},
});

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    -- if server_name == "intelephense" then
    --   require('lspconfig').intelephense.setup {
    --     capabilities = capabilities,
    --     on_attach = lsp_on_attach,
    --     settings = servers["intelephense"],
    --     root_dir = function(_)
    --       return vim.fn.getcwd()
    --     end
    --   }
    --   return
    -- end
    if server_name == "pylsp" then
      require('lspconfig').pylsp.setup {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        settings = servers["pylsp"],
        root_dir = require 'lspconfig'.util.root_pattern('.')
      }
      return
    end
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = lsp_on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
-- local luasnip = require 'luasnip'

-- Setup plugins
require('plugin_setups')

cmp.setup({
  snippet = {
    expand = function(args)
      -- luasnip.lsp_expand(args.body)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {

  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
    -- File paths
    { name = 'path' },
    -- Function parameters while typing
    { name = 'nvim_lsp_signature_help' },
    { name = 'vsnip' },
  }, {
    -- Source current buffer.
    { name = 'buffer' },
  }),
})

-- `/` cmdline setup.
-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- `:` cmdline setup.
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

-- Set my custom eybindins for plugins
require('keybindings')

