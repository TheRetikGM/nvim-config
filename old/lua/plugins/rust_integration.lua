local function get_dap_adapter()
  -- Update this path
  local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb'
  local this_os = vim.uv.os_uname().sysname;

  -- The path is different on Windows
  if this_os:find "Windows" then
    codelldb_path = extension_path .. "adapter\\codelldb.exe"
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  else
    -- The liblldb extension is .so for Linux and .dylib for MacOS
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
  end

  local cfg = require('rustaceanvim.config')
  local adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
  adapter.name = "helppls"
  return adapter
end

local rust_config = {
  cargo = {
    allFeatures = true,
    loadOutDirsFromCheck = true,
    buildScripts = {
      enable = true,
    },
  },
  -- Add clippy lints for Rust.
  checkOnSave = true,
  procMacro = {
    enable = true,
    ignored = {
      ["async-trait"] = { "async_trait" },
      ["napi-derive"] = { "napi" },
      ["async-recursion"] = { "async_recursion" },
    },
  },
  -- Add clippy lints for Rust.
  check = {
    command = "clippy",
    extraArgs = { "--no-deps" },
  },
  assist = {
    importEnforceGranularity = true,
    importPrefix = "crate",
  },
  completion = {
    autoimport = {
      enable = true,
    },
    enableSnippets = true,
  },
  inlayHints = {
    lifetimeElisionHints = {
      enable = true,
      useParameterNames = true,
    },
  },
  numThreads = 8,
  cachePriming = {
    enable = true,
    numThreads = 2,
  },
}

PLUGINS.rust_integration = {
  packer = {
    'mrcjkb/rustaceanvim',
    version = '^6',
  },
  setup = function()
    if string.find(vim.fn.getcwd(), "/projects/esp") then
      -- Resolve the 'can't find crate for test can't find crate` errors
      rust_config["cargo"].target = "riscv32imac-unknown-none-elf"
      rust_config["check"].allTargets = false
    end

    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        code_actions = {
          ui_select_fallback = true,
        },
        float_win_config = {
          border = 'rounded',
          winhighlight = "Normal:LspFloatWinBorder,FloatBorder:LspFloatWinBorder",
        }
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          vim.api.nvim_set_hl(0, "FloatBorder", { link = "LspFloatWinBorder" })

          -- Keybinds
          vim.keymap.set('n', '<leader>ca', function() vim.cmd.RustLsp('codeAction') end, { desc = "Rust [C]ode [A]ction", buffer = bufnr })
          vim.keymap.set('n', 'K', function() vim.cmd.RustLsp{ 'hover', 'actions' } end, { desc = "Rust hover action", buffer = bufnr })
          vim.keymap.set('n', '<C-F5>', function() vim.cmd.RustLsp('runnables') end, { desc = "Rust run current target" })

          -- Format on write
          local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.rs",
            callback = function()
              vim.lsp.buf.format({ timeout_ms = 200 })
            end,
            group = format_sync_grp,
          })

          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
          vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type [D]efinition' })
          vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols,
            { desc = '[D]ocument [S]ymbols' })
          vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
            { desc = '[W]orkspace [S]ymbols' })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = rust_config,
        },
      },
      -- DAP configuration
      ---@type rustaceanvim.dap.Opts
      dap = {
        adapter = get_dap_adapter(),
      },
    }
  end,

  prio = 109 -- Before nvim_dap
}
