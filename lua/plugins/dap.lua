local dapui = require('dapui')
local debug_ui = {
  opened = false,            -- Current state of dapui
  neotree_opened = false,    -- If neotree was opened before opening the dapui
  toggleterm_opened = false, -- If toggle term was opened before the dapui
}
local function toggle_debug_ui(opts)
  debug_ui.opened = not debug_ui.opened
  if debug_ui.opened then -- Show debug UI
    -- Hide neotree
    if neotree_open then
      debug_ui.neotree_opened = true
      neotree_toggle()
    else
      debug_ui.neotree_opened = false
    end
    -- Hide toggle term
    debug_ui.toggleterm_opened = false
    for _, term in ipairs(require('toggleterm.terminal').get_all(false)) do
      local tu = require 'toggleterm.ui'
      if tu.term_has_open_win(term) then
        tu.close(term)
        debug_ui.toggleterm_opened = true
      end
    end
    -- Show debug ui
    dapui.open(opts)
  else
    -- Hide debug ui
    dapui.close(opts)
    -- Toggle terminal if it was visible
    if debug_ui.toggleterm_opened then
      vim.cmd("ToggleTerm")
    end
    -- Show neotree if it was visible
    if debug_ui.neotree_opened then
      neotree_toggle()
    end
  end
end

PLUGINS.dap = {
  packer = {
    'mfussenegger/nvim-dap',
    requires = { 'rcarriga/nvim-dap-ui' },
  },
  after = 'neotree',
  init = function()
    vim.api.nvim_create_user_command('SetDebugArgs', function(ctx)
      local dap = require('dap')
      local args = {}
      for arg in ctx.args:gmatch('%S+') do
        table.insert(args, arg)
      end
      dap.configurations.cpp[0].args = args
      dap.configurations.c[0].args = args
    end, { desc = 'Set arguments to use when debugging' })
  end,
  setup = function()
    local dap = require('dap')
    dap.adapters = {
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
        args = {},
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
  end,
  keymaps = function()
    vim.keymap.set('n', '<F8>', toggle_debug_ui, { desc = '[D]ap[U]i toggle' })
    local dap = require('dap')
    vim.keymap.set('n', '<F3>', dap.terminate, { desc = 'Stop debugging' })
    vim.keymap.set('n', '<F4>', dap.restart, { desc = 'Restart debugging' })
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Start/Continue debugging' })
    vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debugging step over' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debugging step into' })
    vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debugging step out' })
    dap.listeners.after.event_initialized["dapui_config"] = function(opts)
      if not debug_ui.opened then toggle_debug_ui(opts) end
    end
    local function close_debug_ui(opts) if debug_ui.opened then toggle_debug_ui(opts) end end
    dap.listeners.after.event_terminated["dapui_config"] = close_debug_ui
    dap.listeners.before.event_exited["dapui_config"] = close_debug_ui
  end,
  prio = 110,
}
