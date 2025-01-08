local M = {}

M.shell_call = function(args)
	local output = vim.fn.system(args)
	assert(vim.v.shell_error == 0, "External call failed with error code: " .. vim.v.shell_error .. output)
end

M.echo = function(str)
	vim.cmd "redraw"
	vim.api.nvim_echo({{ str, "Bold" }}, true, {})
end

M.check_package = function(pkg)
	local check = vim.fn.system("command -v " .. pkg)
	return check ~= ""
end

M.install_packages = function(args)
	for _, command in ipairs(args) do
		M.shell_call(command)
	end
end

M.load_plugins = function()
	local path = vim.fn.stdpath "config" .. "/lua/plugins"
	local ref_str = vim.fn.glob(path .. "/*.lua")
	
	local files = {}
	for file in ref_str:gmatch("[^%s]+") do
		table.insert(files, file)
	end

	local plugins = {}
	for _, file in ipairs(files) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		if name then
			local plug = require("plugins." .. name)
			table.insert(plugins, plug)
		end
	end

	return plugins
end

return M
