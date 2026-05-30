-- Telescope
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Help tags" })

-- Hop
vim.keymap.set("n", "<leader>f", "<cmd>HopWord<CR>", { desc = "Hop word" })

-- ToggleTerm
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

-- NvimTree
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file tree" })

-- AI
vim.keymap.set("n", "<leader>a", "<cmd>CodeCompanionChat<CR>", { desc = "DeepSeek chat" })
vim.keymap.set("v", "<leader>a", "<cmd>CodeCompanionChatVisual<CR>", { desc = "DeepSeek chat (selection)" })
vim.keymap.set("n", "<leader>s", "<cmd>DotAgent<CR>", { desc = "DotAgent" })
vim.keymap.set("v", "<leader>s", "<cmd>DotAgentVisual<CR>", { desc = "DotAgent (selection)" })

-- MCP Hub
vim.keymap.set("n", "<leader>mc", "<cmd>MCPHub<CR>", { desc = "MCP Hub" })
vim.keymap.set("n", "<leader>ms", "<cmd>MCPStart<CR>", { desc = "Start MCP" })
vim.keymap.set("n", "<leader>mx", "<cmd>MCPStop<CR>", { desc = "Stop MCP" })
