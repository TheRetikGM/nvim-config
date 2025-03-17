-- Live theme selection
PLUGINS.theme_picker = {
  packer = { 'panghu-huang/theme-picker.nvim', commit = 'c52dcd69ea6c799e61f84d404ae821a845a19d1d' },
  setup = function()
    local all_theme_names = vim.fn.getcompletion('', 'color')
    local all_themes = {}
    local m = 0

    for i, theme_name in pairs(all_theme_names) do
      if theme_name == 'one-nvim' then
        m = m + 1
        goto continue
      end

      all_themes[i - m] = {
        name = theme_name,
        colorscheme = theme_name,
      }

      ::continue::
    end

    require('theme-picker').setup({
      themes = all_themes,
      picker = {
        prompt_title = 'Select theme',
        layout_config = {
          width = 0.35,
          height = 0.5,
          prompt_position = 'top'
        },
      }
    })
  end,
  keymaps = function()
    vim.keymap.set('n', '<leader>sc', require('theme-picker').open_theme_picker, { desc = '[S]et [c]olor theme' })
  end
}
