return {
  setup = function()
    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'

    require('mini.completion').setup({
      window = {
        info = {
          border = 'single',
        },
        signature = {
          border = 'single'
        },
      }
    })

    require('mini.icons').tweak_lsp_kind()
  end
}
