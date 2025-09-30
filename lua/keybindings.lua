-- Clear search highlight on normal mode esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Split mappings -- most provided by mini.basics
vim.keymap.set('n', '<C-q>', function() vim.cmd('wincmd q') end, { desc = "Quit split" })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Show diagnostics float' })

-- Buffer shortcuts
vim.keymap.set('n', '<leader>st', ':set filetype=', { desc = '[S]et buffer File[T]ype'})

-- Useful buffer keybindings
vim.keymap.set('n', '<leader>ww', function() vim.cmd('w') end, { desc = '[W]rite changes to buffer' })
vim.keymap.set('n', '<leader>wa', function() vim.cmd('wa') end, { desc = '[W]rite changes to [a]ll buffer' })
vim.keymap.set('n', '<A-d>', function() vim.cmd('t .') end, { desc = 'Duplicate line below' })
vim.keymap.set('v', '<A-d>', function() vim.cmd(':\'<,\'>t \'>') end, { desc = 'Duplicate selection below' })
vim.keymap.set('n', '<Tab>', [[v>]], { desc = 'Indent line' })
vim.keymap.set('n', '<S-Tab>', [[v<]], { desc = 'Unindent line' })
vim.keymap.set('v', '<Tab>', [[>gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('v', '<S-Tab>', [[<gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('i', '<S-Tab>', [[<BS>]], { desc = 'Provide un-tab in insert mode' })

-- Tab keybindings
local function bufmap(mode, key, action, desc, del)
  if del then
    vim.keymap.del(mode, key, { buffer = true })
  else
    vim.keymap.set(mode, key, action, { desc = desc, buffer = true})
  end
end

local function immersive_term_mode(del)
  bufmap('t', '<C-Esc>', [[<C-\><C-n>]], 'Normal mode', del)
  bufmap('t', '<C-o>k', [[<C-\><C-n><C-w>k]], 'Move to up split', del)
  bufmap('t', '<C-o>j', [[<C-\><C-n><C-w>j]], 'Move to down split', del)
  bufmap('t', '<C-o>h', [[<C-\><C-n><C-w>h]], 'Move to left split', del)
  bufmap('t', '<C-o>l', [[<C-\><C-n><C-w>l]], 'Move to right split', del)
end

local function light_term_mode(del)
  bufmap('t', '<Esc>', [[<C-\><C-n>]], 'Normal mode', del)
  bufmap('t', '<C-k>', [[<C-\><C-n><C-w>ki]], 'Move to up split', del)
  bufmap('t', '<C-j>', [[<C-\><C-n><C-w>ji]], 'Move to down split', del)
  bufmap('t', '<C-h>', [[<C-\><C-n><C-w>hi]], 'Move to left split', del)
  bufmap('t', '<C-l>', [[<C-\><C-n><C-w>li]], 'Move to right split', del)
end

local term_mode = false

-- Terminal keybindings
vim.api.nvim_create_user_command("ToggleTermMode", function()
  term_mode = not term_mode

  if term_mode then
    light_term_mode(true)
    immersive_term_mode(false)
  else
    immersive_term_mode(true)
    light_term_mode(false)
  end
end, { nargs = 0 })

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function(_)
    if term_mode then
      immersive_term_mode(false)
    else
      light_term_mode(false)
    end
  end
})

vim.keymap.set('t', '<F7>', [[<C-\><C-n>:tabnext<cr>]], { desc = 'Next tab' })
vim.keymap.set('n', '<F7>', function() vim.cmd('tabnext') end, { desc = 'Next tab' })
vim.keymap.set('i', '<F7>', [[<esc>:tabnext<cr>]], { desc = 'Next tab' })
vim.keymap.set('v', '<F7>', [[<esc>:tabnext<cr>]], { desc = 'Next tab' })
vim.keymap.set('n', '<leader>t', function() vim.cmd('tabnext') end, { desc = 'Next tab' })
