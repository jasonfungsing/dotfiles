-- Neovim configuration (init.lua) - Pure Lua with lazy.nvim

-- ============================================================================
-- Core Settings
-- ============================================================================

-- Leader key
vim.g.mapleader = ","

-- Basic options
vim.opt.number = true
vim.opt.compatible = false
vim.opt.laststatus = 2
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.modifiable = true
vim.opt.syntax = "enable"

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Softtabs, 2 spaces
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- Display extra whitespace
vim.opt.list = true
vim.opt.listchars = "tab:»·,trail:·,nbsp:·"

-- Natural split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- File handling
vim.opt.suffixesadd:append(".js")
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.wb = false
vim.opt.hidden = true

-- ============================================================================
-- Neovim-specific Settings
-- ============================================================================

-- Enable true colour support
vim.opt.termguicolors = true

-- Performance improvements
vim.opt.synmaxcol = 240         -- limit syntax highlighting to 240 columns
vim.opt.updatetime = 300        -- faster completion, CursorHold trigger
vim.opt.redrawtime = 10000      -- allow more time for redrawing

-- Enable mouse support
vim.opt.mouse = "a"

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Enable proper wildmenu completion
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.completeopt = { "menuone", "noselect" }

-- Neovim-specific terminal settings
vim.opt.inccommand = "nosplit"

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Automatically remove trailing whitespace before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd("%s/\\s\\+$//e")
  end,
})

-- ============================================================================
-- Key Mappings - General
-- ============================================================================

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

-- ============================================================================
-- Key Mappings - Buffer Management
-- ============================================================================

keymap("n", "<C-J>", ":bnext<CR>", opts)
keymap("n", "<C-K>", ":bprev<CR>", opts)
keymap("n", "<C-L>", ":tabn<CR>", opts)
keymap("n", "<C-H>", ":tabp<CR>", opts)
keymap("n", "<C-T>", ":enew<CR>", opts)
keymap("n", "<C-q>", ":bp|bd #<CR>", opts)
keymap("i", "<C-q>", "<ESC>:bp|bd #<CR>", opts)

-- Map CTRL+T for new tab (alternative)
keymap("n", "<C-t>", "<ESC>:tabnew<CR>", opts)

-- Map keys to insert empty line without entering insert mode
keymap("n", "<Enter>", "o<ESC>", opts)
keymap("n", "<S-Enter>", "O<ESC>", opts)

-- Map key to insert empty space without entering insert mode
keymap("n", "<space>", "i<space><esc>", opts)

-- ============================================================================
-- Bootstrap lazy.nvim
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugin Specifications with lazy.nvim
-- ============================================================================

require("lazy").setup({
  -- File navigation
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        git = {
          enable = true,
        },
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
            },
          },
        },
      })
    end,
  },
  
  -- Language-specific plugins
  { "gavocanov/vim-js-indent", ft = "javascript" },
  { "pangloss/vim-javascript", ft = "javascript" },
  { "fatih/vim-go", ft = "go" },
  
  -- Text manipulation
  "tpope/vim-surround",
  "tpope/vim-markdown",
  "godlygeek/tabular",
  
  -- UI enhancements
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  "morhetz/gruvbox",
  "frazrepo/vim-rainbow",
  "jeffkreeftmeijer/vim-numbertoggle",
  
  -- Commenting
  "scrooloose/nerdcommenter",
  
  -- Git integration
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  "tpope/vim-projectionist",
  
  -- Navigation and search
  "ctrlpvim/ctrlp.vim",
  "christoomey/vim-tmux-navigator",
  "easymotion/vim-easymotion",
  
  -- Linting and formatting
  { "dense-analysis/ale", event = "VeryLazy" },
  
  -- Code completion and LSP
  { "neoclide/coc.nvim", branch = "release" },
  
  -- Tags and navigation
  "preservim/tagbar",
  
  -- Development utilities
  "rizzatti/dash.vim",
  "benmills/vimux",
  "yuttie/comfortable-motion.vim",
  "kristijanhusak/vim-carbon-now-sh",
  
  -- FZF support
  { dir = "/usr/local/opt/fzf", enabled = vim.fn.isdirectory("/usr/local/opt/fzf") == 1 },
}, {
  defaults = { lazy = true },
  install = { colorscheme = { "gruvbox" } },
  checker = { enabled = true },
})

-- ============================================================================
-- Plugin Configuration - nvim-tree
-- ============================================================================

-- Key mappings for nvim-tree
keymap("n", "<leader>ne", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>n", ":NvimTreeFindFile<CR>", opts)

-- Open nvim-tree automatically when Neovim starts up if no files were specified
vim.api.nvim_create_autocmd("StdinReadPre", {
  callback = function()
    vim.g.std_in = 1
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.g.std_in ~= 1 then
      require("nvim-tree.api").tree.open()
    end
  end,
})

-- ============================================================================
-- Plugin Configuration - NERD Commenter
-- ============================================================================

vim.g.NERDSpaceDelims = 1
vim.g.NERDCompactSexyComs = 1
vim.g.NERDDefaultAlign = "left"
vim.g.NERDAltDelims_java = 1
vim.g.NERDCustomDelimiters = { c = { left = "/**", right = "*/" } }
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1

-- ============================================================================
-- Plugin Configuration - Airline
-- ============================================================================

vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#fnamemod"] = ":t"

-- ============================================================================
-- Plugin Configuration - ALE (Asynchronous Lint Engine)
-- ============================================================================

vim.g.ale_linters_explicit = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_sign_column_always = 1
vim.g.ale_linters = {
  javascript = { "eslint" },
  python = { "pylint", "flake8" },
  go = { "golint", "go vet" },
  java = { "eclipselsp" },
}

-- ============================================================================
-- Plugin Configuration - coc.nvim
-- ============================================================================

vim.g.coc_global_extensions = {
  "coc-tsserver",
  "coc-python",
  "coc-git",
  "coc-java",
  "coc-json",
  "coc-go",
  "coc-eslint",
  "coc-prettier",
}

-- ============================================================================
-- Plugin Configuration - CtrlP with Silver Searcher (ag)
-- ============================================================================

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

-- ============================================================================
-- Plugin Configuration - Rainbow Parentheses
-- ============================================================================

vim.g.rainbow_active = 1
vim.g.rainbow_ctermfgs = { "green", "yellow", "cyan", "magenta", "red" }

-- ============================================================================
-- Plugin Configuration - Tagbar
-- ============================================================================

keymap("n", "<leader>t", ":TagbarToggle<CR>", opts)

-- ============================================================================
-- Colour Scheme and Visual Settings
-- ============================================================================

-- Improve diff colours
vim.cmd [[
  hi DiffAdd    ctermfg=white ctermbg=22
  hi DiffDelete ctermfg=white ctermbg=52
  hi DiffChange ctermfg=white ctermbg=17
  hi DiffText   ctermfg=white ctermbg=18
]]

-- Set colourscheme (gruvbox should be available after plugins install)
pcall(vim.cmd, "colorscheme gruvbox")

-- ============================================================================
-- Utility Functions
-- ============================================================================

-- Function to reload configuration
local function reload_config()
  vim.cmd("source $HOME/.config/nvim/init.lua")
end

-- Create a command to reload config
vim.api.nvim_create_user_command("ReloadConfig", reload_config, {})

-- ============================================================================
-- Startup Message
-- ============================================================================

vim.notify("Neovim configuration loaded successfully!", vim.log.levels.INFO)
