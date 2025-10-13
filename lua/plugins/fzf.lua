return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  config = function()
    local fzf = require 'fzf-lua'

    vim.keymap.set('n', '<leader>fp', function()
      fzf.git_files()
    end)

    vim.keymap.set('n', '<leader>ff', function()
      fzf.files()
    end)

    vim.keymap.set('n', '<leader>fg', function()
      fzf.live_grep()
    end)

    vim.keymap.set('n', '<leader>fb', function()
      fzf.buffers {
        prompt = 'Buffers❯ ',
      }
    end)

    vim.keymap.set('n', '<leader>gb', function()
      fzf.git_branches()
    end)

    vim.keymap.set('n', "<leader>'", function()
      fzf.files { prompt = '< VimRC >', cwd = '~/.dotfiles/nvim/.config/nvim', hidden = false }
    end)

    vim.keymap.set('n', '<leader>ww', function()
      require 'obsidian'
      vim.cmd ':ObsidianSearch'
    end)

    vim.keymap.set('n', '<leader>ws', function()
      require 'obsidian'
      vim.cmd ':ObsidianTags'
    end)

    vim.keymap.set('n', '<leader>wt', function()
      require 'obsidian'
      vim.cmd ':ObsidianToday'
    end)

    require('fzf-lua').setup {
      keymap = {
        builtin = {
          true,
          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
        },
        fzf = {
          true,
          ['ctrl-d'] = 'preview-page-down',
          ['ctrl-u'] = 'preview-page-up',
          ['ctrl-q'] = 'select-all+accept',
        },
      },
      winopts = {
        border = 'none',
        preview = {
          border = 'none',
        },
      },
    }
  end,
}
