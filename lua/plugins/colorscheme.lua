return {
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'solarized-osaka'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    opts = {
      style = 'moon',
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
        variables = {},
        sidebars = 'dark',
        floats = 'dark',
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        theme = 'solarized-osaka',
        section_separators = '',
        component_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            'filename',
            path = 1,
            filetype_names = {
              TelescopePrompt = 'Telescope',
              dashboard = 'Dashboard',
              packer = 'Packer',
              fzf = 'FZF',
              alpha = 'Alpha',
            },
          },
        },
        lualine_x = {
          {
            function()
              return require('noice').api.statusline.mode.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.statusline.mode.has()
            end,
            color = { fg = '#ff9e64' },
          },
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = {
          'progress',
        },
        lualine_z = { 'location' },
      },
    },
  },
}
