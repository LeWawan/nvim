return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      {
        'j-hui/fidget.nvim',
        tag = 'v1.6.1',
        opts = {},
      },

      'saghen/blink.cmp',

      'tpope/vim-rails', -- Essential pour Rails
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>gr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')
          map('<leader>gi', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>gd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')
          map('<leader>gD', require('fzf-lua').lsp_declarations, '[G]oto [D]efinition')
          map('<leader>O', require('fzf-lua').lsp_document_symbols, 'Open Document Symbols')
          map('<leader>gt', require('fzf-lua').lsp_typedefs, '[G]oto [T]ype Definition')
          map('[d', function()
            return vim.diagnostic.jump { count = 1, float = true }
          end, '[D]iagnostic [P]revious')
          map(']d', function()
            return vim.diagnostic.jump { count = -1, float = true }
          end, '[D]iagnostic [N]ext')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, sinc they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      ---@type table<string, vim.lsp.Config>
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = '@vue/typescript-plugin',
                    location = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server',
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                  },
                },
              },
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        },
        vue_ls = {
          init_options = {
            typescript = {
              tsdk = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/typescript/lib',
            },
          },
          on_init = function(client)
            client.handlers['tsserver/request'] = function(_, result, context)
              local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
              if #clients == 0 then
                vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = 'typescript.tsserverRequest',
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, r)
                local response_data = { { id, r.body } }
                ---@diagnostic disable-next-line: param-type-mismatch
                client:notify('tsserver/response', response_data)
              end)
            end
          end,
        },
        oxlint = {
          cmd = { 'oxc_language_server' },
          filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' },
        },
        -- solargraph = {
        --   settings = {
        --     solargraph = {
        --       diagnostics = true,
        --       completion = true,
        --       hover = true,
        --       formatting = false, -- Tu utilises conform.nvim
        --       symbols = true,
        --       definitions = true,
        --       references = true,
        --       folding = true,
        --       bundlerPath = 'bundle',
        --       commandPath = 'solargraph',
        --       useBundler = true, -- Important pour Rails
        --     },
        --   },
        -- },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Configuration Mason-lspconfig basique
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers or {}),
        automatic_enable = true,
      }

      -- Obtenir les mappages entre paquets Mason et serveurs LSP
      local mappings = require('mason-lspconfig.mappings').get_mason_map()
      local registry = require 'mason-registry'

      -- Fonction pour configurer un serveur en fusionnant configuration par défaut et personnalisée
      local function setup_server(server_name)
        -- Obtenir la configuration par défaut de mason-lspconfig (si disponible)
        local ok, default_config = pcall(require, ('mason-lspconfig.lsp.%s'):format(server_name))
        local config = ok and default_config or {}

        -- Fusionner avec la configuration personnalisée
        if servers[server_name] then
          config = vim.tbl_deep_extend('force', config, servers[server_name])
        end

        -- Fusionner avec les capacités
        config.capabilities = vim.tbl_deep_extend('force', capabilities or {}, config.capabilities or {})

        -- Configurer et activer le serveur
        vim.lsp.config(server_name, config)
        vim.lsp.enable(server_name)
      end

      -- Configurer les serveurs déjà installés
      for _, pkg_name in ipairs(registry.get_installed_package_names()) do
        local server_name = mappings.package_to_lspconfig[pkg_name]
        if server_name then
          setup_server(server_name)
        end
      end

      vim.lsp.config('sourcekit', {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
        settings = {
          sourcekit = {
            -- Spécifiez le SDK iOS/macOS
            sdk = vim.fn.system('xcrun --show-sdk-path --sdk iphoneos'):gsub('\n', ''),
            -- ou pour macOS :
            -- sdk = vim.fn.system("xcrun --show-sdk-path --sdk macosx"):gsub('\n', ''),
          },
        },
        -- Configuration des arguments
        cmd = {
          'sourcekit-lsp',
          '--configuration',
          'debug', -- ou 'release'
        },
      })
      vim.lsp.enable 'sourcekit'

      -- Configurer les nouveaux serveurs lors de leur installation
      registry:on(
        'package:install:success',
        vim.schedule_wrap(function(pkg)
          local server_name = mappings.package_to_lspconfig[pkg.name]
          if server_name then
            setup_server(server_name)
          end
        end)
      )
    end,
  },

  { -- Autoformat
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
    opts = {
      notify_on_error = false,
      format_on_save = {
        lsp_format = 'fallback',
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust' },
      signature = { enabled = true },
    },
  },
}
