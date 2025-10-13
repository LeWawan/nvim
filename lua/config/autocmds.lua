local user_group = vim.api.nvim_create_augroup('user_group', { clear = true })

-- Auto remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = user_group,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = user_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})
