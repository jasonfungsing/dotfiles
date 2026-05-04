-- Utility Functions
-- Helper functions and custom commands

-- Function to reload configuration
local function reload_config()
  vim.cmd("source $HOME/.config/nvim/init.lua")
end

-- Create a command to reload config
vim.api.nvim_create_user_command("ReloadConfig", reload_config, {})
