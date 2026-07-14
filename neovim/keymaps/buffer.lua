-- Buffer Management Key Mappings
-- Note: Ctrl maps are case-insensitive in terminals, so <C-J>/<C-K> etc.
-- cannot coexist with the window-navigation maps in keymaps/lsp.lua.
-- Buffer cycling lives on Shift+H / Shift+L (bufferline, plugins/init.lua).

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- New tab
keymap("n", "<C-t>", "<ESC>:tabnew<CR>", opts)

-- Close buffer
keymap("n", "<C-q>", ":bp|bd #<CR>", opts)
keymap("i", "<C-q>", "<ESC>:bp|bd #<CR>", opts)

-- Leader key mappings
keymap("n", "<leader>ne", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>n ", ":NvimTreeFindFile<CR>", opts)
-- (<leader>t code outline lives in keymaps/lsp.lua)
