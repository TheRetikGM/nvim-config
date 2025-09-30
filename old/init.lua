-- Utils table
U = {}

-- Set colorscheme
vim.o.termguicolors = true

-- Install plugins
require('plugins')

-- [[ Setting options ]]
-- See `:help vim.o`

-- Number of lines to start scrolling from
vim.o.scrolloff = 10
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
-- Set relative line numbering
vim.o.relativenumber = true
-- Set command line height to 0
vim.o.cmdheight = 0
-- Highlight current line
vim.o.cursorline = true

-- Execute `init` function on each plugin
FOR_EACH_PLUGIN(function(plugin)
  if plugin.init ~= nil then
    plugin.init()
  end
end)

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
  float = {
    -- Another fucking place where I have to set rounded border. Fuck my life mann
    -- For now these are the places where I had to set it:
    -- + vim.diagnostics.config() (here)
    -- + cmp.setup
    -- + vim.g.rustaceanvim.tools.float_win_config
    -- + noice plugin config
    border = 'rounded',
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
LSP_ON_ATTACH = function(client, bufnr)
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
  nmap('<leader>ss', require('telescope.builtin').lsp_workspace_symbols, '[S]earch [S]ymbols')
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

  vim.api.nvim_buf_create_user_command(bufnr, 'TypstSetMainFile', function()
    local main_file = vim.fn.input('Path to main file: ', vim.fn.getcwd() .. '/', 'file')

    vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", {
      command = "typst-lsp.doPinMain",
      arguments = { vim.uri_from_fname(main_file) },
    }, 1000)
  end, { desc = "Set main file for typst lsp" })
end

-- Enable the following language servers
local servers = {
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

-- Setup neovim lua configuration
require('lazydev').setup()

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
require('mason').setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
    "github:nvim-java/mason-registry",
  }
})
require('mason-null-ls').setup();

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = false,
}

for _, server_name in pairs(mason_lspconfig.get_installed_servers()) do
  vim.lsp.enable(server_name)

  if servers[server_name] == 'ignore' then
    goto continue
  end

  vim.lsp.config(server_name, {
    capabilities = capabilities,
    on_attach = LSP_ON_ATTACH,
    settings = servers[server_name],
  })

  ::continue::
end

-- Setup PyLSP
vim.lsp.config('pylsp', {
  capabilities = capabilities,
  on_attach = LSP_ON_ATTACH,
  settings = servers["pylsp"],
  root_dir = require 'lspconfig'.util.root_pattern('.')
})

-- Setup clangd
local project_clangd = vim.fn.getcwd() .. "/.clangd_bin"
if vim.fn.filereadable(project_clangd) == 1 then
  project_clangd = vim.fn.readfile(project_clangd)[1]
else
  project_clangd = "clangd"
end

vim.lsp.config('clangd', {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    LSP_ON_ATTACH(client, bufnr)

    vim.keymap.set('n', '<C-s>', function() vim.cmd('ClangdSwitchSourceHeader') end,
      { buffer = bufnr, desc = 'Switch [S]ource header', remap = true })
  end,
  flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
  cmd = {
    project_clangd,
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "-j", "8",
    "--malloc-trim",
    "--pch-storage=memory",
    -- "--query-driver", "/home/kuba/.espressif/tools/riscv32-esp-elf/esp-13.2.0_20230928/riscv32-esp-elf/bin/riscv32-esp-elf-gcc",
    "--compile-commands-dir", "build/"
  },
  env = vim.fn.environ(),
})

-- Omnisharp lagged the neovim so badly (when opening large C# project) that I had to kill it on exit
-- lspconfig.omnisharp.setup({
--   capabilities = capabilities,
--   on_attach = LSP_ON_ATTACH,
--   cmd = { vim.fn.stdpath("data") .. "/mason/bin/OmniSharp" },
--   root_dir = lspconfig.util.root_pattern('*.sln', '.git'),
-- })

-- The C# LSP to use instead of omnisharp garbage
vim.lsp.config("roslyn", {
  capabilities = capabilities,
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

-- Turn on lsp status information
require('fidget').setup({})

-- nvim-cmp setup
local cmp = require 'cmp'
-- local luasnip = require 'luasnip'

-- Setup plugins
require('plugin_setups')

cmp.setup({
  formatting = {
    format = function(_, vim_item)
      local max_width = 60
      local label = vim_item.abbr
      if #label > max_width then
        vim_item.abbr = string.sub(label, 1, max_width - 1) .. "…"
      end

      return vim_item
    end,
  },
  snippet = {
    expand = function(args)
      -- luasnip.lsp_expand(args.body)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered {
      winhighlight = "Normal:Pmenu,FloatBorder:LspFloatWinBorder,CursorLine:PmenuSel,Search:None",
    },
    documentation = cmp.config.window.bordered {
      winhighlight = "Normal:Pmenu,FloatBorder:LspFloatWinBorder,CursorLine:PmenuSel,Search:None",
    },
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
    -- Rust crates
    { name = 'crates' },
  }, {
    -- Source current buffer.
    { name = 'buffer' },
  }),
})

-- Set my custom eybindins for plugins
require('keybindings')

-- Make checkhealth have a rounded border
vim.g.health = { style = 'float' }
vim.api.nvim_create_autocmd("FileType", {
  pattern = 'checkhealth',
  callback = function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()

    local width = math.floor(vim.o.columns * 0.8) -- 80% of screen width
    local height = math.floor(vim.o.lines * 0.7)  -- 70% of screen height
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    pcall(vim.api.nvim_win_set_config, win, {
      border = "rounded",
      relative = "editor",
      row = row,
      col = col,
      width = width,
      height = height,
      style = "minimal",
    })

    -- Optional: avoid listing in buffer list
    vim.bo[buf].buflisted = false
  end,
})

-- Inline hints (neovim builtin functionality)
vim.api.nvim_create_user_command('InlineHintsToggle', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { nargs = 0 })

-- Fuck this broo. I am done
vim.cmd([[
  cabb W w
  cabb Q q
  cabb Wa wa
  cabb Qa qa
  cabb WA wa
  cabb QA qa
]])
