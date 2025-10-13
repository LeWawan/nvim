return {
  -- {
  --   'craftzdog/solarized-osaka.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'solarized-osaka'
  --   end,
  -- },

  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd [[colorscheme catppuccin]]
  --   end,
  -- },
  --
  {
    'rebelot/kanagawa.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('kanagawa').setup {
        transparent = true, -- do not set background color
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme

          local makeDiagnosticColor = function(color)
            local c = require 'kanagawa.lib.color'
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
          end

          return {
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            FloatTitle = { bg = 'none' },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            FzfLuaNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            CmdLineNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

            DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
            DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
            DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
            DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
          }
        end,
      }

      -- setup must be called before loading
      vim.cmd 'colorscheme kanagawa'
    end,
  },

  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('tokyonight').setup {
  --       style = 'moon', -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  --       light_style = 'day', -- The theme is used when the background is set to light
  --       transparent = true, -- Enable this to disable setting the background color
  --       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  --       styles = {
  --         -- Style to be applied to different syntax groups
  --         -- Value is any valid attr-list value for `:help nvim_set_hl`
  --         comments = { italic = true },
  --         keywords = { italic = true },
  --         functions = { italic = true },
  --         variables = {},
  --         -- Background styles. Can be "dark", "transparent" or "normal"
  --         sidebars = 'dark', -- style for sidebars, see below
  --         floats = 'dark', -- style for floating windows
  --       },
  --       day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  --       dim_inactive = false, -- dims inactive windows
  --       lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
  --     }
  --
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'
  --   end,
  -- },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('lualine').setup {
        options = {
          theme = 'jellybeans',
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            {
              'filename',
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
              filetype_names = {
                TelescopePrompt = 'Telescope',
                dashboard = 'Dashboard',
                packer = 'Packer',
                fzf = 'FZF',
                alpha = 'Alpha',
              },
            },
          },
          lualine_w = {
            {
              require('noice').api.statusline.mode.get,
              cond = require('noice').api.statusline.mode.has,
              color = { fg = '#ff9e64' },
            },
          },
        },
        lualine_x = {
          'encoding',
          'fileformat',
          'filetype',
          lualine_y = {
            'progress',
          },
          lualine_z = { 'location' },
        },
      }
    end,
  },
}
