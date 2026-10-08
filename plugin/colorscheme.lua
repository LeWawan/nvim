local wh = require('thewawan.helpers')

local colorscheme = 'teide'

-- Main theme

vim.pack.add({
  wh.gh('serhez/teide.nvim'),
})


local function ColorMyPencils(_colorscheme)
  vim.cmd ('colorscheme ' .. _colorscheme)

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

-- Status Line
--
vim.pack.add({
  wh.gh('nvim-lualine/lualine.nvim')
})

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
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
    },
    lualine_y = {
      'progress',
    },
    lualine_z = { 'location' },
  },
}


ColorMyPencils(colorscheme)
