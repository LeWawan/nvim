local wh = require('thewawan.helpers')

vim.pack.add({
  wh.gh('tpope/vim-fugitive'),
  wh.gh('lewis6991/gitsigns.nvim'),

  -- Deps
  wh.gh('nvim-telescope/telescope.nvim'),
  wh.gh('nvim-lua/plenary.nvim'),
})

vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' })
vim.keymap.set('n', '<leader>gl', function() vim.cmd.Git { 'pull', '--rebase' } end, { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gp', function() vim.cmd.Git { 'push' } end, { desc = 'Git push' })
vim.keymap.set('n', '<leader>gf', function() vim.cmd.Git 'fetch' end, { desc = 'Git fetch' })
vim.keymap.set('n', '<leader>gb', function() require('telescope.builtin').git_branches() end, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gu', function()
  local branch = vim.fn.system "git branch --show-current 2> /dev/null | tr -d '\n'"
  vim.cmd.Git { 'push --set-upstream origin ' ..branch }
end, { desc = 'Git push branch upstream origin'})
