vim.g.mapleader = ' '

vim.g.have_nerd_font = true
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Remap C-c to <Esc>
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Escape' })

-- Move around (keep the cursor center)
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without overwriting register' })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set('n', '<leader><leader>', '<cmd>source %<CR>', { desc = 'Source current file' })

vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'Execute current line as Lua' })
vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'Execute selection as Lua' })

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

vim.keymap.set("n", "<leader>au", "<cmd>botright split | terminal arduino-cli compile --fqbn arduino:avr:mega . && arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:mega<CR>")
vim.keymap.set("n", "<leader>al", "<cmd>botright split | terminal arduino-cli monitor -p /dev/ttyACM0 -c baudrate=9600<cr>")
vim.keymap.set("n", "<leader>avl", "<cmd>botright vsplit | terminal arduino-cli monitor -p /dev/ttyACM0 -c baudrate=9600<cr>")
