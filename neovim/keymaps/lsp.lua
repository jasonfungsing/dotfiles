-- LSP and Modern Keymaps
-- Enhanced keybindings for the modernized setup

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Window navigation (Ctrl+H/J/K/L) is provided by vim-tmux-navigator
-- (plugins/init.lua) — same keys, and hops into tmux panes at the edges.

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer cycling is on Shift+H / Shift+L via bufferline (plugins/init.lua)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down in visual mode
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block mode
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)

-- Plugin-specific keymaps
-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Code outline (aerial — LSP/treesitter symbols)
keymap("n", "<leader>t", ":AerialToggle<CR>", opts)

-- Mason
keymap("n", "<leader>m", ":Mason<CR>", opts)

-- Lazy plugin manager
keymap("n", "<leader>l", ":Lazy<CR>", opts)

-- Diagnostic float; the <leader>x* list views belong to Trouble
-- (see plugins/init.lua)
keymap("n", "<leader>xf", vim.diagnostic.open_float, opts)