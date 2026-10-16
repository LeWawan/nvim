return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional but recommended
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    keys = {
      {
        '<leader>fp',
        function()
          require('telescope.builtin').git_files()
        end,
        desc = 'Telescope: git files',
      },
      {
        '<leader>ff',
        function()
          require('telescope.builtin').find_files { hidden = true }
        end,
        desc = 'Telescope: Find files',
      },
      {
        '<leader>fg',
        function()
          require('telescope.builtin').live_grep { hidden = true }
        end,
        desc = 'Telescope: Live grep',
      },
      {
        '<leader>fc',
        function()
          require('telescope.builtin').live_grep { default_text = 'class="[^"]*<cursor>[^"]*"' }
        end,
        desc = 'Telescope: Grep CSS classes',
      },
      {
        '<leader>ft',
        function()
          require('telescope.builtin').treesitter()
        end,
        desc = 'Telescope: Treesitter symbols',
      },
      {
        '<leader>fb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'Telescope: Buffers',
      },
      {
        '<leader>fh',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = 'Telescope: Help tags',
      },
      {
        "<leader>'",
        function()
          require('telescope.builtin').git_files {
            prompt_title = '< VimRC >',
            cwd = '~/.dotfiles/nvim/.config/nvim',
            hidden = false,
          }
        end,
        desc = 'Telescope: Neovim config files',
      },
      {
        '<leader>fw',
        function()
          require('telescope.pickers')
            .new({
              prompt_title = 'Git Worktrees',
              finder = require('telescope.finders').new_table {
                results = vim.fn.systemlist 'git worktree list --porcelain | grep -E "worktree|HEAD" | awk \'{print $2}\'',
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
                    vim.cmd 'edit .'
                  end
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Telescope: Git worktrees',
      },
    },
  },
}
