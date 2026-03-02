return {
  setup = function()
    -- Set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
    vim.o.winborder = 'rounded' -- Hooray! Neovim builtin since Oct-2025

    require('mini.completion').setup({
      window = {
        info = {
          border = 'rounded',
        },
        signature = {
          border = 'rounded'
        },
      },
      lsp_completion = {
        source_func = 'omnifunc' -- Omnifunc is filetype specific, switch to completefunc if problems arise.
      }
    })

    -- From help
    local on_attach = function(args)
      vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
    vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })

    -- To use `<Tab>` and `<S-Tab>` for navigation through completion list, make
    -- these mappings: >lua
    local imap_expr = function(lhs, rhs)
      vim.keymap.set('i', lhs, rhs, { expr = true })
    end
    imap_expr('<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
    imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

    -- Configure icons
    require('mini.icons').tweak_lsp_kind()
  end
}
