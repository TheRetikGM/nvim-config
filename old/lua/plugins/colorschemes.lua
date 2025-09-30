LUALINE_THEME="gruvbox"
THEME_PICKER_VARIANTS = {}
THEME_PICKER_BUFFERLINE_HL_O = {}

function U.enable_bufferline_override(name)
  THEME_PICKER_BUFFERLINE_HL_O[name] = true
end

function U.add_light_dark_variants(name, colorscheme, opts)
  local light_func = function()
    vim.cmd('set background=light')
  end

  local dark_func = function()
    vim.cmd('set background=dark')
  end

  if opts.light_func ~= nil then
    light_func = opts.light_func
  end

  if opts.dark_func ~= nil then
    dark_func = opts.dark_func
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
end

require('plugins.colorschemes.gruvbox')
require('plugins.colorschemes.vscode')
require('plugins.colorschemes.papercolor')
require('plugins.colorschemes.jb')

