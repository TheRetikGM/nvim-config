PLUGINS.papercolor = {
  packer = { 'NLKNguyen/papercolor-theme' },
    setup = function()
      U.add_light_dark_variants('PaperColor', 'PaperColor', {
        dark_func = function()
          vim.cmd('set background=dark')

          -- With this colorscheme the jump labels have the same color as the match - making them hard to see
          vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ffffff", bg = "#d75f00", bold = false })
        end
      })
    end,
  prio = -41  -- before theme_picker
}
