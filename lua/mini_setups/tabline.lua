return {
  setup = function()
    local mini_tabline = require('mini.tabline')
    mini_tabline.setup({
      format = function(buf_id, label)
        local prefix = vim.bo[buf_id].modified and '● ' or ''
        return prefix .. mini_tabline.default_format(buf_id, label)
      end,
      tabpage_section = 'right'
    })
  end
}
