-- Buffer Management Key Mappings
-- Note: Ctrl maps are case-insensitive in terminals, so <C-J>/<C-K> etc.
-- cannot coexist with the window-navigation maps (vim-tmux-navigator).
-- Buffer cycling lives on Shift+H / Shift+L (bufferline, plugins/init.lua);
-- nvim-tree maps (<leader>ne, <leader>n<Space>) live in plugins/nvim-tree.lua.

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- New tab
keymap("n", "<C-t>", "<ESC>:tabnew<CR>", { noremap = true, silent = true, desc = "New tab" })

-- Close buffer
keymap("n", "<C-q>", ":bp|bd #<CR>", { noremap = true, silent = true, desc = "Close buffer" })
keymap("i", "<C-q>", "<ESC>:bp|bd #<CR>", opts)
