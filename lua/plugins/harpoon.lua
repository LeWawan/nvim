return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup({
        terminals = {
          add = function()
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
            print(vim.inspect(list_item))

            vim.api.nvim_set_current_buf(list_item.context.bufnr)
          end

        }
      })


      local default_list = harpoon:list('default')
      local term_list = harpoon:list('terminals')


      -- default_list:clear()
      -- term_list:clear()

      vim.keymap.set('n', '<leader>e', function() default_list:add() end)
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(default_list) end)

      vim.keymap.set('n', '<leader>r', function() term_list:add() end)
      vim.keymap.set('n', '<C-r>', function() harpoon.ui:toggle_quick_menu(term_list) end)

      vim.keymap.set('n', '<C-h>', function() default_list:select(1) end)
      vim.keymap.set('n', '<C-j>', function() default_list:select(2) end)
      vim.keymap.set('n', '<C-k>', function() default_list:select(3) end)
      vim.keymap.set('n', '<C-l>', function() default_list:select(4) end)

      local function goto_terminal(idx)
        print('goto_terminal', idx)

        local term = term_list:get(idx)
        print('term', term)

        if term == nil then
          term_list:add()
          return
        end

        term_list:select(idx)
      end

      vim.keymap.set('n', '<leader>th', function() term_list:select(1) end)
      vim.keymap.set('n', '<leader>tj', function() term_list:select(2) end)
      vim.keymap.set('n', '<leader>tk', function() term_list:select(3) end)
      vim.keymap.set('n', '<leader>tl', function() term_list:select(4) end)
    end,
  },
}
