-- Plugin Manager Bootstrap and Specifications
-- Lazy.nvim plugin manager with modern plugin specifications

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
      require("nvim-web-devicons").setup({
        override = {
          js = {
            icon = "📜",
            color = "#cbcb41",
            name = "Js"
          },
          md = {
            icon = "📝",
            color = "#519aba",
            name = "Md"
          },
          lua = {
            icon = "🌙",
            color = "#51a0cf",
            name = "Lua"
          },
          py = {
            icon = "🐍",
            color = "#4584b6",
            name = "Py"
          },
          go = {
            icon = "🐹",
            color = "#519aba",
            name = "Go"
          },
          json = {
            icon = "📋",
            color = "#cbcb41",
            name = "Json"
          },
          sh = {
            icon = "🐚",
            color = "#4d5a5e",
            name = "Sh"
          }
        },
        default = true,
        strict = true,
        override_by_filename = {
          [".gitignore"] = {
            icon = "🚫",
            color = "#f1502f",
            name = "Gitignore"
          },
          ["README.md"] = {
            icon = "📖",
            color = "#519aba",
            name = "Readme"
          },
          ["Dockerfile"] = {
            icon = "🐳",
            color = "#458ee6",
            name = "Dockerfile"
          }
        },
        override_by_extension = {
          ["log"] = {
            icon = "📄",
            color = "#81e043",
            name = "Log"
          }
        }
      })
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

  -- Treesitter for better syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.treesitter")
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("plugins.lsp")
    end,
  },

  -- LSP server management
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("plugins.mason-lspconfig")
    end,
  },

  -- Completion framework
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("plugins.nvim-cmp")
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("plugins.luasnip")
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("plugins.conform")
    end,
  },

  -- Modern commenting
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto-pairs for brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.autopairs")
    end,
  },

  -- Better diagnostics and error navigation
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
      { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP References" },
    },
    config = function()
      require("plugins.trouble")
    end,
  },

  -- Better buffer management
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    config = function()
      require("plugins.bufferline")
    end,
  },

  -- Modern surround operations
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("plugins.nvim-surround")
    end,
  },

  -- Integrated terminal management
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", desc = "Toggle terminal" },
      { "<leader>tf", desc = "Float terminal" },
      { "<leader>tv", desc = "Vertical terminal" },
      { "<leader>ts", desc = "Horizontal terminal" },
    },
    config = function()
      require("plugins.toggleterm")
    end,
  },

  -- Startup dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      require("plugins.alpha")
    end,
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    keys = {
      { "<leader>nh", desc = "Notification History" },
      { "<leader>nd", desc = "Dismiss Notifications" },
    },
    config = function()
      require("plugins.nvim-notify")
    end,
  },

  -- Project-wide search and replace
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    keys = {
      { "<leader>S", desc = "Replace in files (Spectre)" },
      { "<leader>sw", desc = "Search current word" },
      { "<leader>sp", desc = "Search in current file" },
    },
    config = function()
      require("plugins.nvim-spectre")
    end,
  },

  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", desc = "Toggle Breakpoint" },
      { "<leader>dc", desc = "Continue" },
      { "<leader>di", desc = "Step Into" },
      { "<leader>do", desc = "Step Over" },
      { "<leader>du", desc = "Toggle DAP UI" },
    },
    config = function()
      require("plugins.nvim-dap")
    end,
  },

  -- Lightning-fast file navigation
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<leader>ha", desc = "Harpoon Add File" },
      { "<leader>hm", desc = "Harpoon Menu" },
      { "<leader>h1", desc = "Harpoon File 1" },
      { "<leader>h2", desc = "Harpoon File 2" },
      { "<leader>h3", desc = "Harpoon File 3" },
      { "<leader>h4", desc = "Harpoon File 4" },
    },
    config = function()
      require("plugins.harpoon")
    end,
  },

  -- Modern colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("plugins.catppuccin")
    end,
  },

  -- Color visualization
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "javascript", "typescript", "lua" },
    keys = {
      { "<leader>ct", desc = "Toggle Colorizer" },
      { "<leader>cr", desc = "Reload Colorizer" },
    },
    config = function()
      require("plugins.colorizer")
    end,
  },

  -- Advanced git workflow
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", desc = "Git Diff View" },
      { "<leader>gh", desc = "Git File History" },
      { "<leader>gc", desc = "Close Git Diff" },
      { "<leader>gf", desc = "Git File History (current)" },
    },
    config = function()
      require("plugins.diffview")
    end,
  },

  -- Language-specific plugins
  { "gavocanov/vim-js-indent", ft = "javascript" },
  { "pangloss/vim-javascript", ft = "javascript" },
  { "fatih/vim-go", ft = "go" },

  -- Text manipulation
  "tpope/vim-markdown",
  "godlygeek/tabular",

  -- UI enhancements
  "morhetz/gruvbox",
  "jeffkreeftmeijer/vim-numbertoggle",

  -- Rainbow parentheses (temporarily removed due to submodule issues)
  -- Can be re-added later if needed

  -- Git integration
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.gitsigns")
    end,
  },
  "tpope/vim-projectionist",

  -- Navigation
  "christoomey/vim-tmux-navigator",
  "easymotion/vim-easymotion",

  -- Fuzzy finder for files, buffers, and keybindings
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      require("plugins.telescope")
    end,
  },

  -- Tags and navigation
  {
    "preservim/tagbar",
    cmd = "TagbarToggle",
    config = function()
      require("plugins.tagbar")
    end,
  },

  -- Keybinding helper and discoverer
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.which-key")
    end,
  },

  -- Development utilities
  "rizzatti/dash.vim",
  "benmills/vimux",
  "yuttie/comfortable-motion.vim",
  "kristijanhusak/vim-carbon-now-sh",

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("plugins.persistence")
    end,
  },

  -- Better statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.lualine")
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.indent-blankline")
    end,
  },

}, {
  defaults = { lazy = true },
  install = { colorscheme = { "gruvbox" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})