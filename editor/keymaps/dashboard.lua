-- Dashboard Key Mappings
-- Global access to Alpha dashboard shortcuts using leader key

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Dashboard shortcuts accessible anywhere in Neovim
keymap("n", "<leader>n", ":ene <BAR> startinsert <CR>", opts)  -- New file
keymap("n", "<leader>f", ":Telescope find_files <CR>", opts)   -- Find file
keymap("n", "<leader>r", ":Telescope oldfiles <CR>", opts)     -- Recent files
keymap("n", "<leader>w", ":Telescope live_grep <CR>", opts)    -- Find word
keymap("n", "<leader>p", ":Telescope projects <CR>", opts)     -- Find project
keymap("n", "<leader>c", ":e ~/.config/nvim/init.lua <CR>", opts)  -- Configuration
keymap("n", "<leader>s", ":lua require('persistence').load() <CR>", opts)  -- Restore session
keymap("n", "<leader>l", ":Lazy <CR>", opts)                   -- Lazy
keymap("n", "<leader>m", ":Mason <CR>", opts)                  -- Mason
keymap("n", "<leader>q", ":qa <CR>", opts)                     -- Quit