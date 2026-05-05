-- Ultimate Help System
-- Comprehensive command reference showing all keybindings in one view

local M = {}

-- Create comprehensive help system using Telescope
function M.show_all_commands()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Comprehensive list of all commands organized by category
  local all_commands = {
    -- File Operations
    { key = "<leader>ff", desc = "🔍 Find Files", category = "📁 File Operations" },
    { key = "<leader>fg", desc = "🔤 Live Grep", category = "📁 File Operations" },
    { key = "<leader>fb", desc = "📑 Buffers", category = "📁 File Operations" },
    { key = "<leader>fh", desc = "❓ Help Tags", category = "📁 File Operations" },
    { key = "<leader>fr", desc = "📚 Recent Files", category = "📁 File Operations" },
    { key = "<leader>fc", desc = "⚙️ Commands", category = "📁 File Operations" },
    { key = "<leader>fk", desc = "🔑 Keymaps", category = "📁 File Operations" },

    -- Git Operations
    { key = "<leader>gd", desc = "📊 Git Diff View", category = "🔀 Git Operations" },
    { key = "<leader>gh", desc = "📜 Git History", category = "🔀 Git Operations" },
    { key = "<leader>gc", desc = "❌ Close Diff", category = "🔀 Git Operations" },
    { key = "<leader>gf", desc = "📄 File History", category = "🔀 Git Operations" },
    { key = "<leader>gs", desc = "📋 Git Status", category = "🔀 Git Operations" },
    { key = "<leader>gb", desc = "🌿 Git Branches", category = "🔀 Git Operations" },

    -- Debug Operations
    { key = "<leader>db", desc = "🔴 Toggle Breakpoint", category = "🔧 Debug Operations" },
    { key = "<leader>dB", desc = "🔶 Conditional Breakpoint", category = "🔧 Debug Operations" },
    { key = "<leader>dc", desc = "▶️ Continue", category = "🔧 Debug Operations" },
    { key = "<leader>di", desc = "⬇️ Step Into", category = "🔧 Debug Operations" },
    { key = "<leader>do", desc = "➡️ Step Over", category = "🔧 Debug Operations" },
    { key = "<leader>dO", desc = "⬆️ Step Out", category = "🔧 Debug Operations" },
    { key = "<leader>dr", desc = "💻 Toggle REPL", category = "🔧 Debug Operations" },
    { key = "<leader>dl", desc = "🔄 Run Last", category = "🔧 Debug Operations" },
    { key = "<leader>dt", desc = "⏹️ Terminate", category = "🔧 Debug Operations" },
    { key = "<leader>du", desc = "🖥️ Toggle UI", category = "🔧 Debug Operations" },
    { key = "<leader>de", desc = "🔍 Evaluate", category = "🔧 Debug Operations" },

    -- Harpoon Navigation
    { key = "<leader>ha", desc = "➕ Add File", category = "⚡ Harpoon Navigation" },
    { key = "<leader>hm", desc = "📋 Menu", category = "⚡ Harpoon Navigation" },
    { key = "<leader>h1", desc = "1️⃣ File 1", category = "⚡ Harpoon Navigation" },
    { key = "<leader>h2", desc = "2️⃣ File 2", category = "⚡ Harpoon Navigation" },
    { key = "<leader>h3", desc = "3️⃣ File 3", category = "⚡ Harpoon Navigation" },
    { key = "<leader>h4", desc = "4️⃣ File 4", category = "⚡ Harpoon Navigation" },
    { key = "<leader>hn", desc = "⏭️ Next", category = "⚡ Harpoon Navigation" },
    { key = "<leader>hp", desc = "⏮️ Previous", category = "⚡ Harpoon Navigation" },
    { key = "<C-h>", desc = "📋 Quick Menu", category = "⚡ Harpoon Navigation" },
    { key = "<C-j>", desc = "1️⃣ Quick File 1", category = "⚡ Harpoon Navigation" },
    { key = "<C-k>", desc = "2️⃣ Quick File 2", category = "⚡ Harpoon Navigation" },
    { key = "<C-l>", desc = "3️⃣ Quick File 3", category = "⚡ Harpoon Navigation" },

    -- Search & Replace
    { key = "<leader>S", desc = "🔄 Global Search/Replace", category = "🔍 Search & Replace" },
    { key = "<leader>sw", desc = "🔤 Search Word", category = "🔍 Search & Replace" },
    { key = "<leader>sp", desc = "📄 Search in File", category = "🔍 Search & Replace" },

    -- Diagnostics & Trouble
    { key = "<leader>xx", desc = "🔧 Toggle Trouble", category = "🚨 Diagnostics" },
    { key = "<leader>xw", desc = "🌐 Workspace Diagnostics", category = "🚨 Diagnostics" },
    { key = "<leader>xd", desc = "📄 Document Diagnostics", category = "🚨 Diagnostics" },
    { key = "<leader>xl", desc = "📋 Location List", category = "🚨 Diagnostics" },
    { key = "<leader>xq", desc = "🔧 Quickfix", category = "🚨 Diagnostics" },
    { key = "gR", desc = "🔍 LSP References", category = "🚨 Diagnostics" },

    -- Terminal Operations
    { key = "<leader>tf", desc = "🎈 Float Terminal", category = "💻 Terminal" },
    { key = "<leader>tv", desc = "📏 Vertical Terminal", category = "💻 Terminal" },
    { key = "<leader>ts", desc = "📐 Horizontal Terminal", category = "💻 Terminal" },
    { key = "<leader>tg", desc = "🔀 LazyGit", category = "💻 Terminal" },
    { key = "<leader>tp", desc = "🐍 Python REPL", category = "💻 Terminal" },
    { key = "<leader>tn", desc = "📜 Node REPL", category = "💻 Terminal" },
    { key = "<leader>th", desc = "📊 System Monitor", category = "💻 Terminal" },
    { key = "<C-\\>", desc = "💻 Toggle Terminal", category = "💻 Terminal" },

    -- Notifications
    { key = "<leader>nh", desc = "📜 History", category = "📢 Notifications" },
    { key = "<leader>nd", desc = "🔕 Dismiss All", category = "📢 Notifications" },

    -- UI Controls
    { key = "<leader>ct", desc = "🌈 Toggle Colorizer", category = "🎨 UI Controls" },
    { key = "<leader>cr", desc = "🔄 Reload Colorizer", category = "🎨 UI Controls" },

    -- LSP Operations
    { key = "<leader>la", desc = "💡 Code Action", category = "🔧 LSP" },
    { key = "<leader>ld", desc = "🚨 Diagnostics", category = "🔧 LSP" },
    { key = "<leader>lf", desc = "🎨 Format", category = "🔧 LSP" },
    { key = "<leader>li", desc = "ℹ️ Info", category = "🔧 LSP" },
    { key = "<leader>lI", desc = "🔧 Mason", category = "🔧 LSP" },
    { key = "<leader>lj", desc = "⬇️ Next Diagnostic", category = "🔧 LSP" },
    { key = "<leader>lk", desc = "⬆️ Prev Diagnostic", category = "🔧 LSP" },
    { key = "<leader>ll", desc = "🔍 CodeLens Action", category = "🔧 LSP" },
    { key = "<leader>lq", desc = "📋 Quickfix", category = "🔧 LSP" },
    { key = "<leader>lr", desc = "📝 Rename", category = "🔧 LSP" },
    { key = "<leader>ls", desc = "📄 Document Symbols", category = "🔧 LSP" },
    { key = "<leader>lS", desc = "🌐 Workspace Symbols", category = "🔧 LSP" },
    { key = "<leader>le", desc = "🔧 Telescope Quickfix", category = "🔧 LSP" },
    { key = "gd", desc = "📍 Go to Definition", category = "🔧 LSP" },
    { key = "gD", desc = "📋 Go to Declaration", category = "🔧 LSP" },
    { key = "gi", desc = "🔧 Go to Implementation", category = "🔧 LSP" },
    { key = "gt", desc = "🏷️ Go to Type Definition", category = "🔧 LSP" },
    { key = "K", desc = "❓ Hover Documentation", category = "🔧 LSP" },
    { key = "<C-k>", desc = "✍️ Signature Help", category = "🔧 LSP" },
    { key = "[d", desc = "⬆️ Previous Diagnostic", category = "🔧 LSP" },
    { key = "]d", desc = "⬇️ Next Diagnostic", category = "🔧 LSP" },

    -- Buffer Operations
    { key = "<leader>bj", desc = "🎯 Jump to Buffer", category = "📑 Buffer Operations" },
    { key = "<leader>bf", desc = "🔍 Find Buffer", category = "📑 Buffer Operations" },
    { key = "<leader>bb", desc = "⬅️ Previous Buffer", category = "📑 Buffer Operations" },
    { key = "<leader>bn", desc = "➡️ Next Buffer", category = "📑 Buffer Operations" },
    { key = "<leader>be", desc = "❌ Pick Close", category = "📑 Buffer Operations" },
    { key = "<leader>bh", desc = "⬅️❌ Close Left", category = "📑 Buffer Operations" },
    { key = "<leader>bl", desc = "➡️❌ Close Right", category = "📑 Buffer Operations" },
    { key = "<leader>bD", desc = "📁 Sort by Directory", category = "📑 Buffer Operations" },
    { key = "<leader>bL", desc = "📄 Sort by Language", category = "📑 Buffer Operations" },
    { key = "<S-h>", desc = "⬅️ Previous Buffer", category = "📑 Buffer Operations" },
    { key = "<S-l>", desc = "➡️ Next Buffer", category = "📑 Buffer Operations" },

    -- Window Operations
    { key = "<leader>ww", desc = "🔄 Other Window", category = "🪟 Window Operations" },
    { key = "<leader>wd", desc = "❌ Delete Window", category = "🪟 Window Operations" },
    { key = "<leader>w-", desc = "➖ Split Below", category = "🪟 Window Operations" },
    { key = "<leader>w|", desc = "➗ Split Right", category = "🪟 Window Operations" },
    { key = "<leader>w2", desc = "2️⃣ Layout Double Columns", category = "🪟 Window Operations" },
    { key = "<leader>wh", desc = "⬅️ Go Left", category = "🪟 Window Operations" },
    { key = "<leader>wj", desc = "⬇️ Go Down", category = "🪟 Window Operations" },
    { key = "<leader>wk", desc = "⬆️ Go Up", category = "🪟 Window Operations" },
    { key = "<leader>wl", desc = "➡️ Go Right", category = "🪟 Window Operations" },
    { key = "<leader>wH", desc = "⬅️ Expand Left", category = "🪟 Window Operations" },
    { key = "<leader>wJ", desc = "⬇️ Expand Down", category = "🪟 Window Operations" },
    { key = "<leader>wK", desc = "⬆️ Expand Up", category = "🪟 Window Operations" },
    { key = "<leader>wL", desc = "➡️ Expand Right", category = "🪟 Window Operations" },
    { key = "<leader>w=", desc = "⚖️ Balance", category = "🪟 Window Operations" },

    -- Quick Actions
    { key = "<leader>qq", desc = "❌ Quit All", category = "⚡ Quick Actions" },
    { key = "<leader>qw", desc = "💾❌ Save & Quit All", category = "⚡ Quick Actions" },
    { key = "<leader>qr", desc = "🔄 Restore Session", category = "⚡ Quick Actions" },
    { key = "<leader>ql", desc = "📚 Load Last Session", category = "⚡ Quick Actions" },
    { key = "<leader>qd", desc = "🛑 Don't Save Session", category = "⚡ Quick Actions" },

    -- File Tree
    { key = "<leader>e", desc = "🌳 Toggle File Tree", category = "📁 File Operations" },
    { key = "<leader>E", desc = "🌳 Focus File Tree", category = "📁 File Operations" },

    -- Commenting
    { key = "gcc", desc = "💬 Comment Line", category = "✏️ Text Operations" },
    { key = "gc", desc = "💬 Comment Selection", category = "✏️ Text Operations" },
    { key = "gbc", desc = "💬 Block Comment", category = "✏️ Text Operations" },

    -- Surround Operations
    { key = "ys", desc = "🔄 Add Surround", category = "✏️ Text Operations" },
    { key = "ds", desc = "❌ Delete Surround", category = "✏️ Text Operations" },
    { key = "cs", desc = "🔄 Change Surround", category = "✏️ Text Operations" },

    -- General Vim
    { key = "u", desc = "↩️ Undo", category = "✏️ Text Operations" },
    { key = "<C-r>", desc = "↪️ Redo", category = "✏️ Text Operations" },
    { key = "yy", desc = "📋 Copy Line", category = "✏️ Text Operations" },
    { key = "dd", desc = "✂️ Cut Line", category = "✏️ Text Operations" },
    { key = "p", desc = "📋 Paste After", category = "✏️ Text Operations" },
    { key = "P", desc = "📋 Paste Before", category = "✏️ Text Operations" },
    { key = "/", desc = "🔍 Search Forward", category = "🔍 Search & Replace" },
    { key = "?", desc = "🔍 Search Backward", category = "🔍 Search & Replace" },
    { key = "n", desc = "⏭️ Next Search", category = "🔍 Search & Replace" },
    { key = "N", desc = "⏮️ Previous Search", category = "🔍 Search & Replace" },
    { key = "*", desc = "🔍 Search Word Forward", category = "🔍 Search & Replace" },
    { key = "#", desc = "🔍 Search Word Backward", category = "🔍 Search & Replace" },
  }

  -- Format entries for display
  local formatted_entries = {}
  for _, cmd in ipairs(all_commands) do
    table.insert(formatted_entries, {
      display = string.format("%-20s %-40s %s", cmd.key, cmd.desc, cmd.category),
      ordinal = cmd.key .. " " .. cmd.desc .. " " .. cmd.category,
      value = cmd
    })
  end

  pickers.new({}, {
    prompt_title = "🚀 Ultimate Neovim Commands - All Keybindings",
    finder = finders.new_table({
      results = formatted_entries,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.display,
          ordinal = entry.ordinal,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.notify("Command: " .. selection.value.key .. " - " .. selection.value.desc, vim.log.levels.INFO)
        end
      end)
      return true
    end,
  }):find()
end

-- Setup keybinding
vim.keymap.set("n", "<leader>?", M.show_all_commands, { desc = "🆘 Show All Commands" })
vim.keymap.set("n", "<F1>", M.show_all_commands, { desc = "🆘 Show All Commands" })

return M