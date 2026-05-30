local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")
require("config.autocmds")

require("theme").apply({
	bg = "#000000",
	fg = "#00ED8A",
	fg_sel = "#FFFFFF",
	fg_ina = "#404040",
})

require("lazy").setup({ { import = "plugins" } })
