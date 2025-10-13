return {
  'nvim-pack/nvim-spectre',
  event = 'VeryLazy',
  build = './build.sh',
  lazy = true,

  config = function()
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = 'Toggle Spectre',
    })

    require('spectre').setup {
      default = {
        replace = {
          cmd = 'oxi',
        },
      },
    }
  end,
}
