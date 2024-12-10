local g = vim.g
local opt = vim.opt

g.mapleader = " "

opt.clipboard = "unnamedplus"
opt.cursorline = false
opt.number = true

local boot = require("bootstrap")
boot.install()
boot.init()
