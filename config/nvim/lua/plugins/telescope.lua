local utils = require("utils")

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = "Telescope",
  init = function()
    utils.load_mappings("telescope")
  end,
  opts = function()
    return {}
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
  end
} 
