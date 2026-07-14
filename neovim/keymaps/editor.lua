-- Editor & Window Keymaps
-- Window resizing, text movement, search, and editor-wide plugin toggles.
-- (LSP buffer-local maps live in plugins/lsp.lua; buffer/tab maps in
-- keymaps/buffer.lua; dashboard-style leader shortcuts in
-- keymaps/dashboard.lua.)

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local function nmap(lhs, rhs, desc)
  keymap("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Clear search highlighting
nmap("<leader>h", ":nohlsearch<CR>", "Clear search highlight")

-- Window navigation (Ctrl+H/J/K/L) is provided by vim-tmux-navigator
-- (plugins/init.lua) — same keys, and hops into tmux panes at the edges.

-- Resize windows with arrows
nmap("<C-Up>", ":resize -2<CR>", "Shrink window height")
nmap("<C-Down>", ":resize +2<CR>", "Grow window height")
nmap("<C-Left>", ":vertical resize -2<CR>", "Shrink window width")
nmap("<C-Right>", ":vertical resize +2<CR>", "Grow window width")

-- Buffer cycling is on Shift+H / Shift+L via bufferline (plugins/init.lua)
nmap("<leader>bd", ":bdelete<CR>", "Delete buffer")

-- Move text up and down
nmap("<A-j>", "<Esc>:m .+1<CR>==gi", "Move line down")
nmap("<A-k>", "<Esc>:m .-2<CR>==gi", "Move line up")

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

-- Code outline (aerial — LSP/treesitter symbols)
nmap("<leader>t", ":AerialToggle<CR>", "Toggle code outline (Aerial)")

-- Diagnostic float; the <leader>x* list views belong to Trouble
-- (see plugins/init.lua)
nmap("<leader>xf", vim.diagnostic.open_float, "Diagnostic float")
