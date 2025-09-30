local function update_lualine(theme_name)
  require('lualine').setup({
    options = {
      theme = theme_name
    }
  })
end

local function update_bufferline(theme_name)
  -- local use_override = THEME_PICKER_BUFFERLINE_HL_O[theme_name]
  -- local options = PLUGINS.bufferline.options
  --
  -- if use_override ~= nil and use_override == true then
  --   options["highlight"] = {
  --     separator = {
  --       fg = { attribute = 'bg', highlight = 'diffRemoved' },
  --     },
  --     separator_visible = {
  --       fg = { attribute = 'bg', highlight = 'diffRemoved' },
  --     },
  --     separator_selected = {
  --       fg = { attribute = 'bg', highlight = 'diffRemoved' },
  --     },
  --   }
  -- end
  --
  -- require('bufferline').setup({ options = options })
end

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

      if THEME_PICKER_VARIANTS[theme_name] ~= nil then
        local count = 0
        for _, theme_config in pairs(THEME_PICKER_VARIANTS[theme_name]) do
          all_themes[i - m + count] = {
            name = theme_config.name,
            colorscheme = theme_config.colorscheme,
            after = function()
              theme_config.after()
              update_bufferline(theme_name)
              update_lualine(theme_name)
            end
          }
          count = count + 1
        end
        m = m - (count - 1)
      else
        all_themes[i - m] = {
          name = theme_name,
          colorscheme = theme_name,
          after = function()
            update_lualine(theme_name)
            update_bufferline(theme_name)
          end
        }
      end

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
  end,
  prio = 1000 -- all theme plugins must be before this plugin
}
