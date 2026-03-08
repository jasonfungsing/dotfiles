-- Neovim configuration (init.lua)
-- This file sources the vimrc for backward compatibility with Vim
-- and adds Neovim-specific settings

-- Load existing vimrc for compatibility
vim.cmd.source(vim.env.HOME .. '/.vimrc')

-- ============================================================================
-- Neovim-specific settings
-- ============================================================================

-- Enable true colour support
vim.opt.termguicolors = true

-- Set colorscheme
vim.cmd('colorscheme gruvbox')
vim.opt.background = 'dark'

-- Neovim-specific performance improvements
vim.opt.synmaxcol = 240         -- limit syntax highlighting to 240 columns
vim.opt.updatetime = 300        -- faster completion, CursorHold trigger
vim.opt.redrawtime = 10000      -- allow more time for redrawing

-- Enable mouse support
vim.opt.mouse = 'a'

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('cache') .. '/undo'

-- Enable proper wildmenu completion
vim.opt.wildmenu = true
vim.opt.wildmode = 'list:longest'
vim.opt.completeopt = { 'menuone', 'noselect' }

-- Neovim-specific terminal settings
vim.opt.inccommand = 'nosplit'

-- ============================================================================
-- Key mappings for Neovim
-- ============================================================================

-- Map ESC to jk in insert mode (easier escape)
-- vim.keymap.set('i', 'jk', '<ESC>', { noremap = true, silent = true })

-- Map CTRL+C to ESC in terminal mode
vim.keymap.set('t', '<C-\\><C-n>', '<ESC>', { noremap = true, silent = true })

-- ============================================================================
-- LSP and Completion Setup (coc.nvim)
-- ============================================================================
-- coc.nvim is configured via the vimrc, but Neovim-specific LSP
-- can be added here if needed in the future

-- ============================================================================
-- Miscellaneous Neovim enhancements
-- ============================================================================

-- Improve diff colours
vim.cmd [[
  hi DiffAdd    ctermfg=white ctermbg=22
  hi DiffDelete ctermfg=white ctermbg=52
  hi DiffChange ctermfg=white ctermbg=17
  hi DiffText   ctermfg=white ctermbg=18
]]

-- ============================================================================
-- Helper functions
-- ============================================================================

-- Function to reload configuration
local function reload_config()
  vim.cmd('source ~/.vimrc')
end

-- Create a command to reload config
vim.api.nvim_create_user_command('ReloadConfig', reload_config, {})

-- ============================================================================
-- Print startup message
-- ============================================================================
vim.notify('Neovim configuration loaded successfully!', vim.log.levels.INFO)
