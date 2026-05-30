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
	{
		"nickjvandyke/opencode.nvim",
		version = "*",
		dependencies = {
			{ "folke/snacks.nvim", optional = true },
		},
		config = function()
			vim.g.opencode_opts = {
				server = {
					url = "http://localhost:4096",
				},
			}

			vim.keymap.set({ "n", "x" }, "<C-a>", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask opencode" })

			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				require("opencode").select()
			end, { desc = "Select opencode" })

			vim.keymap.set({ "n", "t" }, "<C-.>", function()
				require("opencode").toggle()
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "go", function()
				return require("opencode").operator("@this ")
			end, { desc = "Add range to opencode", expr = true })

			vim.keymap.set("n", "goo", function()
				return require("opencode").operator("@this ") .. "_"
			end, { desc = "Add line to opencode", expr = true })

			vim.keymap.set("n", "<S-C-u>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "Scroll opencode up" })

			vim.keymap.set("n", "<S-C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "Scroll opencode down" })

			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
		end,
	},
}
