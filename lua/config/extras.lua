vim.api.nvim_create_user_command("MemoryUsage", function()
	local mem = collectgarbage("count")
	print(string.format("Memory usage: %.2f MB", mem / 1024))
end, {})
