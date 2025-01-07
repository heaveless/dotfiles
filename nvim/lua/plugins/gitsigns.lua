local M = {
	"lewis6991/gitsigns.nvim"
}

M.config = function() 
	require("gitsigns").setup()
end

return M
