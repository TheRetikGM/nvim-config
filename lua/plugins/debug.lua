local function setup_dap()
  local dap = require('dap')
  dap.adapters["rust-gdb"] = {
    type = "executable",
    command = "rust-gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
  }
  dap.adapters.codelldb = {
    type = "executable",
    command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
  }

  local dap = require('dap')
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }

  dap.configurations.c = dap.configurations.cpp

  dap.configurations.rust = {
    {
      name = "Launch",
      type = "rust-gdb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      args = {}, -- provide arguments if needed
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
    },
    {
      name = "Select and attach to process",
      type = "rust-gdb",
      request = "attach",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      pid = function()
        local name = vim.fn.input('Executable name (filter): ')
        return require("dap.utils").pick_process({ filter = name })
      end,
      cwd = "${workspaceFolder}"
    },
    {
      name = "Attach to gdbserver :1234",
      type = "rust-gdb",
      request = "attach",
      target = "localhost:1234",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}'
    }
  }
end

return {
  {
    'mfussenegger/nvim-dap',
    opts = {},
    config = function()
      setup_dap()
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function(opts)
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup(opts)

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.launch.fix_env = function(config)
        if type(config.env) ~= "table" then
          config.env = {
            RUST_LOG = "debug"
          }
        end
      end
    end,
    keys = {
      { '<F8>',  function() require('dapui').toggle() end,          mode = 'n', desc = 'Toggle DapUi' },
      { '<M-k>', function() require('dapui').eval() end,            mode = 'n', desc = 'Debugging evaluate' },
      { '<F3>',  function() require('dap').terminate() end,         mode = 'n', desc = 'Stop debugging' },
      { '<F4>',  function() require('dap').restart() end,           mode = 'n', desc = 'Restart debugging' },
      { '<F5>',  function() require('dap').continue() end,          mode = 'n', desc = 'Continue debugging' },
      { '<F9>',  function() require('dap').toggle_breakpoint() end, mode = 'n', desc = 'Toggle breakpoint' },
      { '<F10>', function() require('dap').step_over() end,         mode = 'n', desc = 'Debugging step over' },
      { '<F11>', function() require('dap').step_into() end,         mode = 'n', desc = 'Debugging step into' },
      { '<F12>', function() require('dap').step_out() end,          mode = 'n', desc = 'Debugging step out' },
    }
  }
}
