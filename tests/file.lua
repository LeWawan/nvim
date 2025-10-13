vim.api.nvim_create_user_command('Test', function()
  print 'Hello World!!!'
end, {})

print 'Hello World!!!'
