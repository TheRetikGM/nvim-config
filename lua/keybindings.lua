-- Bind kj to escape key
vim.keymap.set('i', 'jj', '<Esc>')

-- DEL: Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').commands, { desc = '[ ] Find commands' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Show diagnostics float' })

-- DEL: BufferLine keymaps
vim.keymap.set('n', 'H', ':BufferLineCyclePrev<cr>', { desc = 'Move to previous buffer' })
vim.keymap.set('n', 'L', ':BufferLineCycleNext<cr>', { desc = 'Move to next buffer' })
vim.keymap.set('n', '<A-1>', ':BufferLineGoToBuffer 1<cr>', { desc = 'Go to BufferLine tab 1' })
vim.keymap.set('n', '<A-2>', ':BufferLineGoToBuffer 2<cr>', { desc = 'Go to BufferLine tab 2' })
vim.keymap.set('n', '<A-3>', ':BufferLineGoToBuffer 3<cr>', { desc = 'Go to BufferLine tab 3' })
vim.keymap.set('n', '<A-4>', ':BufferLineGoToBuffer 4<cr>', { desc = 'Go to BufferLine tab 4' })
vim.keymap.set('n', '<A-5>', ':BufferLineGoToBuffer 5<cr>', { desc = 'Go to BufferLine tab 5' })
vim.keymap.set('n', '<A-6>', ':BufferLineGoToBuffer 6<cr>', { desc = 'Go to BufferLine tab 6' })
vim.keymap.set('n', '<A-7>', ':BufferLineGoToBuffer 7<cr>', { desc = 'Go to BufferLine tab 7' })
vim.keymap.set('n', '<A-8>', ':BufferLineGoToBuffer 8<cr>', { desc = 'Go to BufferLine tab 8' })
vim.keymap.set('n', '<A-9>', ':BufferLineGoToBuffer 9<cr>', { desc = 'Go to BufferLine tab 9' })
vim.keymap.set('n', '<A-S-h>', ':BufferLineMovePrev<cr>', { desc = 'Move buffer to the left' })
vim.keymap.set('n', '<A-S-l>', ':BufferLineMoveNext<cr>', { desc = 'Move buffer to the right' })

-- Buffer actions
-- DEL:
vim.keymap.set('n', '<leader>c', ':Bwipeout<cr>', { desc = 'Close current buffer' })
-- DEL:
vim.keymap.set('n', '<leader>cc', ':Bwipeout!<cr>', { desc = 'Forcefuly Close current buffer' })
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = '[W]rite changes to buffer' })
vim.keymap.set('n', '<leader>wa', ':wa<cr>', { desc = '[W]rite changes to [a]ll buffer' })
vim.keymap.set('n', '<leader>q', ':q<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>qq', ':qa<cr>', { desc = 'Quit all' })
vim.keymap.set('n', '<A-d>', ':t .<cr>', { desc = 'Duplicate line below' })
vim.keymap.set('v', '<A-d>', ':\'<,\'>t \'><cr>', { desc = 'Duplicate selection below' })
vim.keymap.set('n', '<Tab>', [[v>]], { desc = 'Indent line' })
vim.keymap.set('n', '<S-Tab>', [[v<]], { desc = 'Unindent line' })
vim.keymap.set('v', '<Tab>', [[>gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('v', '<S-Tab>', [[<gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('i', '<S-Tab>', [[<BS>]], { desc = 'Provide un-tab in insert mode' })

-- Buffer shortcuts
vim.keymap.set('n', '<leader>st', ':set filetype=', { desc = '[S]et buffer File[T]ype'})
vim.keymap.set('n', '<leader>sb', ':set background=', { desc = '[S]et [B]ackground' })
vim.keymap.set('n', '<leader>sc', ':colorscheme ', { desc = '[S]et [C]olorscheme' })

-- Move between splits
vim.keymap.set('n', '<C-h>', ':wincmd h<cr>', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', ':wincmd j<cr>', { desc = 'Move to down split' })
vim.keymap.set('n', '<C-k>', ':wincmd k<cr>', { desc = 'Move to up split' })
vim.keymap.set('n', '<C-l>', ':wincmd l<cr>', { desc = 'Move to right split' })
vim.keymap.set('n', '<C-q>', ':wincmd q<cr>', { desc = 'Close window' })

-- DEL: Toggle NeoTree
local neotree_open = false
local function neotree_toggle(_)
  neotree_open = not neotree_open
  vim.cmd('Neotree toggle')
end
vim.keymap.set('n', '<leader>e', neotree_toggle, { desc = 'Toggle File [E]xplorer' })

-- DEL: Move.nvim actions
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<cr>', { desc = 'Move line up' })
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<cr>', { desc = 'Move line down' })
vim.keymap.set('n', '<A-h>', ':MoveHChar(1)<cr>', { desc = 'Move character right' })
vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<cr>', { desc = 'Move character left' })
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<cr>', { desc = 'Move block up' })
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<cr>', { desc = 'Move block down' })
vim.keymap.set('v', '<A-h>', ':MoveHBlock(1)<cr>', { desc = 'Move block right' })
vim.keymap.set('v', '<A-h>', ':MoveHBlock(1)<cr>', { desc = 'Move block right' })

-- DEL: ToggleTerm keymaps
vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=horizontal<cr>', { desc = 'Toggle bottom terminal' })
vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<cr>', { desc = 'Toggle floating terminal' })
vim.keymap.set('n', '<F7>', ':ToggleTerm<cr>', { desc = 'Toggle terminal' })
vim.keymap.set('t', '<F7>', [[<cmd>ToggleTerm<cr>]], { desc = 'Toggle terminal' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Escape from terminal mode' })
vim.keymap.set('t', '<C-h>', [[<esc><cmd>wincmd h<cr>]], { desc = 'Move to left split' })
vim.keymap.set('t', '<C-j>', [[<esc><cmd>wincmd j<cr>]], { desc = 'Move to down split' })
vim.keymap.set('t', '<C-k>', [[<esc><cmd>wincmd k<cr>]], { desc = 'Move to up split' })
vim.keymap.set('t', '<C-l>', [[<esc><cmd>wincmd l<cr>]], { desc = 'Move to right split' })

-- DEL: Session management
vim.keymap.set('n', '<leader>ss', ':SearchSession<cr>', { desc = '[S]earch [S]ession' })
vim.keymap.set('n', '<leader>rs', ':SessionRestore<cr>', { desc = '[R]estore [S]ession' })

-- DEL: Doxygen generation
vim.keymap.set('n', '<leader>dg', require('neogen').generate, { desc = "Generate [D]oxy[G]en comments", noremap = true, silent = true, })

-- DEL: DAP UI
local dapui = require('dapui')
local debug_ui = {
  opened = false,    -- Current state of dapui
  neotree_opened = false,   -- If neotree was opened before opening the dapui
  toggleterm_opened = false,  -- If toggle term was opened before the dapui
}
local function toggle_debug_ui(opts)
  debug_ui.opened = not debug_ui.opened
  if debug_ui.opened then  -- Show debug UI
    -- Hide neotree
    if neotree_open then
      debug_ui.neotree_opened = true
      neotree_toggle()
    else debug_ui.neotree_opened = false end
    -- Hide toggle term
    debug_ui.toggleterm_opened = false
    for _, term in ipairs(require('toggleterm.terminal').get_all(false)) do
      local tu = require'toggleterm.ui'
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
vim.keymap.set('n', '<F8>', toggle_debug_ui, { desc = '[D]ap[U]i toggle' })

-- DEL: Nvim DAP
local dap = require('dap')
vim.keymap.set('n', '<F3>', dap.terminate, { desc = 'Stop debugging' })
vim.keymap.set('n', '<F4>', dap.restart, { desc = 'Restart debugging' })
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Start/Continue debugging' })
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debugging step over' })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debugging step into' })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debugging step out' })
dap.listeners.after.event_initialized["dapui_config"] = function (opts)
  if not debug_ui.opened then toggle_debug_ui(opts) end
end
local function close_debug_ui(opts) if debug_ui.opened then toggle_debug_ui(opts) end end
dap.listeners.after.event_terminated["dapui_config"] = close_debug_ui
dap.listeners.before.event_exited["dapui_config"] = close_debug_ui

-- Useful workflow keybindings
vim.keymap.set('n', '<C-F5>', ':wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { remap = true, desc = "make run" })
vim.keymap.set('i', '<C-F5>', '<ESC>:wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { desc = "make run" })
vim.keymap.set('n', '<F29>', ':wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { remap = true, desc = "make run" })
vim.keymap.set('i', '<F29>', '<ESC>:wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { desc = "make run" })

vim.keymap.set('n', '<as-B>', ':wa<cr>:ToggleTerm<cr>i<C-u>make build<cr>', { remap = true, desc = "make build" })
vim.keymap.set('i', '<as-B>', '<ESC>:wa<cr>:ToggleTerm<cr>i<C-u>make build<cr>', { remap = true, desc = "make build" })
