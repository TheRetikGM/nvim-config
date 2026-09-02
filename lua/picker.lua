-- Plugin independent selection of pickers

local snacks = require('snacks')
local pick = require('mini.pick')
local pickext = require('mini.extra').pickers
local trouble = require('trouble')

return {
  files = function() pick.builtin.files({ tool = 'fd' }) end,
  -- buffers = function() vim.cmd('Pick buffers') end,
  buffers = snacks.picker.buffers,
  help = pick.builtin.help,
  commands = pickext.commands,
  diagnostic = snacks.picker.diagnostics_buffer,
  keymaps = pickext.keymaps,
  quick_explorer = pickext.explorer,
  explorer = function() snacks.explorer() end,
  definition = vim.lsp.buf.definition,
  declaration = function() pickext.lsp({ scope = 'declaration' }) end,
  references = snacks.picker.lsp_references,
  references_dock = function()
    trouble.open({
      mode = "lsp_references",
      auto_refresh = false,
      focus = true,
      preview = {
        type = "main" -- main|float|split
      }
    })
  end,
  implementation = snacks.picker.lsp_implementations,
  type_definition = snacks.picker.lsp_type_definitions,
  document_symbol = snacks.picker.lsp_symbols,
  workspace_symbol = snacks.picker.lsp_workspace_symbols,
  dyn_workspace_symbol = require('telescope.builtin').lsp_dynamic_workspace_symbols,
  live_grep = require('telescope.builtin').live_grep,
}
