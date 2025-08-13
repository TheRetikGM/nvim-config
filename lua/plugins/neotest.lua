PLUGINS.neotest = {
  packer = {
    "nvim-neotest/neotest",
    commit = '3c81345c28cd639fcc02843ed3653be462f47024',
    requires = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "rouge8/neotest-rust", commit = '6f79e8468a254d4fe59abf5ca8703c125c16a1e3' }
    }
  },
  setup = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rust")
      }
    })
  end,
  keybinds = function()
    local neotest = require('neotest')
    vim.keymap.set('n', '<leader>nr', function() neotest.run.run() end, { desc = '[N]eotest [R]un' } )
    vim.keymap.set('n', '<leader>nf', function() neotest.run.run(vim.fn.expand('%')) end, { desc = '[N]eotest Run [F]ile' } )
    vim.keymap.set('n', '<leader>ns', function() neotest.summary.toggle() end, { desc = '[N]eotest [S]ummary' } )
    vim.keymap.set('n', '<leader>no', function() neotest.output_panel.toggle() end, { desc = '[N]eotest [O]output Panel' } )
  end,
}
