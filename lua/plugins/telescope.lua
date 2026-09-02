-- Mostly replaced by mini.pick and mini.extra.pickers
return {
  {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    config = function()
      require('telescope').setup({
        -- Note that we are using mini for searching files, so this doesn't have effect on searching files.
        file_ignore_patterns = { "node_modules", "build", "builddir", "dist", "target", "bin", "obj" }
      })

      pcall(require('telescope').load_extension, 'fzf')

      -- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').commands, { desc = '[ ] Find commands' })

      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer]' })
    end
  },
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable 'make' == 1
  }
}
