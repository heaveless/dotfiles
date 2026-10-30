local chunks = require("molten.chunks")
local kernels = require("molten.kernels")

local M = {}

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

local function evaluate_chunk()
	local first, last = chunks.current()
	vim.fn.MoltenEvaluateRange(first, last)
end

local function evaluate_all()
	if not kernels.has_running() then
		vim.notify("Run :MoltenInit python3 first", vim.log.levels.WARN)
		return
	end

	for _, chunk in ipairs(chunks.all()) do
		vim.fn.MoltenEvaluateRange(chunk.first, chunk.last)
	end
end

function M.setup()
	map("n", "<leader>r", ":MoltenEvaluateOperator<CR>", "Molten evaluate")
	map("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", "Molten evaluate selection")
	map("n", "<leader>rl", ":MoltenEvaluateLine<CR>", "Molten run line")
	map("n", "<leader>rc", evaluate_chunk, "Molten run chunk")
	map("n", "<leader>ra", evaluate_all, "Molten run all")
	map("n", "<leader>rr", ":MoltenRestart<CR>", "Molten restart kernel")
	map("n", "<leader>rn", ":MoltenNext<CR>", "Molten next cell")
	map("n", "<leader>rp", ":MoltenPrev<CR>", "Molten prev cell")
	map("n", "<leader>ro", ":noautocmd MoltenEnterOutput<CR>", "Molten open output")
	map("n", "<leader>rx", ":MoltenDelete<CR>", "Molten clear output")
end

return M
