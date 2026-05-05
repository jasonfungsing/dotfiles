-- Alpha Dashboard Configuration
-- Beautiful startup screen with quick actions and recent files

local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  -- Silently return if alpha is not installed yet
  return
end

local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                     ",
  "    🚀 Ready for productive development! 🚀          ",
  "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
  dashboard.button("e", "📝  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "🔍  Find file", ":Telescope find_files <CR>"),
  dashboard.button("r", "📚  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("w", "🔤  Find word", ":Telescope live_grep <CR>"),
  dashboard.button("p", "📁  Find project", ":Telescope projects <CR>"),
  dashboard.button("c", "⚙️   Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("s", "💾  Restore session", ":lua require('persistence').load() <CR>"),
  dashboard.button("l", "🔌  Lazy", ":Lazy <CR>"),
  dashboard.button("m", "🔧  Mason", ":Mason <CR>"),
  dashboard.button("q", "❌  Quit", ":qa <CR>"),
}

-- Set footer
local function footer()
  local total_plugins = require("lazy").stats().count
  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return "⚡ " .. total_plugins .. " plugins" .. nvim_version_info .. datetime
end

dashboard.section.footer.val = footer()

-- Disable folding on alpha buffer
dashboard.config.opts.noautocmd = true

-- Send config to alpha
alpha.setup(dashboard.config)

-- Disable statusline in dashboard
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  desc = "disable statusline for alpha",
  callback = function()
    local old_laststatus = vim.opt.laststatus
    vim.api.nvim_create_autocmd("BufUnload", {
      buffer = 0,
      callback = function()
        vim.opt.laststatus = old_laststatus
      end,
    })
    vim.opt.laststatus = 0
  end,
})

-- Auto-open alpha when no files are specified
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local should_skip = false
    if vim.fn.argc() > 0 or vim.fn.line2byte("$") ~= -1 or not vim.o.modifiable then
      should_skip = true
    else
      for _, arg in pairs(vim.v.argv) do
        if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
          should_skip = true
          break
        end
      end
    end
    if not should_skip then
      require("alpha").start(true)
    end
  end,
})