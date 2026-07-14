-- Colour Scheme and Visual Settings
-- gruvbox for syntax, greyscale for all UI chrome

-- Set colourscheme (gruvbox should be available after plugins install)
pcall(vim.cmd, "colorscheme gruvbox")

-- Greyscale UI chrome, matching the zsh prompt greys. All levels come from
-- theme/palette.lua — change the ramp there, not here. File-type icons
-- (DevIcon*) keep their colours; everything else renders in grey.
local c = require("theme.palette")

local function greyscale_ui()
  local hl = vim.api.nvim_set_hl

  -- Messages: errors/warnings in the message area render as grey blocks
  -- instead of gruvbox red/yellow
  hl(0, "ErrorMsg", { fg = c.brightest, bg = c.dim, bold = true })
  hl(0, "WarningMsg", { fg = c.brightest, bg = c.dim })

  -- Line numbers: current line pops in light grey, the rest stay dim
  hl(0, "LineNr", { fg = c.mid })
  hl(0, "CursorLineNr", { fg = c.brightest, bold = true })

  -- Completion popup (nvim-cmp): grey menu, selection, and item kinds
  hl(0, "Pmenu", { fg = c.bright, bg = c.darkest })
  hl(0, "PmenuSel", { fg = c.brightest, bg = c.dim, bold = true })
  hl(0, "PmenuSbar", { bg = c.faint })
  hl(0, "PmenuThumb", { bg = c.mid })
  hl(0, "CmpItemAbbr", { fg = c.bright })
  hl(0, "CmpItemAbbrDeprecated", { fg = c.mid, strikethrough = true })
  hl(0, "CmpItemAbbrMatch", { fg = c.brightest, bold = true })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = c.brightest, bold = true })
  hl(0, "CmpItemMenu", { fg = c.mid })
  hl(0, "CmpItemKind", { fg = c.mid })
  for _, kind in ipairs({
    "Text", "Method", "Function", "Constructor", "Field", "Variable",
    "Class", "Interface", "Module", "Property", "Unit", "Value", "Enum",
    "Keyword", "Snippet", "Color", "File", "Reference", "Folder",
    "EnumMember", "Constant", "Struct", "Event", "Operator", "TypeParameter",
  }) do
    hl(0, "CmpItemKind" .. kind, { link = "CmpItemKind" })
  end

  -- Gitsigns change bars in the sign column: grey instead of green/aqua/red
  for _, g in ipairs({ "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
    "GitSignsTopdelete", "GitSignsChangedelete", "GitSignsUntracked" }) do
    hl(0, g, { fg = c.bright })
  end

  -- Cursor line / column tints: pure grey instead of gruvbox's warm bg1
  hl(0, "CursorLine", { bg = c.subtle })
  hl(0, "CursorColumn", { bg = c.subtle })
  hl(0, "ColorColumn", { bg = c.subtle })

  -- Sign/fold columns: gruvbox tints their background warm — make them
  -- blend with the editor background
  hl(0, "SignColumn", { bg = "none" })
  hl(0, "CursorLineSign", { bg = c.subtle })
  hl(0, "FoldColumn", { bg = "none", fg = c.mid })

  -- Native statusline + window separator: lualine paints most cells, but
  -- junction cells and non-lualine windows fall back to these
  hl(0, "StatusLine", { fg = c.brightest, bg = c.faint })
  hl(0, "StatusLineNC", { fg = c.mid, bg = c.faint })
  hl(0, "WinSeparator", { fg = c.dim })

  -- Diff view (nvim -d, fugitive, diffview): grey levels instead of
  -- green/orange — changed text pops brightest, whole-line tints stay subtle
  hl(0, "DiffAdd", { bg = c.dim })
  hl(0, "DiffChange", { bg = c.faint })
  hl(0, "DiffText", { fg = c.darkest, bg = c.bright, bold = true })
  hl(0, "DiffDelete", { fg = c.mid, bg = c.darkest })

  -- Alpha dashboard (groups wired up in plugins/alpha.lua)
  hl(0, "AlphaHeader", { fg = c.bright })
  hl(0, "AlphaButtons", { fg = c.brightest })
  hl(0, "AlphaShortcut", { fg = c.mid })
  hl(0, "AlphaFooter", { fg = c.mid })

  -- nvim-tree text and folder icons in grey (per-filetype file icons from
  -- devicons keep their colours)
  -- Plain files with no dedicated group inherit NvimTreeNormal, so its fg
  -- must be grey too (bg preserved from the colorscheme)
  local tree_normal = vim.api.nvim_get_hl(0, { name = "NvimTreeNormal", link = false })
  hl(0, "NvimTreeNormal", { fg = c.brightest, bg = tree_normal.bg })
  hl(0, "NvimTreeFolderIcon", { fg = c.bright })
  hl(0, "NvimTreeOpenedFolderIcon", { fg = c.bright })
  hl(0, "NvimTreeClosedFolderIcon", { fg = c.bright })
  hl(0, "NvimTreeFolderArrowClosed", { fg = c.mid })
  hl(0, "NvimTreeFolderArrowOpen", { fg = c.mid })
  hl(0, "NvimTreeRootFolder", { fg = c.bright, bold = true })
  hl(0, "NvimTreeFolderName", { fg = c.brightest })
  hl(0, "NvimTreeOpenedFolderName", { fg = c.brightest })
  hl(0, "NvimTreeEmptyFolderName", { fg = c.brightest })
  hl(0, "NvimTreeSymlinkFolderName", { fg = c.brightest })
  hl(0, "NvimTreeExecFile", { fg = c.brightest })
  hl(0, "NvimTreeSpecialFile", { fg = c.brightest })
  hl(0, "NvimTreeImageFile", { fg = c.brightest })
  hl(0, "NvimTreeSymlink", { fg = c.brightest })
  hl(0, "NvimTreeModifiedFile", { fg = c.bright })

  -- nvim-tree git status marks (± ✓ ★ …) — grey, both legacy and
  -- current group names (unknown names are harmless)
  for _, state in ipairs({ "Dirty", "Staged", "New", "Deleted", "Renamed", "Merge", "Ignored" }) do
    hl(0, "NvimTreeGit" .. state, { fg = c.bright })
    hl(0, "NvimTreeGit" .. state .. "Icon", { fg = c.bright })
    hl(0, "NvimTreeGitFile" .. state .. "HL", { fg = c.brightest })
    hl(0, "NvimTreeGitFolder" .. state .. "HL", { fg = c.brightest })
  end
end

greyscale_ui()
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Re-apply greyscale UI chrome after any colorscheme change",
  callback = greyscale_ui,
})
