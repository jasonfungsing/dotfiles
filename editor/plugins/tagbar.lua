-- Tagbar Configuration
-- Code structure and tag navigation

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>t", ":TagbarToggle<CR>", opts)
