-- Which-Key Configuration
-- Ultimate help system showing all available commands in organized categories

local status_ok, wk = pcall(require, "which-key")
if not status_ok then
  return
end

wk.setup({
  preset = "helix",
  delay = 999999,
  win = {
    border = "rounded",
    padding = { 2, 4 },
    title = "🚀 Ultimate Neovim Commands",
    title_pos = "center",
    width = 0.8,
    height = 0.8,
  },
  layout = {
    width = { min = 20, max = 50 },
    spacing = 3,
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
    ellipsis = "…",
    mappings = true,
    rules = false,
  },
  show_help = true,
  show_keys = true,
  disable = {
    buftypes = {},
    filetypes = {},
  },
})

-- Comprehensive command registration with beautiful organization
wk.add({
  -- Main help command
  { ",,", "<cmd>WhichKey<cr>", desc = "🆘 Show All Commands", mode = "n" },
  { "<F1>", "<cmd>WhichKey<cr>", desc = "🆘 Show All Commands", mode = "n" },

  -- File Operations
  { "<leader>f", group = "📁 File Operations" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "🔍 Find Files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "🔤 Live Grep" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "📑 Buffers" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "❓ Help Tags" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "📚 Recent Files" },
  { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "⚙️ Commands" },
  { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "🔑 Keymaps" },

  -- Git Operations
  { "<leader>g", group = "🔀 Git Operations" },
  { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "📊 Git Diff View" },
  { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "📜 Git History" },
  { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "❌ Close Diff" },
  { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "📄 File History" },
  { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "📋 Git Status" },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "🌿 Git Branches" },

  -- Debug Operations
  { "<leader>d", group = "🔧 Debug Operations" },
  { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "🔴 Toggle Breakpoint" },
  { "<leader>dB", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "🔶 Conditional Breakpoint" },
  { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "▶️ Continue" },
  { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "⬇️ Step Into" },
  { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "➡️ Step Over" },
  { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "⬆️ Step Out" },
  { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "💻 Toggle REPL" },
  { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "🔄 Run Last" },
  { "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", desc = "⏹️ Terminate" },
  { "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "🖥️ Toggle UI" },
  { "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", desc = "🔍 Evaluate", mode = { "n", "v" } },

  -- Harpoon Navigation
  { "<leader>h", group = "⚡ Harpoon Navigation" },
  { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "➕ Add File" },
  { "<leader>hm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "📋 Menu" },
  { "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "1️⃣ File 1" },
  { "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "2️⃣ File 2" },
  { "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "3️⃣ File 3" },
  { "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "4️⃣ File 4" },
  { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "⏭️ Next" },
  { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "⏮️ Previous" },

  -- Search & Replace
  { "<leader>s", group = "🔍 Search & Replace" },
  { "<leader>S", "<cmd>lua require('spectre').toggle()<cr>", desc = "🔄 Global Search/Replace" },
  { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", desc = "🔤 Search Word" },
  { "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>", desc = "📄 Search in File" },

  -- Diagnostics & Trouble
  { "<leader>x", group = "🚨 Diagnostics" },
  { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "🔧 Toggle Trouble" },
  { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "🌐 Workspace Diagnostics" },
  { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "📄 Document Diagnostics" },
  { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "📋 Location List" },
  { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "🔧 Quickfix" },

  -- Terminal Operations
  { "<leader>t", group = "💻 Terminal" },
  { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "🎈 Float Terminal" },
  { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "📏 Vertical Terminal" },
  { "<leader>ts", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "📐 Horizontal Terminal" },
  { "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "🔀 LazyGit" },
  { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "🐍 Python REPL" },
  { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "📜 Node REPL" },
  { "<leader>th", "<cmd>lua _HTOP_TOGGLE()<cr>", desc = "📊 System Monitor" },

  -- Notifications
  { "<leader>n", group = "📢 Notifications" },
  { "<leader>nh", "<cmd>lua require('notify').history()<cr>", desc = "📜 History" },
  { "<leader>nd", "<cmd>lua require('notify').dismiss({ silent = true, pending = true })<cr>", desc = "🔕 Dismiss All" },

  -- UI Controls
  { "<leader>u", group = "🎨 UI Controls" },
  { "<leader>ct", "<cmd>ColorizerToggle<cr>", desc = "🌈 Toggle Colorizer" },
  { "<leader>cr", "<cmd>ColorizerReloadAllBuffers<cr>", desc = "🔄 Reload Colorizer" },

  -- LSP Operations
  { "<leader>l", group = "🔧 LSP" },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "💡 Code Action" },
  { "<leader>ld", "<cmd>Telescope diagnostics<cr>", desc = "🚨 Diagnostics" },
  { "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", desc = "🎨 Format" },
  { "<leader>li", "<cmd>LspInfo<cr>", desc = "ℹ️ Info" },
  { "<leader>lI", "<cmd>Mason<cr>", desc = "🔧 Mason" },
  { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "⬇️ Next Diagnostic" },
  { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "⬆️ Prev Diagnostic" },
  { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "🔍 CodeLens Action" },
  { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "📋 Quickfix" },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "📝 Rename" },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "📄 Document Symbols" },
  { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "🌐 Workspace Symbols" },
  { "<leader>le", "<cmd>Telescope quickfix<cr>", desc = "🔧 Telescope Quickfix" },

  -- Buffer Operations
  { "<leader>b", group = "📑 Buffer Operations" },
  { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "🎯 Jump to Buffer" },
  { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "🔍 Find Buffer" },
  { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "⬅️ Previous Buffer" },
  { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "➡️ Next Buffer" },
  { "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "❌ Pick Close" },
  { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "⬅️❌ Close Left" },
  { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "➡️❌ Close Right" },
  { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "📁 Sort by Directory" },
  { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "📄 Sort by Language" },

  -- Window Operations
  { "<leader>w", group = "🪟 Window Operations" },
  { "<leader>ww", "<C-W>p", desc = "🔄 Other Window" },
  { "<leader>wd", "<C-W>c", desc = "❌ Delete Window" },
  { "<leader>w-", "<C-W>s", desc = "➖ Split Below" },
  { "<leader>w|", "<C-W>v", desc = "➗ Split Right" },
  { "<leader>w2", "<C-W>v", desc = "2️⃣ Layout Double Columns" },
  { "<leader>wh", "<C-W>h", desc = "⬅️ Go Left" },
  { "<leader>wj", "<C-W>j", desc = "⬇️ Go Down" },
  { "<leader>wk", "<C-W>k", desc = "⬆️ Go Up" },
  { "<leader>wl", "<C-W>l", desc = "➡️ Go Right" },
  { "<leader>wH", "<C-W>5<", desc = "⬅️ Expand Left" },
  { "<leader>wJ", ":resize +5<cr>", desc = "⬇️ Expand Down" },
  { "<leader>wK", ":resize -5<cr>", desc = "⬆️ Expand Up" },
  { "<leader>wL", "<C-W>5>", desc = "➡️ Expand Right" },
  { "<leader>w=", "<C-W>=", desc = "⚖️ Balance" },

  -- Quick Actions
  { "<leader>q", group = "⚡ Quick Actions" },
  { "<leader>qq", "<cmd>qa<cr>", desc = "❌ Quit All" },
  { "<leader>qw", "<cmd>wqa<cr>", desc = "💾❌ Save & Quit All" },
  { "<leader>qr", "<cmd>lua require('persistence').load()<cr>", desc = "🔄 Restore Session" },
  { "<leader>ql", "<cmd>lua require('persistence').load({ last = true })<cr>", desc = "📚 Load Last Session" },
  { "<leader>qd", "<cmd>lua require('persistence').stop()<cr>", desc = "🛑 Don't Save Session" },
})

-- Additional non-leader keybindings
wk.add({
  { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "🔍 LSP References" },
  { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "📍 Go to Definition" },
  { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "📋 Go to Declaration" },
  { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "🔧 Go to Implementation" },
  { "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "🏷️ Go to Type Definition" },
  { "K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "❓ Hover Documentation" },
  { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "✍️ Signature Help" },
  { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "⬆️ Previous Diagnostic" },
  { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "⬇️ Next Diagnostic" },
  { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "⬅️ Previous Buffer" },
  { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "➡️ Next Buffer" },
  { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "💻 Toggle Terminal", mode = { "n", "t" } },
})

-- Visual mode mappings
wk.add({
  { "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<cr>", desc = "🔍 Search Selection", mode = "v" },
  { "<leader>de", "<cmd>lua require('dapui').eval()<cr>", desc = "🔍 Debug Evaluate", mode = "v" },
})
