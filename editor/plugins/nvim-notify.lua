-- Nvim-Notify Configuration
-- Better notification system with animations and modern UI

local status_ok, notify = pcall(require, "notify")
if not status_ok then
  vim.notify("nvim-notify not found!", vim.log.levels.ERROR)
  return
end

notify.setup({
  -- Animation style (see help for available options)
  stages = "fade_in_slide_out", -- fade_in_slide_out, fade, slide, static
  
  -- Function called when a new window is opened, use for changing win settings/config
  on_open = nil,
  
  -- Function called when a window is closed
  on_close = nil,
  
  -- Render function for notifications. See notify-render()
  render = "default", -- default, minimal, simple
  
  -- Default timeout for notifications
  timeout = 5000,
  
  -- Max number of columns for messages
  max_width = nil,
  -- Max number of lines for a message
  max_height = nil,
  
  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
  background_colour = "Normal",
  
  -- Minimum width for notification windows
  minimum_width = 50,
  
  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})

-- Replace vim.notify with nvim-notify
vim.notify = notify

-- Keymaps for notification management
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Show notification history
keymap("n", "<leader>nh", function()
  require("notify").history()
end, opts)

-- Dismiss all notifications
keymap("n", "<leader>nd", function()
  require("notify").dismiss({ silent = true, pending = true })
end, opts)

-- Example of using notify in your config
vim.api.nvim_create_user_command("NotifyTest", function()
  vim.notify("This is a test notification!", vim.log.levels.INFO, {
    title = "Test Notification",
    timeout = 3000,
  })
end, {})