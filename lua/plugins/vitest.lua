return {
  'nvim-neotest/neotest',
  dependencies = {
    'marilari88/neotest-vitest',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local neotest = require 'neotest'

    neotest.setup {
      adapters = {
        require 'neotest-vitest',
      },
    }

    vim.keymap.set('n', '<leader>tr', ':Neotest run<CR>', { desc = 'Run current file' })
    vim.keymap.set('n', '<leader>ts', ':Neotest summary<CR>', { desc = 'Open test summary' })
  end,
}
