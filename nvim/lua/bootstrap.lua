local utils = require("utils")

local M = {}

M.install = function()
	utils.echo "Installing lazy.nvim..."

	local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(lazypath) then
		local repo = "https://github.com/folke/lazy.nvim.git"
		utils.shell_call { "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath }
	end

	vim.opt.rtp:prepend(lazypath)
end

M.init = function()
	utils.echo "Initialize plugins..."

	local plugins = utils.load_plugins()
	require("lazy").setup(plugins)

	utils.echo "Loaded correctly."
end

return M
