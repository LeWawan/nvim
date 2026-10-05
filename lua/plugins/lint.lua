return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    config = function()
      require('conform').setup {
        format_on_save = {
          timeout_ms = 5000,
          lsp_format = 'fallback',
        },
        formatters_by_ft = {
          javascript = { 'oxfmt', 'prettier' },
          typescript = { 'oxfmt', 'prettier' },
          vue = { 'oxfmt', 'prettier' },
          lua = { 'oxfmt', 'stylua' },
        },
        formatters = {
          rubocop = {
            timeout_ms = 10000, -- 10 seconds
          },
          prettier = {
            prepend_args = { '--print-width', '120' },
          },
          stylua = {
            prepend_args = { '--print-width', '120' },
          },
        },
      }
    end,
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
