return {
  {
    'nvim-mini/mini.nvim',
    version = '*',
    config = function()
      ----------------------
      --- Text editing
      ----------------------
      require('mini.snippets').setup()           -- Manage and expand snippets
      require('mini_setups.keymap').setup()      -- Use tab for completion and more smart stuff
      require('mini_setups.completion').setup()  -- Completion plugin (alternative to nvim-cmp)
      require('mini_setups.align').setup()       -- Align options (TODO keybindings)
      require('mini.pairs').setup()              -- Autopairs for ([{}]) etc
      require('mini_setups.surround').setup()    -- Surround actions (eg.: word -> "word") (TODO keybindings)

      ----------------------
      --- General workflow
      ----------------------
      require('mini_setups.basics').setup()        -- Basic functionality
      require('mini_setups.clue').setup()          -- Show keybinding clues
      require('mini_setups.bufremove').setup()     -- Remove buffers
      require('mini.git').setup()                  -- Git integration
      require('mini_setups.pick').setup()          -- Pick anything (like telescope)
      require('mini.jump').setup()                 -- Extend f F t T and more

      ----------------------
      --- Appearance
      ----------------------
      require('mini.icons').setup()           -- Icon provider
      -- require('mini_setups.notify').setup()   -- Show notifications
      require('mini.indentscope').setup()     -- Visualize indent scope
    end
  }
}

