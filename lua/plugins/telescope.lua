return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    enabled = false,
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()

      -- Enable Telescope extensions if they are installed

      -- Keymaps
      -- vim.keymap.set('n', '<leader>fp', function()
      --   telescope.git_files()
      -- end)
      -- vim.keymap.set('n', '<leader>ff', function()
      --   telescope.find_files { hidden = true }
      -- end)
      -- vim.keymap.set('n', '<leader>fg', function()
      --   telescope.live_grep { hidden = true }
      -- end)
      -- vim.keymap.set('n', '<leader>fc', function()
      --   require('telescope.builtin').live_grep {
      --     default_text = 'class="[^"]*<cursor>[^"]*"',
      --   }
      -- end)
      -- vim.keymap.set('n', '<leader>fr', function()
      --   telescope.lsp_references()
      -- end)
      -- vim.keymap.set('n', '<leader>ft', function()
      --   telescope.treesitter()
      -- end)
      -- vim.keymap.set('n', '<leader>fb', function()
      --   telescope.buffers()
      -- end)
      -- vim.keymap.set('n', '<leader>fh', function()
      --   telescope.help_tags()
      -- end)
      -- vim.keymap.set('n', '<leader>gb', function()
      --   telescope.git_branches {
      --     -- show_remote_tracking_branches = false,
      --   }
      -- end)
      -- vim.keymap.set('n', "<leader>'", function()
      --   telescope.git_files { prompt_title = '< VimRC >', cwd = '~/.dotfiles/nvim/.config/nvim', hidden = false }
      -- end)
      -- vim.keymap.set('n', '<leader>vh', function()
      --   telescope.help_tags()
      -- end)
      --
      -- -- Lsp keymaps
      -- vim.keymap.set('n', '<leader>gd', function()
      --   telescope.lsp_definitions()
      -- end)
      -- vim.keymap.set('n', '<leader>gi', function()
      --   telescope.lsp_implementations()
      -- end)
      -- vim.keymap.set('n', '<leader>gr', function()
      --   telescope.lsp_references()
      -- end)
      --
      -- vim.keymap.set('n', '<leader>ww', function()
      --   require 'obsidian'
      --   vim.cmd ':ObsidianSearch'
      -- end)
      --
      -- vim.keymap.set('n', '<leader>ws', function()
      --   require 'obsidian'
      --   vim.cmd ':ObsidianTags'
      -- end)
      --
      -- vim.keymap.set('n', '<leader>wt', function()
      --   require 'obsidian'
      --   vim.cmd ':ObsidianToday'
      -- end)
    end,
  },
}
