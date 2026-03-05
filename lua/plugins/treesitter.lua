return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'lua',
        'html',
        'css',
        'vue',
        'javascript',
        'typescript',
        'json',
        'bash',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  -- Commented to see if i prefer without it
  -- { 'nvim-treesitter/nvim-treesitter-context' },
}
