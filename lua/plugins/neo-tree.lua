neotree_open = false -- used by dapui
function neotree_toggle(_)
  neotree_open = not neotree_open
  vim.cmd('Neotree toggle')
end

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = { },
    config = function(lazy_plugin, opts)
      vim.keymap.set('n', '<leader>e', neotree_toggle, { desc = 'Toggle File [E]xplorer' })
    end
  }
}
