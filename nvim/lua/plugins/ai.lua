return {
	{
		"nickjvandyke/opencode.nvim",
		version = "*",
		dependencies = {
			{ "folke/snacks.nvim", optional = true },
		},
		config = function()
			local cmd = "opencode --port"

			vim.g.opencode_opts = {
				server = {
					url = "http://localhost:4096",
					start = function()
						require("snacks.terminal").open(cmd, {
							win = {
								position = "right",
								width = 0.35,
								height = 1,
								border = "rounded",
								title = " OpenCode ",
								title_pos = "center",
							},
							on_open = function(term)
								require("opencode.terminal").setup(term)
							end,
						})
					end,
					stop = function()
						require("snacks.terminal")
							.get(cmd, {
								win = { position = "right" },
							})
							:close()
					end,
					toggle = function()
						require("snacks.terminal").toggle(cmd, {
							win = {
								position = "right",
								width = 0.35,
								height = 1,
								border = "rounded",
								title = " OpenCode ",
								title_pos = "center",
							},
							on_open = function(term)
								require("opencode.terminal").setup(term)
							end,
						})
					end,
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
		end,
	},
}
