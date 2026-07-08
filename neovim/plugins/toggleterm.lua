-- ToggleTerm Configuration
-- Integrated terminal management with multiple terminals

local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  vim.notify("toggleterm.nvim not found!", vim.log.levels.ERROR)
  return
end

toggleterm.setup({
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
})

-- Terminal keymaps
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- Apply terminal keymaps when terminal opens
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Custom terminal functions
local Terminal = require("toggleterm.terminal").Terminal

-- Lazygit terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

-- Node REPL
local node = Terminal:new({ cmd = "node", hidden = true })

-- Python REPL
local python = Terminal:new({ cmd = "python3", hidden = true })

-- Htop
local htop = Terminal:new({ cmd = "htop", hidden = true })

-- Custom terminal functions
function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

function _NODE_TOGGLE()
  node:toggle()
end

function _PYTHON_TOGGLE()
  python:toggle()
end

function _HTOP_TOGGLE()
  htop:toggle()
end

-- Keymaps for custom terminals
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", opts)
keymap("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", opts)
keymap("n", "<leader>th", "<cmd>lua _HTOP_TOGGLE()<CR>", opts)

-- General terminal keymaps
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", opts)
keymap("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", opts)
keymap("n", "<leader>ts", "<cmd>ToggleTerm direction=horizontal<cr>", opts)