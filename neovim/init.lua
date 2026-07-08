-- Neovim Configuration Entry Point
-- Pure Lua with lazy.nvim plugin manager
-- Modular architecture for maintainability

-- Add editor directory to Lua package path for both file and directory modules
local config_path = vim.fn.stdpath("config")
package.path = config_path .. "/?.lua;" .. config_path .. "/?/init.lua;" .. package.path

-- Load core configuration
require("config.core")
require("config.neovim")
require("config.autocmds")

-- Load key mappings
require("keymaps.general")
require("keymaps.buffer")
require("keymaps.lsp")
require("keymaps.dashboard")

-- Load and setup plugins
require("plugins")

-- Load theme and visual settings
require("theme.colours")

-- Load utility functions
require("utils.functions")

-- Clear any lingering messages and show startup notification
vim.defer_fn(function()
  -- Clear command line
  vim.cmd('echo ""')
  
  -- Ensure nvim-notify is loaded before showing notification
  local notify_ok, notify = pcall(require, "notify")
  if notify_ok then
    -- Use nvim-notify directly to ensure timeout works
    notify("Neovim configuration loaded successfully!", vim.log.levels.INFO, {
      title = "Neovim Ready",
      timeout = 5000, -- Explicit 5-second timeout
      animate = true,
    })
  else
    -- Fallback to regular vim.notify if nvim-notify isn't available
    vim.notify("Neovim configuration loaded successfully!", vim.log.levels.INFO)
    -- Clear it manually after 5 seconds if using fallback
    vim.defer_fn(function()
      vim.cmd('echo ""')
    end, 5000)
  end
end, 1000) -- Increased delay to 1 second to ensure nvim-notify is fully loaded

-- Auto-clear command line messages after 5 seconds
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.cmd('echo ""')
    end, 5000)
  end,
})
