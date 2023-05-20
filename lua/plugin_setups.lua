-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help', 'vim' },

  highlight = { enable = true },
  indent = { enable = false, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Configure lsp servers
local lspconfig = require("lspconfig");
lspconfig.clangd.setup {
  capabilities = {
    offsetEncoding = { "utf-8" }
  },
  init_options = {
    usePlaceholders = false,
  },
}

-- Setup bufferline plugin (requires vim.opt.termguicolors = true)
vim.opt.mousemoveevent = true
require('bufferline').setup{
  options = {
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, _, _)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        separator = ' ', -- use a "true" to enable the default, or set your own character
      }
    },
    separator_style = "slant",
    numbers = function(opts)
      return string.format('%s', opts.raise(opts.ordinal))
    end,
  }
}

-- Setup toggleterm
require('toggleterm').setup()

-- Setup null-ls
local null_ls = require('null-ls')
null_ls.setup({
  sources = { null_ls.builtins.formatting.clang_format },
  on_init = function(new_client, _)
    -- Fix the multiple offset_encoding when using the lsp_signature plugin.
    new_client.offset_encoding = 'utf-8'
  end,
})

-- Setup nvim-autoparis with cmp
require('nvim-autopairs').setup{}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Setup session management
require('auto-session').setup {
  auto_save_enabled = true,
  pre_save_cmds = { 'Neotree action=close', "lua require 'dapui'.close()" },
  auto_restore_enabled = false,
}

-- Setup hologram
require('hologram').setup{}

-- Rust tools
local extension_path = vim.env.HOME .. '.local/share/nvim/mason/packages/codelldb/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<leader>h", rt.hover_actions.hover_actions, { desc = "Rust [H]over action", buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
  },
})

-- Debugging with nvim-dap
local dap = require('dap')
dap.adapters = {
  lldb = {
    type = 'executable',
    command = '/sbin/lldb-vscode',
    name = 'lldb'
  },
  cppdbg = {
    type = 'executable',
    command = '/home/kuba/.local/share/cppdbg/extension/debugAdapters/bin/OpenDebugAD7',
    name = 'cppdbg'
  }
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
    args = {
    },
  }
}
dap.configurations.c = dap.configurations.cpp

-- Dap UI
require("dapui").setup({
  layouts = {
    {
      elements = {
        [3] = 'scopes',
        [2] = 'watches',
        [1] = 'breakpoints',
      },
      position = 'left',
      size = 40,
    },
    {
      elements = {
        [2] = 'stacks',
        [1] = 'console',
      },
      position = 'bottom',
      size = 12,
    }
  }
});

-- Define signs
vim.fn.sign_define('DapBreakpoint', { text = '🔴' })
vim.fn.sign_define('DapStopped', { text = '=>' })
vim.fn.sign_define("LspDiagnosticsSignError", {text = " ", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = " ", texthl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = " ", texthl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"})

-- Profiling annotations
local util = require("perfanno.util")
local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")
require("perfanno").setup{
  -- Creates a 10-step RGB color gradient beween bgcolor and "#CC3300"
  line_highlights = util.make_bg_highlights(bgcolor, "#CC3300", 10),
  vt_highlight = util.make_fg_highlight("#CC3300"),
}
