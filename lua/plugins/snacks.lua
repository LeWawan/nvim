return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = false },
      dashboard = {
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
          { section = 'startup' },
          {
            section = 'terminal',
            cmd = 'ascii-image-converter ~/.dotfiles/wall.png -C -c',
            random = 10,
            pane = 2,
            indent = 4,
            height = 30,
          },
        },
      },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      styles = {},
      words = { enabled = false },
    },
    keys = {
      {
        '<leader>n',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notification History',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        '<leader>N',
        desc = 'Neovim News',
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = 'yes',
              statuscolumn = ' ',
              conceallevel = 3,
            },
          }
        end,
      },
    },
  },
}
