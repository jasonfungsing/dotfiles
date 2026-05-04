-- which-key.nvim Configuration
-- Displays available keybindings in a popup menu

local wk = require("which-key")

wk.setup({
  preset = "helix",
  delay = 200,
  win = {
    border = "rounded",
    padding = { 1, 2 },
  },
})

-- Register Telescope keybindings
wk.add({
  { "<leader>f", group = "telescope" },
  { "<leader>ff", desc = "Find files" },
  { "<leader>fg", desc = "Live grep" },
  { "<leader>fb", desc = "Buffers" },
  { "<leader>fh", desc = "Help tags" },
  { "<leader>/", desc = "Keymaps" },
  { "<leader>?", desc = "Commands" },
})
