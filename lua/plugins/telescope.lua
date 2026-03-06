return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional but recommended
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    config = function()
      local telescope = require 'telescope.builtin'
      -- Enable Telescope extensions if they are installed

      -- Keymaps
      vim.keymap.set('n', '<leader>fp', function()
        telescope.git_files()
      end)
      vim.keymap.set('n', '<leader>ff', function()
        telescope.find_files { hidden = true }
      end)
      vim.keymap.set('n', '<leader>fg', function()
        telescope.live_grep { hidden = true }
      end)
      vim.keymap.set('n', '<leader>fc', function()
        require('telescope.builtin').live_grep {
          default_text = 'class="[^"]*<cursor>[^"]*"',
        }
      end)
      vim.keymap.set('n', '<leader>ft', function()
        telescope.treesitter()
      end)
      vim.keymap.set('n', '<leader>fb', function()
        telescope.buffers()
      end)
      vim.keymap.set('n', '<leader>fh', function()
        telescope.help_tags()
      end)
      vim.keymap.set('n', "<leader>'", function()
        telescope.git_files { prompt_title = '< VimRC >', cwd = '~/.dotfiles/nvim/.config/nvim', hidden = false }
      end)
    end,
  },
}
