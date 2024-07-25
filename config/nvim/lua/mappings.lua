return {
  ["nvim-tree"] = {
    n = {
      ["<C-n>"] = "<cmd> NvimTreeToggle <CR>",
      ["<leader>e"] = "<cmd> NvimTreeFocus <CR>"
    }
  },
  telescope = {
    n = {
      ["<leader>ff"] = "<cmd> Telescope find_files <CR>",
    }
  },
  comment = {
    n = {
      ["<leader>kc"] = function()
        require("Comment.api").comment.linewise.current()
      end,
      ["<leader>ku"] = function()
        require("Comment.api").uncomment.linewise.current()
      end
    },
    v = {
      ["<leader>kc"] =  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      ["<leader>ku"] =  "<ESC><cmd>lua require('Comment.api').uncomment.linewise(vim.fn.visualmode())<CR>"
    }
  }
}
