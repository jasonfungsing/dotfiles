-- nvim-tree Configuration
-- File tree navigation and management

require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = true,
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    full_name = false,
    highlight_opened_files = "none",
    root_folder_label = ":~:s?$?/..?",
    indent_width = 2,
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
        glyphs = {
          default = "📄",
          symlink = "🔗",
          bookmark = "🔖",
          folder = {
            arrow_closed = "▶",
            arrow_open = "▼",
            default = "📁",
            open = "📂",
            empty = "📁",
            empty_open = "📂",
            symlink = "🔗",
            symlink_open = "🔗",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "⚠",
            renamed = "➜",
            untracked = "★",
            deleted = "✖",
            ignored = "◌",
          },
        },
    },
  },
  sync_root_with_cwd = true,
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
})

-- Key mappings for nvim-tree
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>ne", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>n ", ":NvimTreeFindFile<CR>", opts)

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
