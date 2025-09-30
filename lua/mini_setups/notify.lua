return {
  setup = function()
    require('mini.notify').setup({
      lsp_progress = {
        enable = false,   -- We use fugitive for that.
      }
    })

    vim.notify = require('mini.notify').make_notify({
      ERROR = { duration = 5000 },
      WARN  = { duration = 4000 },
      INFO  = { duration = 3000 },
    })
  end
}

