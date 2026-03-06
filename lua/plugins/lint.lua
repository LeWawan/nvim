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
        formatters_by_ft = {
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          vue = { 'prettier' },
          lua = { 'stylua' },
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
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = 'fallback',
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
