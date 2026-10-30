local M = {}

local function root()
	local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
	if not ok or not parser then
		return nil
	end

	return parser:parse()[1]:root()
end

local function range(node)
	local first = node:start()
	local last = node:end_()

	return first + 2, math.max(last - 1, first + 1)
end

local function block_at(node)
	while node do
		if node:type() == "fenced_code_block" then
			return range(node)
		end

		node = node:parent()
	end
end

local function fallback()
	local first = vim.fn.search("^```\\|^# %%\\|^\\%^", "bnW")
	local last = vim.fn.search("^```\\|^# %%\\|^\\%$", "nW")

	return first == 0 and 1 or first, last == 0 and vim.fn.line("$") or last
end

local function frontmatter_end()
	local last = 1
	local inside = false

	for line = 1, vim.fn.line("$") do
		if vim.fn.getline(line):match("^%-%-%-%s*$") then
			inside = not inside
			if not inside then
				last = line + 1
			end
		end
	end

	return last
end

local function python_chunks()
	local tree = root()
	if not tree then
		return {}
	end

	local query = vim.treesitter.query.parse("markdown", "(fenced_code_block) @chunk")
	local chunks = {}

	for _, node in query:iter_captures(tree, vim.api.nvim_get_current_buf(), 0) do
		local info = vim.fn.getline(node:start() + 1)
		if info and info:match("{python}") then
			local first, last = range(node)
			table.insert(chunks, { first = first, last = last })
		end
	end

	return chunks
end

function M.current()
	local tree = root()
	if not tree then
		return fallback()
	end

	local line = vim.fn.line(".") - 1
	local node = tree:named_descendant_for_range(line, 0, line, 0)
	local first, last = block_at(node)

	if first then
		return first, last
	end

	return fallback()
end

function M.all()
	local chunks = python_chunks()

	if #chunks > 0 then
		return chunks
	end

	return { { first = math.max(frontmatter_end(), 1), last = vim.fn.line("$") } }
end

return M
