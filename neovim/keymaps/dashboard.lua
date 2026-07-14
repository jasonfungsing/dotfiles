-- Dashboard Key Mappings
-- Global access to Alpha dashboard shortcuts using leader key

local function nmap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Dashboard shortcuts accessible anywhere in Neovim
nmap("<leader>n", ":ene <BAR> startinsert <CR>", "New file")
nmap("<leader>f", ":Telescope find_files <CR>", "Find files")
nmap("<leader>r", ":Telescope oldfiles <CR>", "Recent files")
nmap("<leader>w", ":Telescope live_grep <CR>", "Live grep")
nmap("<leader>c", ":e ~/.config/nvim/init.lua <CR>", "Edit nvim config")
nmap("<leader>s", ":lua require('persistence').load() <CR>", "Restore session")
nmap("<leader>l", ":Lazy <CR>", "Lazy plugin manager")
nmap("<leader>m", ":Mason <CR>", "Mason LSP installer")
nmap("<leader>q", ":qa <CR>", "Quit all")