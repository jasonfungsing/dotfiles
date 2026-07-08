-- Harpoon Configuration
-- Lightning-fast file navigation and bookmarking system

local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
  vim.notify("harpoon not found!", vim.log.levels.ERROR)
  return
end

harpoon.setup({
  global_settings = {
    -- sets the marks upon calling `toggle_quick_menu()`
    save_on_toggle = false,
    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,
    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = false,
    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,
    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },
    -- set marks specific to each git branch inside git repository
    mark_branch = false,
    -- enable tabline with harpoon marks
    tabline = false,
    tabline_prefix = "   ",
    tabline_suffix = "   ",
  },
  projects = {
    -- Yes $HOME works
    ["$HOME/personal/vim-with-me/server"] = {
      term = {
        cmds = {
          "./env && npx ts-node src/index.ts"
        }
      }
    }
  }
})

-- Keymaps for Harpoon
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Core harpoon functionality
keymap("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", opts)
keymap("n", "<leader>hm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)

-- Navigate to specific harpoon marks
keymap("n", "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", opts)
keymap("n", "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", opts)
keymap("n", "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", opts)
keymap("n", "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", opts)

-- Navigate between harpoon marks
keymap("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", opts)
keymap("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", opts)

-- Terminal commands with harpoon
keymap("n", "<leader>ht1", "<cmd>lua require('harpoon.term').gotoTerminal(1)<cr>", opts)
keymap("n", "<leader>ht2", "<cmd>lua require('harpoon.term').gotoTerminal(2)<cr>", opts)
keymap("n", "<leader>hc1", "<cmd>lua require('harpoon.term').sendCommand(1, 1)<cr>", opts)
keymap("n", "<leader>hc2", "<cmd>lua require('harpoon.term').sendCommand(1, 2)<cr>", opts)

-- Quick access with function keys (alternative bindings)
keymap("n", "<C-h>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
keymap("n", "<C-j>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", opts)
keymap("n", "<C-k>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", opts)
keymap("n", "<C-l>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", opts)