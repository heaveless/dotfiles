local M = {}

local function hl(group, spec)
	vim.api.nvim_set_hl(0, group, spec)
end

function M.apply(color)
	vim.api.nvim_command("hi clear")

	if vim.fn.exists("syntax_on") then
		vim.api.nvim_command("syntax reset")
	end

	vim.o.termguicolors = true

	local spec = { fg = color.fg, bg = color.bg }

	for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
		hl(group, spec)
	end

	hl("Comment", { fg = color.fg_ina })
	hl("@comment", { link = "Comment" })
	hl("TSComment", { link = "Comment" })
	hl("@lsp.type.comment", { link = "Comment" })

	hl("Visual", { fg = color.fg_sel })
	hl("EndOfBuffer", { fg = color.bg })

	hl("Cursor", { fg = color.bg, bg = color.fg })
	hl("TermCursor", { fg = color.bg, bg = color.fg })
end

return M
