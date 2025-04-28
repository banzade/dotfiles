-- Set leader key
vim.g.mapleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs and identation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("colorscheme desert")

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Better splitting
vim.opt.splitright = true
vim.opt.splitbelow = true
