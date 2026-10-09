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

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        "LazyVim",
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'v1.6.1', opts = {} },
    },
    config = function()
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

      local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
      local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      ---@type table<string, vim.lsp.Config>
      local servers = {
        lua_ls = {
          settings = { Lua = { completion = { callSnippet = 'Replace' } } },
        },
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  vue_plugin,
                },
              },
            },
          },
          filetypes = tsserver_filetypes,
        },
        vue_ls = {},
        oxlint = {},
        stylua = {},
        tailwindcss = {},
        emmet_language_server = {},
      }

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      -- installs every server above, then automatic_enable calls vim.lsp.enable() on them
      require('mason-lspconfig').setup { ensure_installed = vim.tbl_keys(servers) }
    end,
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      'folke/lazydev.nvim' ,
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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
    },
  },
}
