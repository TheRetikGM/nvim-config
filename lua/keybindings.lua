-- Setup keybinds for each plugin in `plugins/` directory.
FOR_EACH_PLUGIN(function(plugin)
  if plugin.keybinds ~= nil then
    plugin.keybinds()
    return
  end

  -- NOTE: I'm too dumb to remember which one is it :)
  if plugin.keymaps ~= nil then
    plugin.keymaps()
    return
  end
end)

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

-- Useful buffer keybindings
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = '[W]rite changes to buffer' })
vim.keymap.set('n', '<leader>wa', ':wa<cr>', { desc = '[W]rite changes to [a]ll buffer' })
vim.keymap.set('n', '<A-d>', ':t .<cr>', { desc = 'Duplicate line below' })
vim.keymap.set('v', '<A-d>', ':\'<,\'>t \'><cr>', { desc = 'Duplicate selection below' })
vim.keymap.set('n', '<Tab>', [[v>]], { desc = 'Indent line' })
vim.keymap.set('n', '<S-Tab>', [[v<]], { desc = 'Unindent line' })
vim.keymap.set('v', '<Tab>', [[>gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('v', '<S-Tab>', [[<gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('i', '<S-Tab>', [[<BS>]], { desc = 'Provide un-tab in insert mode' })

-- Useful workflow keybindings
vim.keymap.set('n', '<C-F5>', ':wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { remap = true, desc = "make run" })
vim.keymap.set('i', '<C-F5>', '<ESC>:wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { desc = "make run" })
vim.keymap.set('n', '<F29>', ':wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { remap = true, desc = "make run" })
vim.keymap.set('i', '<F29>', '<ESC>:wa<cr>:ToggleTerm<cr>i<C-u>make run<cr>', { desc = "make run" })

vim.keymap.set('n', '<as-B>', ':wa<cr>:ToggleTerm<cr>i<C-u>make build<cr>', { remap = true, desc = "make build" })
vim.keymap.set('i', '<as-B>', '<ESC>:wa<cr>:ToggleTerm<cr>i<C-u>make build<cr>', { remap = true, desc = "make build" })
