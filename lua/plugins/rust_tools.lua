-- Rust tools - Automatically configure rust_analyzer
PLUGINS.rust_tools = {
  packer = { 'simrat39/rust-tools.nvim' },
  setup = function()
    local extension_path = vim.env.HOME .. '.local/share/nvim/mason/packages/codelldb/extension/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
    local rt = require("rust-tools")
    rt.setup({
      server = {
        on_attach = function(_, bufnr)
          -- Hover actions
          vim.keymap.set("n", "<leader>h", rt.hover_actions.hover_actions, { desc = "Rust [H]over action", buffer = bufnr })
          -- Code action groups
          vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
      },
      dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
      },
    })
  end
}

