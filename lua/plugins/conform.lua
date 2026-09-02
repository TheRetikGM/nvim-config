return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo' },
  keys = {
    {
      -- Format the current line (mirrors built-in `==`)
      '==',
      function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        require('conform').format({
          async = true,
          range = {
            start = { row, 0 },
            ['end'] = { row, #vim.api.nvim_get_current_line() },
          },
        })
      end,
      mode = 'n',
      desc = 'Format current line',
    },
    {
      -- Format the current selection (conform defaults to the visual range)
      '=',
      function()
        require('conform').format({ async = true })
      end,
      mode = 'x',
      desc = 'Format selection',
    },
  },
  opts = {
    -- Fall back to LSP formatting for any filetype without a configured
    -- formatter below. C# is handled this way: Roslyn formats via .editorconfig.
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      -- No `cs` entry on purpose -> falls through to the Roslyn LSP,
      -- which respects the same .editorconfig keys that Rider uses.
    },
  },
}
