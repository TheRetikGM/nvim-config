-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'vscode',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
-- require('indent_blankline').setup {
--   char = '┊',
--   show_trailing_blankline_indent = false,
-- }
require("ibl").setup{
  scope = {
    show_start = false,
  }
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
}

require('neo-tree').setup {
  default_component_configs = {
    icon = {
      folder_empty = "󰜌",
      folder_empty_open = "󰜌",
    },
    git_status = {
      symbols = {
        renamed   = "󰁕",
        unstaged  = "󰄱",
      },
    },
  },
  document_symbols = {
    kinds = {
    File = { icon = "󰈙", hl = "Tag" },
      Namespace = { icon = "󰌗", hl = "Include" },
      Package = { icon = "󰏖", hl = "Label" },
      Class = { icon = "󰌗", hl = "Include" },
      Property = { icon = "󰆧", hl = "@property" },
      Enum = { icon = "󰒻", hl = "@number" },
      Function = { icon = "󰊕", hl = "Function" },
      String = { icon = "󰀬", hl = "String" },
      Number = { icon = "󰎠", hl = "Number" },
      Array = { icon = "󰅪", hl = "Type" },
      Object = { icon = "󰅩", hl = "Type" },
      Key = { icon = "󰌋", hl = "" },
      Struct = { icon = "󰌗", hl = "Type" },
      Operator = { icon = "󰆕", hl = "Operator" },
      TypeParameter = { icon = "󰊄", hl = "Type" },
      StaticMethod = { icon = '󰠄 ', hl = 'Function' },
    }
  },
  source_selector = {
    winbar = true,
    statusline = false,
    sources = {
      { source = "filesystem", display_name = " 󰉓  Files" },
      { source = "git_status", display_name = " 󰊢  Git" },
    }
  }
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
  file_ignore_patterns = { "node_modules", "build", "builddir", "dist", }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vimdoc', 'vim', 'html', 'css', 'json', 'jsonc', 'json5', 'php', 'phpdoc', 'javascript', 'comment' },

  highlight = {
    enable = true,
  },
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
-- local lspconfig = require("lspconfig");
-- lspconfig.clangd.setup {
--   capabilities = {
--     offsetEncoding = { "utf-8" }
--   },
--   init_options = {
--     usePlaceholders = false,
--   },
-- }

-- Setup bufferline plugin (requires vim.opt.termguicolors = true)
vim.opt.mousemoveevent = true
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, _, _)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    buffer_close_icon = "",
    close_command = "bdelete %d",
    close_icon = "",
    indicator = {
      style = "icon",
      icon = " ",
    },
    left_trunc_marker = "",
    modified_icon = "●",
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        separator = ' ', -- use a "true" to enable the default, or set your own character
      }
    },
    separator_style = "slant",
    numbers = function(opts) return string.format('%s', opts.raise(opts.ordinal)) end,
    right_mouse_command = "bdelete! %d",
    right_trunc_marker = "",
    show_close_icon = false,
    show_tab_indicators = true,
  },
  highlights = {
   separator = {
      fg = { attribute = 'bg', highlight = 'StatusLineNC' },
    },
    separator_visible = {
      fg = { attribute = 'bg', highlight = 'StatusLineNC' },
    },
    separator_selected = {
      fg = { attribute = 'bg', highlight = 'StatusLineNC' },
    },
  },
})

-- Setup toggleterm
require('toggleterm').setup()

-- Setup lsp signature
-- require('lsp_signature').setup{
--   bind = false,
--   handler_opts = {
--     border = "rounded"
--   },
--   hi_inline = function() return false end,
--   hi_parameter = "LspSignatureActiveParameter",
--   hint_enable = false,
--   doc_lines = 0,
-- }

-- Setup nvim-ufo
require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

-- Setup null-ls
local null_ls = require('null-ls')
null_ls.setup({

  -- on_init = function(new_client, _)
    -- Fix the multiple offset_encoding when using the lsp_signature plugin.
    -- new_client.offset_encoding = 'utf-8'
  -- end,
})

-- Setup Move.nvim
require('move').setup({})

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
    args = { },
  }
}
dap.configurations.c = dap.configurations.cpp
  -- Set arguments for C/C++ DAP debugger
vim.api.nvim_create_user_command('SetDebugArgs', function(ctx)
  local args = {}
  for arg in ctx.args:gmatch('%S+') do
    table.insert(args, arg)
  end
  dap.configurations.cpp[1].args = args
  dap.configurations.c[1].args = args
end, { desc = 'Set arguments to use when debugging' })

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

-- Profiling annotations
local util = require("perfanno.util")
local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")
require("perfanno").setup{
  -- Creates a 10-step RGB color gradient beween bgcolor and "#CC3300"
  line_highlights = util.make_bg_highlights(bgcolor, "#CC3300", 10),
  vt_highlight = util.make_fg_highlight("#CC3300"),
}

-- Flutter tools
local flutter_format = true;
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
    on_attach = function(_, bufnr)
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
    end,
  }
})

-- Presence.nvim
require("presence").setup({
    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})

-- Dressing
require("dressing").setup()

-- Setup neogen
require('neogen').setup({
  -- snippet_engine = "luasnip",
  snippet_engine = "vsnip"
})

-- Autoindent in PHP files.
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = {"*.php"},
  callback = function(_)
      vim.cmd('set autoindent')
  end,
})

