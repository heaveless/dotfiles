return {
  "nvim-treesitter/nvim-treesitter",
  opts = function()
    return {
      ensure_install = { "lua", "c", "cpp", "javascript", "typescript", "python" },
      highlight = {
        enable = true
      }
    }
  end,
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end
}
