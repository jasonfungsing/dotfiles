-- Neovim-specific Settings
-- Performance improvements and terminal configuration

-- Enable true colour support
vim.opt.termguicolors = true

-- Performance improvements
vim.opt.synmaxcol = 240         -- limit syntax highlighting to 240 columns
vim.opt.updatetime = 300        -- faster completion, CursorHold trigger
vim.opt.redrawtime = 10000      -- allow more time for redrawing

-- Enable mouse support
vim.opt.mouse = "a"

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Enable proper wildmenu completion
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.completeopt = { "menuone", "noselect" }

-- Neovim-specific terminal settings
vim.opt.inccommand = "nosplit"
