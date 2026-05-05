-- Neovim Configuration Entry Point
-- Pure Lua with lazy.nvim plugin manager
-- Modular architecture for maintainability

-- Add editor directory to Lua package path for both file and directory modules
local config_path = vim.fn.stdpath("config")
package.path = config_path .. "/?.lua;" .. config_path .. "/?/init.lua;" .. package.path

-- Load core configuration
require("config.core")
require("config.statusline")
require("config.neovim")
require("config.autocmds")

-- Load key mappings
require("keymaps.general")
require("keymaps.buffer")
require("keymaps.lsp")

-- Load and setup plugins
require("plugins")

-- Load theme and visual settings
require("theme.colours")

-- Load utility functions
require("utils.functions")

-- Startup notification
vim.notify("Neovim configuration loaded successfully!", vim.log.levels.INFO)
