-- Buffer Management Key Mappings
-- Navigation between buffers and tabs

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Buffer navigation
keymap("n", "<C-J>", ":bnext<CR>", opts)
keymap("n", "<C-K>", ":bprev<CR>", opts)

-- Tab navigation
keymap("n", "<C-L>", ":tabn<CR>", opts)
keymap("n", "<C-H>", ":tabp<CR>", opts)

-- New buffer/tab
keymap("n", "<C-T>", ":enew<CR>", opts)
keymap("n", "<C-t>", "<ESC>:tabnew<CR>", opts)

-- Close buffer
keymap("n", "<C-q>", ":bp|bd #<CR>", opts)
keymap("i", "<C-q>", "<ESC>:bp|bd #<CR>", opts)
