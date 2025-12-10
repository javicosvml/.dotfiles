-- Core Neovim Options

local opt = vim.opt

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileformats = "unix"

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.termguicolors = true
opt.colorcolumn = "90"
opt.cursorline = true
opt.showmode = false  -- Shown in statusline

-- Behavior
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
-- Note: lazyredraw is deprecated in Neovim 0.10+

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Clipboard (use system clipboard)
opt.clipboard = "unnamedplus"

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- Mouse
opt.mouse = "a"

-- Disable netrw (using nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
