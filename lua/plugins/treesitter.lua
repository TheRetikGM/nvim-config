return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    opts = {},
    priority = 1000,
    enabled = true,
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function(args)
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft)

          if not lang or not vim.treesitter.language.add(lang) then
            return
          end

          vim.treesitter.start()

          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
          -- Doesn't work reliably. I use vim.o.smartindent for now
          -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      })
    end,
    config = function()
      local ts = require('nvim-treesitter')

      ts.setup {
        install_dir = vim.fn.stdpath('data') .. '/site'
      }

      -- No-op if the parsers are already installed
      ts.install { 'c', 'cpp', 'go', 'lua', 'python', 'typescript', 'vimdoc', 'vim', 'html', 'css', 'json', 'json5', 'php', 'phpdoc', 'javascript', 'comment', 'ini' }
    end,
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-textobjects'
  -- },
}
