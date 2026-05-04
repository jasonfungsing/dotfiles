-- Colour Scheme and Visual Settings
-- Theme configuration and diff highlighting

-- Improve diff colours
vim.cmd [[
  hi DiffAdd    ctermfg=white ctermbg=22
  hi DiffDelete ctermfg=white ctermbg=52
  hi DiffChange ctermfg=white ctermbg=17
  hi DiffText   ctermfg=white ctermbg=18
]]

-- Set colourscheme (gruvbox should be available after plugins install)
pcall(vim.cmd, "colorscheme gruvbox")
