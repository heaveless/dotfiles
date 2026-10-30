local parsers = {
	"bash",
	"css",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

local function install_missing(treesitter)
	local installed = treesitter.get_installed()
	local missing = vim.tbl_filter(function(parser)
		return not vim.tbl_contains(installed, parser)
	end, parsers)

	if #missing > 0 then
		treesitter.install(missing)
	end
end

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		install_missing(treesitter)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
			callback = function(ev)
				pcall(vim.treesitter.start, ev.buf)
			end,
		})
	end,
}
