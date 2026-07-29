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
      local picker = require 'telescope.pickers'
      -- Enable Telescope extensions if they are installed

      -- Keymaps
      vim.keymap.set('n', '<leader>fp', function()
        telescope.git_files()
      end, { desc = 'Telescope: Git files' })
      vim.keymap.set('n', '<leader>fw', function()
        picker.new({
          prompt_title = 'Git Worktrees',
          finder = require('telescope.finders').new_table {
            results = vim.fn.systemlist('git worktree list --porcelain | grep -E "worktree|HEAD" | awk \'{print $2}\''),
          },
          sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
        }, {
          attach_mappings = function(_, map)
            map('i', '<CR>', function(prompt_bufnr)
              local selection = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
              if selection then
                local worktree_path = selection[1]
                require('telescope.actions').close(prompt_bufnr)
                vim.cmd('cd ' .. worktree_path)
                vim.cmd('edit .')
              end
            end)
            return true
          end,
        }):find()
        -- git worktree selection support
      end, { desc = 'Telescope: Git worktrees' })
      vim.keymap.set('n', '<leader>ff', function()
        telescope.find_files { hidden = true }
      end, { desc = 'Telescope: Find files' })
      vim.keymap.set('n', '<leader>fg', function()
        telescope.live_grep { hidden = true }
      end, { desc = 'Telescope: Live grep' })
      vim.keymap.set('n', '<leader>fc', function()
        require('telescope.builtin').live_grep {
          default_text = 'class="[^"]*<cursor>[^"]*"',
        }
      end, { desc = 'Telescope: Grep CSS classes' })
      vim.keymap.set('n', '<leader>ft', function()
        telescope.treesitter()
      end, { desc = 'Telescope: Treesitter symbols' })
      vim.keymap.set('n', '<leader>fb', function()
        telescope.buffers()
      end, { desc = 'Telescope: Buffers' })
      vim.keymap.set('n', '<leader>fh', function()
        telescope.help_tags()
      end, { desc = 'Telescope: Help tags' })
      vim.keymap.set('n', "<leader>'", function()
        telescope.git_files { prompt_title = '< VimRC >', cwd = '~/.dotfiles/nvim/.config/nvim', hidden = false }
      end, { desc = 'Telescope: Neovim config files' })
    end,
  },
}
