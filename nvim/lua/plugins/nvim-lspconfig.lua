local utils = require("utils")

local M = {
	"neovim/nvim-lspconfig"
}

-- :help lspconfig-all

M.config = function(_, opts)
	local lsp = require('lspconfig')
	
	if utils.check_package("node") and utils.check_package("npm") then
		if not utils.check_package("ts-node") then
			utils.install_packages({
				"npm i -g typescript",
				"npm i -g ts-node",
				"npm i -g typescript-language-server",
				"npm i -g vls",
				"npm i -g @astrojs/language-server",
			})
		end

		lsp.ts_ls.setup({})
		lsp.vls.setup({})
		lsp.astro.setup({})
	end
end

return M
