-- Core Vim Settings
-- Basic options and indentation configuration

-- Leader key
vim.g.mapleader = ","

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.compatible = false
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.modifiable = true
vim.opt.syntax = "enable"

-- Terminal colours
vim.opt.termguicolors = true
vim.opt.laststatus = 2

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Softtabs, 2 spaces
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- Display extra whitespace
vim.opt.list = true
vim.opt.listchars = "tab:»·,trail:·,nbsp:·"

-- Natural split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- File handling
vim.opt.suffixesadd:append(".js")
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.wb = false
vim.opt.hidden = true
