PLUGINS.bufferline = {
  packer = {
    'akinsho/bufferline.nvim',
    tag = "v4.*",
    requires = 'nvim-tree/nvim-web-devicons'
  },
  setup = function()
    -- Setup bufferline plugin (requires vim.opt.termguicolors = true)
    vim.opt.mousemoveevent = true
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, _, _)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        buffer_close_icon = "",
        close_command = "bdelete %d",
        close_icon = "",
        indicator = {
          style = "icon",
          icon = " ",
        },
        left_trunc_marker = "",
        modified_icon = "●",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = ' ', -- use a "true" to enable the default, or set your own character
          }
        },
        separator_style = "slant",
        numbers = function(opts) return string.format('%s', opts.raise(opts.ordinal)) end,
        right_mouse_command = "bdelete! %d",
        right_trunc_marker = "",
        show_close_icon = false,
        show_tab_indicators = true,
      },
      highlights = {
       separator = {
          fg = { attribute = 'bg', highlight = 'StatusLineNC' },
        },
        separator_visible = {
          fg = { attribute = 'bg', highlight = 'StatusLineNC' },
        },
        separator_selected = {
          fg = { attribute = 'bg', highlight = 'StatusLineNC' },
        },
      },
    })
  end,
  keymaps = function()
    vim.keymap.set('n', 'H', ':BufferLineCyclePrev<cr>', { desc = 'Move to previous buffer' })
    vim.keymap.set('n', 'L', ':BufferLineCycleNext<cr>', { desc = 'Move to next buffer' })
    vim.keymap.set('n', '<A-1>', ':BufferLineGoToBuffer 1<cr>', { desc = 'Go to BufferLine tab 1' })
    vim.keymap.set('n', '<A-2>', ':BufferLineGoToBuffer 2<cr>', { desc = 'Go to BufferLine tab 2' })
    vim.keymap.set('n', '<A-3>', ':BufferLineGoToBuffer 3<cr>', { desc = 'Go to BufferLine tab 3' })
    vim.keymap.set('n', '<A-4>', ':BufferLineGoToBuffer 4<cr>', { desc = 'Go to BufferLine tab 4' })
    vim.keymap.set('n', '<A-5>', ':BufferLineGoToBuffer 5<cr>', { desc = 'Go to BufferLine tab 5' })
    vim.keymap.set('n', '<A-6>', ':BufferLineGoToBuffer 6<cr>', { desc = 'Go to BufferLine tab 6' })
    vim.keymap.set('n', '<A-7>', ':BufferLineGoToBuffer 7<cr>', { desc = 'Go to BufferLine tab 7' })
    vim.keymap.set('n', '<A-8>', ':BufferLineGoToBuffer 8<cr>', { desc = 'Go to BufferLine tab 8' })
    vim.keymap.set('n', '<A-9>', ':BufferLineGoToBuffer 9<cr>', { desc = 'Go to BufferLine tab 9' })
    vim.keymap.set('n', '<A-S-h>', ':BufferLineMovePrev<cr>', { desc = 'Move buffer to the left' })
    vim.keymap.set('n', '<A-S-l>', ':BufferLineMoveNext<cr>', { desc = 'Move buffer to the right' })
  end,
  prio = 30,
}
