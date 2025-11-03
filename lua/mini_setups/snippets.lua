return {
  setup = function ()
    require('mini.snippets').setup()

    local jump_next = function()
      if vim.snippet.active({direction = 1}) then return vim.snippet.jump(1) end
    end
    local jump_prev = function()
      if vim.snippet.active({direction = -1}) then vim.snippet.jump(-1) end
    end

    -- Doesn't work for some reason
    vim.keymap.set({ 'i', 's' }, '<Tab>', jump_next)
    vim.keymap.set({ 'i', 's' }, '<S-Tab>', jump_prev)
  end
}
