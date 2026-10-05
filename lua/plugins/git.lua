return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gs', vim.cmd.Git, desc = 'Git Status' },
      { '<leader>gp', function() vim.cmd.Git 'push' end, desc = 'Git Push', },
      { '<leader>gl', function() vim.cmd.Git({'pull', '--rebase'}) end, desc = 'Git Pull', },
      { '<leader>gf', function() vim.cmd.Git 'fetch' end, desc = 'Git Fetch', },
      { '<leader>gb', function() require('telescope.builtin').git_branches() end, desc = 'Git Branches', },
      { '<leader>gu', function()
        local branch = vim.fn.system "git branch --show-current 2> /dev/null | tr -d '\n'"
        vim.cmd('Git push --set-upstream origin ' .. branch)
      end, desc = 'Git Push Current Branch', },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
  }
}
