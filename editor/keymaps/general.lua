-- General Key Mappings
-- Navigation, paste formatting, and learning helpers

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Auto indent pasted text
keymap("n", "p", "p=`]<C-o>", opts)
keymap("n", "P", "P=`]<C-o>", opts)

-- Disable Arrow Keys with helpful messages
keymap("n", "<Left>", ":echoe 'Use h'<CR>", opts)
keymap("n", "<Right>", ":echoe 'Use l'<CR>", opts)
keymap("n", "<Up>", ":echoe 'Use k'<CR>", opts)
keymap("n", "<Down>", ":echoe 'Use j'<CR>", opts)

-- Map keys to insert empty line without entering insert mode
keymap("n", "<Enter>", "o<ESC>", opts)
keymap("n", "<S-Enter>", "O<ESC>", opts)

-- Map key to insert empty space without entering insert mode
keymap("n", "<space>", "i<space><esc>", opts)
