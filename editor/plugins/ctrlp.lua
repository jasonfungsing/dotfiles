-- CtrlP Configuration
-- Fuzzy file finder with Silver Searcher integration

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

if vim.fn.executable("ag") == 1 then
  vim.opt.grepprg = "ag --nogroup --nocolor"
  vim.g.ctrlp_user_command = "ag %s -l --nocolor -g \"\""
  vim.g.ctrlp_use_caching = 0

  -- Bind K to grep word under cursor
  keymap("n", "K", ":grep! \"\\b<C-R><C-W>\\b\"<CR>:cw<CR>", opts)

  -- Bind backslash to grep shortcut
  vim.cmd("command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!")
  keymap("n", "\\", ":Ag<SPACE>", opts)
end
