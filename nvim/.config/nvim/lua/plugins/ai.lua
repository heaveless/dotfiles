return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "CodeCompanionChat", "CodeCompanionChatVisual" },
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = require("codecompanion.adapters").extend("openai_compatible", {
							name = "deepseek",
							env = {
								api_key = "DEEPSEEK_API_KEY",
								url = "https://api.deepseek.com",
							},
							schema = {
								model = { default = "deepseek-v4-pro" },
								parameters = { max_tokens = 512, temperature = 0.3 },
							},
						}),
					},
				},
			})
		end,
	},
	{
		"0xble/dotagent.nvim",
		cmd = { "DotAgent", "DotAgentVisual" },
		config = function()
			require("dotagent").setup({
				sources = {
					{
						type = "skills",
						path = vim.fn.expand("~/.agents/skills"),
					},
				},
				llm = {
					provider = "openai",
					model = "deepseek-chat",
					api_key = os.getenv("DEEPSEEK_API_KEY"),
					base_url = "https://api.deepseek.com/v1",
				},
			})
		end,
	},
	{
		"ravitemer/mcphub.nvim",
		cmd = { "MCPHub", "MCPStart", "MCPStop", "MCPStatus" },
		config = function()
			local config_path = vim.fn.expand("~/.config/nvim/mcpservers.json")
			require("mcphub").setup({
				port = 3000,
				config = config_path,
				auto_approve = false,
			})
		end,
	},
}
