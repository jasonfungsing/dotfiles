-- Statusline Configuration
-- Custom statusline with powerline-style arrows and highlights

local function set_statusline_highlights()
  -- Mode section (blue)
  vim.api.nvim_set_hl(0, 'StlMode', { bg = '#89b4fa', fg = '#1e1e2e', bold = true })
  vim.api.nvim_set_hl(0, 'StlModeArrow', { fg = '#89b4fa', bg = '#45475a' })

  -- Branch section (dark gray)
  vim.api.nvim_set_hl(0, 'StlBranch', { bg = '#45475a', fg = '#89b4fa' })
  vim.api.nvim_set_hl(0, 'StlBranchArrow', { fg = '#45475a', bg = '#313244' })

  -- File section (darker gray)
  vim.api.nvim_set_hl(0, 'StlFile', { bg = '#313244', fg = '#cdd6f4' })

  -- Right side info (medium gray)
  vim.api.nvim_set_hl(0, 'StlInfo', { bg = '#45475a', fg = '#cdd6f4' })

  -- Time section (blue)
  vim.api.nvim_set_hl(0, 'StlTimeArrow', { fg = '#89b4fa', bg = '#45475a' })
  vim.api.nvim_set_hl(0, 'StlTime', { bg = '#89b4fa', fg = '#1e1e2e', bold = true })
end

-- Set highlights now
set_statusline_highlights()

-- Re-apply after colourscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_statusline_highlights,
})

-- Set the statusline with powerline arrows
vim.opt.statusline = table.concat({
  '%#StlMode#',
  ' %{toupper(mode())} ',
  '%#StlModeArrow#',
  '',  -- Powerline arrow (requires patched font)
  '%#StlBranch#',
  ' %{get(b:,"gitsigns_head","")} ',
  '%#StlBranchArrow#',
  '',
  '%#StlFile#',
  ' %f %m',
  '%=',  -- Right align from here
  '%#StlInfo#',
  ' 󰀘 ',  -- User icon
  ' %{&spelllang} ',  -- Language/spell
  ' 󰆧 %{line(".")-line("w0")+1} ',  -- Lines from top
  ' %p%% ',
  ' %l:%c ',
  '%#StlTimeArrow#',
  '',
  '%#StlTime#',
  '  %{strftime("%H:%M")} ',
})
