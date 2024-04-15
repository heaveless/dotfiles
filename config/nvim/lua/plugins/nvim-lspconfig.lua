return {
  "neovim/nvim-lspconfig",
  opts = function()
    return {
      tsserver = {}
    }
  end,
  config = function(_, opts)
    local lspconfig = require("lspconfig")
    for name, cfg in pairs(opts) do
      lspconfig[name].setup(cfg)
    end
  end  
}

