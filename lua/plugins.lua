-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- Load all plugins from the plugins directory.
require('plugin_common')
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua/plugins', [[v:val =~ '\.lua$']])) do
  require('plugins.'..file:gsub('%.lua$', ''))
end

-- Create key array of plugins sorted by priority
local plugin_keys = {}
for k in pairs(PLUGINS) do
  table.insert(plugin_keys, k)
end
table.sort(plugin_keys, function(a, b)
  if PLUGINS[a].prio == nil then PLUGINS[a].prio = 10000000 end
  if PLUGINS[b].prio == nil then PLUGINS[b].prio = 10000000 end

  return PLUGINS[a].prio < PLUGINS[b].prio
end)

-- Iterate over all plugins in sorted order by priority
function FOR_EACH_PLUGIN(func)
  for _, key in ipairs(plugin_keys) do
    local plugin = PLUGINS[key];

    if plugin.ignore ~= nil and plugin.ignore == true then
      goto continue
    end

    func(plugin)

    ::continue::
  end
end

-- Setup packer plugins
require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
      },

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/lazydev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',   -- CMP integration with lsp
      -- 'L3MON4D3/LuaSnip',       -- Code snippets
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp-signature-help',    -- Function signature while typing
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',   -- Filesystem paths
      'hrsh7th/cmp-buffer',
      'hrsh7th/vim-vsnip',
    },
  }

  -- Sinagure help for functions.
  -- use { 'ray-x/lsp_signature.nvim' }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- Themes
  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'Th3Whit3Wolf/one-nvim'
  use 'folke/tokyonight.nvim'
  use 'rebelot/kanagawa.nvim'

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Inject lsp diagnostics, code actions and more. Also format code.
  use { 'nvimtools/none-ls.nvim' }

  -- VSCode theme
  use 'Mofiqul/vscode.nvim'

  -- Connect mason and null-ls to make linteres and formatters work.
  use 'jay-babu/mason-null-ls.nvim'

  -- A library for asynchronous IO in Neovim, inspired by the asyncio library in Python. The library focuses
  -- on providing both common asynchronous primitives and asynchronous APIs for Neovim's core.
  use 'nvim-neotest/nvim-nio'

  -- Load all other plugins
  FOR_EACH_PLUGIN(function(plugin)
    use(plugin.packer)
  end)

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

