return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  config = function()
    -- Fzf
    vim.keymap.set('n', '<leader>gs', function()
      vim.cmd.Git()
    end)
    vim.keymap.set('n', '<leader>gp', function()
      vim.cmd.Git 'push'
    end)
    vim.keymap.set('n', '<leader>gl', function()
      vim.cmd.Git 'pull'
    end)
    vim.keymap.set('n', '<leader>gf', function()
      vim.cmd.Git 'fetch'
    end)

    vim.keymap.set('n', '<leader>gu', function()
      local branch = vim.fn.system "git branch --show-current 2> /dev/null | tr -d '\n'"
      vim.cmd('Git push --set-upstream origin ' .. branch)
    end)
  end,
}
