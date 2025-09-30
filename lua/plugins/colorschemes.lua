LUALINE_THEME="gruvbox"
THEME_PICKER_VARIANTS = {}
THEME_PICKER_BUFFERLINE_HL_O = {}

local U = {
  enable_bufferline_override = function(name)
    THEME_PICKER_BUFFERLINE_HL_O[name] = true
  end,
  add_light_dark_variants = function(name, colorscheme, opts)
    local light_func = opts.light_func or function()
      vim.cmd('set background=light')
    end

    local dark_func = opts.dark_func or function()
      vim.cmd('set background=dark')
    end

    THEME_PICKER_VARIANTS[name] = {
      {
        name = name .. " (dark)",
        colorscheme = colorscheme,
        after = dark_func
      },
      {
        name = name .. " (light)",
        colorscheme = colorscheme,
        after = light_func
      }
    }
  end,
  add_variants = function(name, opts)
    THEME_PICKER_VARIANTS[name] = {}
    local fmt = opts.name_format or function(v)
      return name .. "(" .. v .. ")"
    end
    local load = opts.variant_load or function(_) end

    for _, variant_name in pairs(opts.variant_names) do
      table.insert(THEME_PICKER_VARIANTS[name], {
        name = fmt(variant_name),
        colorscheme = name,
        after = function()
          load(variant_name)
        end,
      })
    end
  end,
  update_lualine = function(theme_name)
    require('lualine').setup({
      options = {
        theme = theme_name
      }
    })
  end,
  update_bufferline = function(_)
  end,
}

return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      local kanagawa = require('kanagawa')
      kanagawa.setup()
    end
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      local onedark = require('onedark')
      onedark.setup({ style = 'darker' })

      U.add_variants('onedark', {
        variant_names = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' },
        variant_load = function(variant_name)
          onedark.setup({ style = variant_name })
          onedark.load()
        end,
        name_format = function(variant_name)
          return "OneDark (" .. variant_name .. ")"
        end
      })
    end
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "",  -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
    config = function()
      U.add_light_dark_variants('gruvbox', 'gruvbox', {})
    end,
  },
  {
    'nickkadutskyi/jb.nvim',
    config = function()
      U.add_light_dark_variants('jb', 'jb', {})
    end,
    lazy = false,
    priority = 1000,
  },
  {
    'NLKNguyen/papercolor-theme',
    config = function()
        U.add_light_dark_variants('PaperColor', 'PaperColor', {
          dark_func = function()
            vim.cmd('set background=dark')

            -- With this colorscheme the jump labels have the same color as the match - making them hard to see
            vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ffffff", bg = "#d75f00", bold = false })
          end
        })
    end,
    lazy = false,
    priority = 1000,
  },
  {
    'Mofiqul/vscode.nvim',
    opts = {
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
    },
    config = function()
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
    lazy = false,
    priority = 1000,
  },
  -- Live theme selection
  {
    'panghu-huang/theme-picker.nvim',
    lazy = false,
    config = function()
      local all_theme_names = vim.fn.getcompletion('', 'color')
      local all_themes = {}
      local m = 0

      for i, theme_name in pairs(all_theme_names) do
        if THEME_PICKER_VARIANTS[theme_name] ~= nil then
          local count = 0
          for _, theme_config in pairs(THEME_PICKER_VARIANTS[theme_name]) do
            all_themes[i - m + count] = {
              name = theme_config.name,
              colorscheme = theme_config.colorscheme,
              after = function()
                theme_config.after()
                U.update_bufferline(theme_name)
                U.update_lualine(theme_name)
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
              U.update_lualine(theme_name)
              U.update_bufferline(theme_name)
            end
          }
        end
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

      vim.keymap.set('n', '<leader>sc', require('theme-picker').open_theme_picker, { desc = '[S]et [c]olor theme' })
    end,
  }
}
