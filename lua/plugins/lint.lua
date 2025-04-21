return {
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup {
        formatters_by_ft = {
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          vue = { 'prettier' },
          lua = { 'stylua' },
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = 'fallback',
        },
      }

      require('ts-error-translator').setup {}
    end,
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    config = function()
      vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx)
        require('ts-error-translator').translate_diagnostics(err, result, ctx)
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
      end
    end,
  },
}
