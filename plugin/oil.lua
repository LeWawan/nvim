local wh = require('thewawan.helpers')

vim.pack.add({
  wh.gh('stevearc/oil.nvim'),
  wh.gh('nvim-tree/nvim-web-devicons'),
})

require('oil').setup {
  columns = { 'icon' },
  view_options = {
    show_hidden = true,
  },
}

vim.keymap.set('n', '=', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

