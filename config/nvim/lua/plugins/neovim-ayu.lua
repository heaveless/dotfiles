return {
  "Shatur/neovim-ayu",
  opts = function()
    return {
      mirage = false
    }
  end,
  config = function(_, opts)
    local theme = require("ayu")
    theme.setup(opts)
    theme.colorscheme('ayu-dark')
  end
}
