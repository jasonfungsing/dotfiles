-- Telescope Configuration
-- Fuzzy finder for files, buffers, and keybindings

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

-- Setup Telescope with defaults and extensions
telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "➜ ",
    path_display = { "truncate" },
    previewer = true,
    case_mode = "ignore_case",
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
})

-- Load extensions
pcall(telescope.load_extension, "ui-select")

-- Keybinding helper
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Telescope keybindings
keymap("n", "<leader>/", builtin.keymaps, opts)
keymap("n", "<leader>?", builtin.commands, opts)
keymap("n", "<leader>ff", builtin.find_files, opts)
keymap("n", "<leader>fg", builtin.live_grep, opts)
keymap("n", "<leader>fb", builtin.buffers, opts)
keymap("n", "<leader>fh", builtin.help_tags, opts)
