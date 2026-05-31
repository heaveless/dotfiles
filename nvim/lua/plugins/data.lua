return {
	{
		"3rd/image.nvim",
		build = false,
		config = function()
			require("image").setup({
				backend = "kitty",
				processor = "magick_cli",
				window_overlap_clear_enabled = true,
				max_width_window_percentage = 100,
				max_height_window_percentage = 90,
				scale_factor = 1.0,
				integrations = {
					markdown = { enabled = true, only_render_image_at_cursor = true },
					neorg = { enabled = true },
					html = { enabled = true },
				},
			})
		end,
	},
	{
		"benlubas/molten-nvim",
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_image_location = "both"
			vim.g.molten_auto_open_output = false
			vim.g.molten_output_win_style = "minimal"
			vim.g.molten_output_win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
			vim.g.molten_output_win_cover_gutter = true
			vim.g.molten_use_border_highlights = true
			vim.g.molten_output_virt_lines = true
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_text_max_lines = 50
			vim.g.molten_wrap_output = true
			vim.g.molten_cover_empty_lines = true
		end,
		config = function()
			local function get_chunk_range()
				local buf = vim.api.nvim_get_current_buf()
				local ts = pcall(require, "vim.treesitter")
				if ts then
					local parser = vim.treesitter.get_parser(buf, "markdown")
					if parser then
						local tree = parser:parse()[1]
						local root = tree:root()
						local cursor = root:named_descendant_for_range(
							vim.fn.line(".") - 1, 0,
							vim.fn.line(".") - 1, 0
						)
						while cursor do
							if cursor:type() == "fenced_code_block" then
								local srow = cursor:start()
								local erow = cursor:end_()
								return srow + 2, erow - 1
							end
							cursor = cursor:parent()
						end
					end
				end
				local start = vim.fn.search("^```\\|^# %%\\|^\\%^", "bnW")
				local finish = vim.fn.search("^```\\|^# %%\\|^\\%$", "nW")
				return start == 0 and 1 or start, finish == 0 and vim.fn.line("$") or finish
			end

			local function evaluate_chunk()
				local s, e = get_chunk_range()
				vim.fn.MoltenEvaluateRange(s, e)
			end

			vim.keymap.set("n", "<leader>r", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "Molten evaluate" })
			vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Molten run line" })
			vim.keymap.set("n", "<leader>rc", evaluate_chunk, { desc = "Molten run chunk" })
			local function evaluate_all()
				local kernels = vim.fn.MoltenRunningKernels(true)
				if type(kernels) ~= "table" or #kernels == 0 then
					vim.notify("Run :MoltenInit python3 first", vim.log.levels.WARN)
					return
				end
				local lines = vim.fn.line("$")
				local start = 1
				local in_yaml = false
				for i = 1, lines do
					local content = vim.fn.getline(i)
					if content:match("^%-%-%-%s*$") then
						if not in_yaml then
							in_yaml = true
						else
							in_yaml = false
							start = i + 1
						end
					end
				end
				local buf = vim.api.nvim_get_current_buf()
				local ts = pcall(require, "vim.treesitter")
				local chunks = {}
				if ts then
					local parser = vim.treesitter.get_parser(buf, "markdown")
					if parser then
						local tree = parser:parse()[1]
						local query = vim.treesitter.query.parse("markdown", "(fenced_code_block) @cb")
						for _, node in query:iter_captures(tree:root(), buf, 0) do
							local srow = node:start()
							local erow = node:end_()
							local first_line = vim.fn.getline(srow + 1)
							if first_line and first_line:match("{python}") then
								table.insert(chunks, { s = srow + 2, e = erow - 1 })
							end
						end
					end
				end
				if #chunks > 0 then
					for _, chunk in ipairs(chunks) do
						vim.fn.MoltenEvaluateRange(chunk.s, chunk.e)
					end
				else
					vim.fn.MoltenEvaluateRange(math.max(start, 1), lines)
				end
			end

			vim.keymap.set("n", "<leader>ra", evaluate_all, { desc = "Molten run all" })
			vim.keymap.set("n", "<leader>rr", ":MoltenRestart<CR>", { silent = true, desc = "Molten restart kernel" })
			vim.keymap.set("n", "<leader>ro", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "Molten open output" })
			vim.keymap.set("n", "<leader>rn", ":MoltenNext<CR>", { silent = true, desc = "Molten next cell" })
			vim.keymap.set("n", "<leader>rp", ":MoltenPrev<CR>", { silent = true, desc = "Molten prev cell" })
			vim.keymap.set("n", "<leader>rx", ":MoltenDelete<CR>", { silent = true, desc = "Molten clear output" })
			vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Molten evaluate selection" })
		end,
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown" },
		init = function()
			vim.g.table_mode_corner = "|"
		end,
	},
}
