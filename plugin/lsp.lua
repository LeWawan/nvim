local wh = require('thewawan.helpers')

local function highlight_under_cursor(event)
  local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    buffer = event.buf,
    group = group,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    buffer = event.buf,
    group = group,
    callback = vim.lsp.buf.clear_references,
  })
  vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
    callback = function(event2)
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
    end,
  })
end

vim.pack.add({
  wh.gh('folke/lazydev.nvim')
})

local lazydev = require('lazydev')

lazydev.setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    "LazyVim",
  },
})

vim.pack.add({
  wh.gh('neovim/nvim-lspconfig'),

  -- deps
  wh.gh('mason-org/mason.nvim'),
  { src = wh.gh('j-hui/fidget.nvim'), version = 'v1.6.1'}
})

require('fidget').setup{}

require('mason').setup{}

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config('*', {
  capabilities = capabilities
})

vim.lsp.config('lua_ls', {
  settings = { Lua = { completion = { callSnippet = 'Replace' } } },
})

vim.lsp.enable({
  'lua_ls'
})


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local builtin = require 'telescope.builtin'

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>gr', builtin.lsp_references, '[G]oto [R]eferences')
    map('<leader>gi', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>gd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('<leader>O', builtin.lsp_document_symbols, 'Open Document Symbols')
    map('<leader>gt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if client:supports_method('textDocument/documentHighlight', event.buf) then
      highlight_under_cursor(event)
    end
  end,
})

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  virtual_text = { source = 'if_many', spacing = 2 },
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}


vim.pack.add({
  { src = wh.gh('saghen/blink.cmp'), version = vim.version.range('1.0') },
})

local blink = require('blink.cmp')

blink.setup({
  keymap = { preset = 'enter' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  fuzzy = { implementation = 'prefer_rust' },
  signature = { enabled = true },
})
