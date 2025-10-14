return {
  setup = function()
    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'

    require('mini.completion').setup({
      window = {
        info = {
          border = 'rounded',
        },
        signature = {
          border = 'rounded'
        },
      }
    })

    require('mini.icons').tweak_lsp_kind()
  end
}
