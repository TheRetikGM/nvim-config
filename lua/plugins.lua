-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
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
      'folke/neodev.nvim',
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

  -- DEL: Pretty folding
  use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

  -- DEL: Doxygen highlights and generation.
  use { 'danymat/neogen' }

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

  use 'nvim-lualine/lualine.nvim' -- DEL: Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- DEL: Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- DEL: "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- DEL: Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- DEL: Neo tree for file explorer
  -- Unless you are still migrating, remove the deprecated commands from v1.x
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }

  -- Display GUI like buffer tabs
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  -- DEL: Close buffers without messing up the layout
  use 'famiu/bufdelete.nvim'
  -- DEL: Duplicate cursors and more
  use { 'mg979/vim-visual-multi', branch = 'master' }
  -- DEL: Move lines and blocks around
  use { 'fedepujol/move.nvim' }
  -- DEL: Terminal
  use { 'akinsho/toggleterm.nvim', tag = '*' }
  -- Inject lsp diagnostics, code actions and more. Also format code.
  use { 'nvimtools/none-ls.nvim' }
  -- DEL: Automatically complete pair characters
  use 'windwp/nvim-autopairs'
  -- DEL: Manage sessions
  use {
    'rmagatti/session-lens',
    requires = {'nvim-telescope/telescope.nvim'},
  }
  -- DEL: Requred by session-lens
  use {
    'rmagatti/auto-session',
    -- There was a bug when some file was renamed and it didn't work
    commit = '8b43922b893790a7f79951d4616369128758d215'
  }
  -- DEL: Debugging
  use {
    'mfussenegger/nvim-dap',
    requires = { 'rcarriga/nvim-dap-ui' },
  }
  -- DEL: Rust tools - Automatically configure rust_analyzer
  use { 'simrat39/rust-tools.nvim' }
  -- DEL: Profiling annotations
  use { 't-troebst/perfanno.nvim' }
  -- DEL: Auto indentation for lisp-like languages (I use it for EWW configuration files)
  use { 'gpanders/nvim-parinfer' }
  -- DEL: Pretty message boxes. For example when you want to rename a variable.
  use { 'stevearc/dressing.nvim' }
  -- DEL: Flutter compatibility
  use {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim'
    }
  }
  -- VSCode theme
  use 'Mofiqul/vscode.nvim'

  -- DEL: Show nvim activity in discord
  use 'andweeb/presence.nvim';

  -- Connect mason and null-ls to make linteres and formatters work.
  use 'jay-babu/mason-null-ls.nvim'

  use 'nvim-neotest/nvim-nio'

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

