--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Remap C-c to <Esc>
vim.keymap.set('n', '<C-c>', '<Esc>', { desc = 'Escape' })
vim.keymap.set('x', '<C-c>', '<Esc>', { desc = 'Escape' })
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Escape' })

-- Move around (keep the cursor center)
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- greatest remap ever (paste without override the registery)
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without overwriting register' })

-- next greatest remap ever : asbjornHaland
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { noremap = false, desc = 'Yank line to system clipboard' })

vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Delete to void register' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'Delete to void register' })

vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<leader><leader>h', function()
  local file = vim.api.nvim_buf_get_name(0)
  -- filename without path or extension
  local filename = file:match("^.+/(.+)%.%w+$")

  vim.cmd('Lazy reload ' .. filename)
end, { desc = 'Lazy reload current plugin' })

vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'Execute current line as Lua' })
vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'Execute selection as Lua' })

vim.keymap.set('n', '<leader><leader>z', ':LspRestart<cr>', { desc = 'Restart LSP' })

-- move files lines around
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

vim.keymap.set('n', '<C-p>', ':cprev<CR>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', '<C-n>', ':cnext<CR>', { desc = 'Next quickfix item' })

-- Sessionizer
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = 'Open tmux sessionizer' })

-- Lsp
local toggle_qf = function()
  local qf_exists = false
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
vim.keymap.set('n', '<C-q>', toggle_qf, { desc = 'Toggle quickfix list' })

-- Undotree
vim.keymap.set('n', '<F5>', ':UndotreeToggle<CR>', { desc = 'Toggle Undotree' })
