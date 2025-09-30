PLUGINS.vscode = {
  packer = { 'Mofiqul/vscode.nvim' },
  setup = function()
    require('vscode').setup({
      style = 'dark',
      transparent = false,
      italic_comments = true,
      underline_links = true,
      disable_nvimtree_bg = false,
      group_overrides = {
        -- Make the borders of hover and diagnostics have the correct color
        FloatBorder = { link = "LspFloatWinBorder" },
        BufferLineSeparator = {
          fg = vim.fn.synIDattr(vim.fn.hlID("StatusLineNC"), "bg"),
        },
        BufferLineSeparatorVisible = {
          fg = vim.fn.synIDattr(vim.fn.hlID("StatusLineNC"), "bg"),
        },
        BufferLineSeparatorSelected = {
          fg = vim.fn.synIDattr(vim.fn.hlID("StatusLineNC"), "bg"),
        },
        BufferLineBufferSelected = {
          bold = true,
          italic = true,
        },
      },
    })
    require('vscode').load()

    local theme_name = 'vscode'
    U.enable_bufferline_override(theme_name)
    U.add_light_dark_variants(theme_name, theme_name, {
      light_func = function()
        require('vscode').load('light')
      end,
      dark_func = function()
        require('vscode').load('dark')
      end
    })
  end,
  prio = -41, -- before lualine
}
