local M = {}

function M.has_running()
	local kernels = vim.fn.MoltenRunningKernels(true)

	return type(kernels) == "table" and #kernels > 0
end

return M
