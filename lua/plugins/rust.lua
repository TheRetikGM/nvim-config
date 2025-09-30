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

return {
  {
    'mrcjkb/rustaceanvim',
    enabled = true,
    version = '^6', -- Recommended
    lazy = false,
    config = function()
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
            G.lsp_on_attach(client, bufnr)
            vim.api.nvim_set_hl(0, "FloatBorder", { link = "LspFloatWinBorder" })

            -- Keybinds
            vim.keymap.set('n', '<leader>ca', function() vim.cmd.RustLsp('codeAction') end,
              { desc = "Rust [C]ode [A]ction", buffer = bufnr })
            vim.keymap.set('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end,
              { desc = "Rust hover action", buffer = bufnr })
            vim.keymap.set('n', '<C-F5>', function() vim.cmd.RustLsp('runnables') end,
              { desc = "Rust run current target", buffer = bufnr })

            -- Format on write
            local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = "*.rs",
              callback = function()
                vim.lsp.buf.format({ timeout_ms = 200 })
              end,
              group = format_sync_grp,
            })
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
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust"
    },
    config = function()
      local neotest = require('neotest')

      neotest.setup({
        adapters = {
          require("neotest-rust")
        }
      })

      vim.keymap.set('n', '<leader>nr', function() neotest.run.run() end, { desc = '[N]eotest [R]un' })
      vim.keymap.set('n', '<leader>nf', function() neotest.run.run(vim.fn.expand('%')) end,
        { desc = '[N]eotest Run [F]ile' })
      vim.keymap.set('n', '<leader>ns', function() neotest.summary.toggle() end, { desc = '[N]eotest [S]ummary' })
      vim.keymap.set('n', '<leader>no', function() neotest.output_panel.toggle() end,
        { desc = '[N]eotest [O]output Panel' })
      vim.keymap.set('n', '<leader>nx', function() neotest.run.stop() end,
        { desc = '[N]eotest Stop' })
    end,
  },
  {
    'Saecki/crates.nvim',
    tag = 'stable',
    event = { "BufRead Cargo.toml" },
    config = function()
      require('crates').setup({
        completion = {
          cmp = {
            enabled = false
          },
        },
        null_ls = {
          enabled = false,
          name = "crates.nvim",
        },
        lsp = {
          enabled = true,
          on_attach = function(client, bufnr)
            G.lsp_on_attach(client, bufnr)

            vim.keymap.set('n', 'K', function() require("crates").show_features_popup() end,
              { buffer = bufnr, remap = true })
          end,
          actions = true,
          completion = true,
          hover = true,
        },
      })
    end
  }
}
