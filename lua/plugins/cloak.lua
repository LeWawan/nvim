return {
  {
    'laytan/cloak.nvim',
    event = { 'BufRead', 'BufNewFile' },
    opts = {},
    keys = {
      {
        '<leader>xx',
        function()
          require('cloak').toggle()
        end,
        desc = 'Toggle cloak (hide secrets)',
      },
    },
  },
}
