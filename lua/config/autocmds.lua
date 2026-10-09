local TheWawanGroup = vim.api.nvim_create_augroup('TheWawan', { clear = true })

-- Auto remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = TheWawanGroup,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = TheWawanGroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})
