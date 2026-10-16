local function ColorMyPencils(color)
  color = color or 'tokyonight'

  vim.cmd('colorscheme ' ..color)

  -- transparent background
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Terminal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { bg = 'none' })

  -- transparent notify background
  vim.api.nvim_set_hl(0, 'NotifyINFOBody', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyERRORBody', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyWARNBody', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyTRACEBody', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyERRORBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyWARNBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyTRACEBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NotifyDEBUGBorder', { bg = 'none' })
end

return {
  {
    "serhez/teide.nvim",
    lazy = false,
    opts = {},
    config = function()
      ColorMyPencils()
    end
  },
  -- { 'craftzdog/solarized-osaka.nvim', lazy = false },
  -- { 'catppuccin/nvim', lazy = false },
  -- { 'rebelot/kanagawa.nvim', lazy = false },
  {
    'folke/tokyonight.nvim',
    lazy = false,
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
    config = function()
      require('lualine').setup {
        options = {
          theme = 'nightfly',
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            { 'filename', path = 1, }, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
}
