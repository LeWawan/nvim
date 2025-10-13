return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
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
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = 'fallback',
        },
      }
    end,
  },
}
