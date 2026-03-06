return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          trigger_on_accept = true,
          keymap = {
            accept = '<C-y>',
            accept_word = false,
            accept_line = false,
            next = '<C-]>',
            prev = '<C-[>',
          },
        },
      }
    end,
  },
  {
    'greggh/claude-code.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for git operations
    },
    opts = {
      window = {
        position = 'vertical',
      },
    },
  },
  -- {
  --   'supermaven-inc/supermaven-nvim',
  --   config = function()
  --     require('supermaven-nvim').setup {
  --       keymaps = {
  --         accept_suggestion = '<Tab>',
  --       },
  --     }
  --   end,
  -- },
}
