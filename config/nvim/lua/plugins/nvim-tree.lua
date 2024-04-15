local utils = require("utils")

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" }
  },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  init = function()
    utils.load_mappings("nvim-tree")
  end,
  config = function(_, opts)
      require("nvim-tree").setup(opts)
  end
}
