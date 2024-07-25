local utils = require("utils")

return {
  "numToStr/Comment.nvim",
  init = function()
    utils.load_mappings("comment")
  end,
  opts = function()
    return {}
  end,
  config = function(_, opts)
    require("Comment").setup(opts)
  end
}

