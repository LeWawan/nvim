--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Remap C-c to <Esc>
vim.keymap.set('n', '<C-c>', '<Esc>')
vim.keymap.set('x', '<C-c>', '<Esc>')
vim.keymap.set('i', '<C-c>', '<Esc>')

-- Move around (keep the cursor center)
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'n', 'nzzzv')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- greatest remap ever (paste without override the registery)
vim.keymap.set('x', '<leader>p', '"_dP')

-- next greatest remap ever : asbjornHaland
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y', { noremap = false })

vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

vim.keymap.set('n', '<leader><CR>', ':so %<cr>')
vim.keymap.set('n', '<leader><leader>z', ':LspRestart<cr>')

-- move files lines around
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<C-p>', ':cprev<CR>')
vim.keymap.set('n', '<C-n>', ':cnext<CR>')

-- Sessionizer
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- Lsp
local toggle_qf = function()
  local qf_exists = false
  print(qf_exists)
  for _, win in pairs(vim.fn.getwininfo()) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd 'cclose'
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd ':copen'
  end
end
vim.keymap.set('n', '<C-q>', toggle_qf)

-- Undotree
vim.keymap.set('n', '<F5>', ':UndotreeToggle<CR>')
