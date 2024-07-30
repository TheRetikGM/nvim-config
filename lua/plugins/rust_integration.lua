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

PLUGINS.rust_integration = {
  packer = {
    'mrcjkb/rustaceanvim',
    version = '^5',
  },
  setup = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
      },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          -- Keybinds
          vim.keymap.set('n', '<leader>ca', function() vim.cmd.RustLsp('codeAction') end,
            { desc = "Rust [C]ode [A]ction", buffer = bufnr })
          -- Run target defined by current cursor position
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
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
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
            cachePriming = {
              enable = true,
              numThreads = 2,
            },
          },
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
