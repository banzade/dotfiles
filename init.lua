-- Set leader key
vim.g.mapleader = " "

-- Set to true if you have a Nerd font
vim.g.have_nerd_font = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, for example in resizing splits
vim.opt.mouse = 'a'

-- Tabs and identation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
-- Save undo history
vim.opt.breakindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("colorscheme desert")
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"
