-- nvim-tree Configuration
-- File tree navigation and management

require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = true,
  },
  renderer = {
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "▶",
          arrow_open = "▼",
        },
      },
      show = {
        file = true,
        git = true,
      },
    },
    indent_width = 2,
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
