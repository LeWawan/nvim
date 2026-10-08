local wh = require('thewawan.helpers')

vim.pack.add({
  { src = wh.gh('ThePrimeagen/harpoon'), version = 'harpoon2' },
   wh.gh('nvim-lua/plenary.nvim')
})

local harpoon = require 'harpoon'

harpoon:setup({
  ai = {
    select = function(list_item)
      vim.api.nvim_set_current_buf(list_item.context.bufnr)
    end

  },
  terminals = {
    create_list_item = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      return {
        value = bufname,
        context = {
          bufnr = bufnr,
        }
      }
    end,


    select = function(list_item)
      vim.api.nvim_set_current_buf(list_item.context.bufnr)
    end

  }
})

local default_list = harpoon:list('default')
local term_list = harpoon:list('terminals')

vim.keymap.set('n', '<leader>e', function() default_list:add() end, { desc = 'Harpoon: Add file' })
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(default_list) end, { desc = 'Harpoon: Toggle quick menu' })
vim.keymap.set('n', '<C-h>', function() default_list:select(1) end, { desc = 'Harpoon: Go to file 1' })
vim.keymap.set('n', '<C-j>', function() default_list:select(2) end, { desc = 'Harpoon: Go to file 2' })
vim.keymap.set('n', '<C-k>', function() default_list:select(3) end, { desc = 'Harpoon: Go to file 3' })
vim.keymap.set('n', '<C-l>', function() default_list:select(4) end, { desc = 'Harpoon: Go to file 4' })

local create_new_terminal_buffer = function()
  vim.cmd('terminal')
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  return {
    value = bufname,
    context = {
      bufnr = bufnr,
    }
  }
end

local function goto_terminal(idx)
  local list_item = term_list:get(idx)

  if list_item and vim.api.nvim_buf_is_valid(list_item.context.bufnr) then
    term_list:select(idx)
    return
  end

  local item = create_new_terminal_buffer()

  if list_item and not vim.api.nvim_buf_is_valid(list_item.context.bufnr) then
    term_list:replace_at(idx, item)
  else
    term_list:add(item)
  end
end


vim.keymap.set('n', '<leader>th', function() goto_terminal(1) end, { desc = 'Harpoon: Go to terminal 1' })
vim.keymap.set('n', '<leader>tj', function() goto_terminal(2) end, { desc = 'Harpoon: Go to terminal 2' })
vim.keymap.set('n', '<leader>tk', function() goto_terminal(3) end, { desc = 'Harpoon: Go to terminal 3' })
vim.keymap.set('n', '<leader>tl', function() goto_terminal(4) end, { desc = 'Harpoon: Go to terminal 4' })


vim.api.nvim_create_autocmd({'ExitPre'}, {
  group = vim.api.nvim_create_augroup('harpoon', { clear = true }),
  pattern = '*',
  callback = function()
    term_list:clear()
  end
})
