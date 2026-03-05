return {
  {
    'laytan/cloak.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      local cloak = require 'cloak'
      cloak.setup()

      vim.keymap.set('n', '<leader>xx', function()
        cloak.toggle()
      end)
    end,
  },
}
