neotree_open = false -- used by dapui
function neotree_toggle(_)
  neotree_open = not neotree_open
  vim.cmd('Neotree toggle')
end

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

PLUGINS.neotree = {
  packer = {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
  keymaps = function()
    vim.keymap.set('n', '<leader>e', neotree_toggle, { desc = 'Toggle File [E]xplorer' })
  end,
  prio = 30,
}
