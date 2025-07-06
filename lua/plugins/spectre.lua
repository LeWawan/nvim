return {
  'nvim-pack/nvim-spectre',
  event = 'VeryLazy',
  lazy = true,
  config = function()
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = 'Toggle Spectre',
    })
  end,
}
