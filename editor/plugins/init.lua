-- Plugin Manager Bootstrap and Specifications
-- Lazy.nvim plugin manager with all plugin specifications

-- Bootstrap lazy.nvim
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

-- Setup lazy.nvim with all plugins
require("lazy").setup({
  -- Icons for file types (must load before nvim-tree)
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- File navigation
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    version = "*",
    config = function()
      require("plugins.nvim-tree")
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
  "morhetz/gruvbox",
  "frazrepo/vim-rainbow",
  "jeffkreeftmeijer/vim-numbertoggle",

  -- Commenting
  {
    "scrooloose/nerdcommenter",
    config = function()
      require("plugins.nerd-commenter")
    end,
  },

  -- Git integration
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  "tpope/vim-projectionist",

  -- Navigation and search
  {
    "ctrlpvim/ctrlp.vim",
    config = function()
      require("plugins.ctrlp")
    end,
  },
  "christoomey/vim-tmux-navigator",
  "easymotion/vim-easymotion",

  -- Fuzzy finder for files, buffers, and keybindings
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("plugins.telescope")
    end,
  },

  -- Linting and formatting
  {
    "dense-analysis/ale",
    event = "VeryLazy",
    config = function()
      require("plugins.ale")
    end,
  },

  -- Code completion and LSP
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      require("plugins.coc")
    end,
  },

  -- Tags and navigation
  {
    "preservim/tagbar",
    config = function()
      require("plugins.tagbar")
    end,
  },

  -- Keybinding helper and discoverer
  {
    "folke/which-key.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("plugins.which-key")
    end,
  },

  -- Development utilities
  "rizzatti/dash.vim",
  "benmills/vimux",
  "yuttie/comfortable-motion.vim",
  "kristijanhusak/vim-carbon-now-sh",

  -- Rainbow parentheses
  {
    "frazrepo/vim-rainbow",
    config = function()
      require("plugins.rainbow")
    end,
  },
}, {
  defaults = { lazy = true },
  install = { colorscheme = { "gruvbox" } },
  checker = { enabled = true },
})
