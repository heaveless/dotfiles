return {
  "nvimdev/dashboard-nvim",
  dependencies = {{"nvim-tree/nvim-web-devicons"}},
  cmd = "Dashboard",
  event = "VimEnter",
  opts = function()
    return {
      theme = 'doom',
      config = {
        header = { "heaveless" },
        footer = { "- Building my own world -" }
      }
    }
  end,
  config = function(_, opts)
    require("dashboard").setup(opts)
  end
}
