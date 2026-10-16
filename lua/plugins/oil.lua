return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = { 'icon' },
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { '=', '<CMD>Oil<CR>', desc = 'Open parent directory' },
      { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    },
  },
}
