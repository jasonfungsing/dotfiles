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

  -- Messages: errors/warnings/prompts in the message area render as grey
  -- blocks instead of gruvbox red/yellow/green
  hl(0, "ErrorMsg", { fg = c.brightest, bg = c.dim, bold = true })
  hl(0, "WarningMsg", { fg = c.brightest, bg = c.dim })
  hl(0, "Error", { fg = c.brightest, bg = c.dim, bold = true })
  hl(0, "MoreMsg", { fg = c.bright, bold = true })
  hl(0, "ModeMsg", { fg = c.bright, bold = true })
  hl(0, "Question", { fg = c.bright, bold = true })
  hl(0, "Conceal", { fg = c.mid })
  hl(0, "VertSplit", { fg = c.dim })
  hl(0, "Added", { fg = c.bright })
  hl(0, "Changed", { fg = c.bright })
  hl(0, "Removed", { fg = c.mid })

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

  -- Core editor UI: search, selection, folds, tabs, titles — grey levels
  -- instead of gruvbox accents
  hl(0, "Search", { fg = c.darkest, bg = c.bright })
  hl(0, "IncSearch", { fg = c.darkest, bg = c.brightest, bold = true })
  hl(0, "CurSearch", { fg = c.darkest, bg = c.brightest, bold = true })
  hl(0, "Visual", { bg = c.dim })
  hl(0, "MatchParen", { bg = c.mid, bold = true })
  hl(0, "Folded", { fg = c.mid, bg = c.subtle })
  hl(0, "TabLine", { fg = c.mid, bg = c.faint })
  hl(0, "TabLineSel", { fg = c.brightest, bg = c.dim })
  hl(0, "TabLineFill", { bg = c.faint })
  hl(0, "WildMenu", { fg = c.brightest, bg = c.dim })
  hl(0, "QuickFixLine", { bg = c.subtle })
  hl(0, "Directory", { fg = c.brightest })
  hl(0, "Title", { fg = c.bright, bold = true })
  hl(0, "EndOfBuffer", { fg = c.dim })
  hl(0, "NonText", { fg = c.dim })
  hl(0, "Whitespace", { fg = c.dim })
  hl(0, "SpecialKey", { fg = c.dim })
  hl(0, "WinBar", { fg = c.brightest, bg = c.faint })
  hl(0, "WinBarNC", { fg = c.mid, bg = c.faint })

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

-- ── Automatic desaturation for every other plugin UI ────────────────────
-- The explicit groups above are the designed surfaces; every remaining
-- plugin UI is handled generically: any highlight group starting with one
-- of these prefixes has its colours converted to their grey luminance
-- equivalent. Plugins keep their brightness design (selected vs dimmed,
-- error vs hint) but lose all hue. New plugins: add their prefix here.
local ui_prefixes = {
  "Telescope", "WhichKey", "Notify", "Lazy", "Mason", "BufferLine",
  "Aerial", "Trouble", "Ibl", "IndentBlankline", "Dap", "Spectre",
  "Diffview", "Harpoon", "ToggleTerm", "Diagnostic",
  "Float", "NormalFloat",
  "NvimTree", "CmpItem", "GitSigns", "@ibl", "Spell", "lualine_",
}

local function to_grey(color)
  if not color then return nil end
  local r = math.floor(color / 65536) % 256
  local g = math.floor(color / 256) % 256
  local b = color % 256
  local y = math.floor(0.299 * r + 0.587 * g + 0.114 * b + 0.5)
  return y * 65536 + y * 256 + y
end

local function desaturate_plugin_ui()
  for name in pairs(vim.api.nvim_get_hl(0, {})) do
    for _, prefix in ipairs(ui_prefixes) do
      if name:sub(1, #prefix) == prefix then
        local h = vim.api.nvim_get_hl(0, { name = name, link = false })
        if h.fg or h.bg or h.sp then
          h.fg, h.bg, h.sp = to_grey(h.fg), to_grey(h.bg), to_grey(h.sp)
          h.default = nil
          vim.api.nvim_set_hl(0, name, h)
        end
        break
      end
    end
  end
end

local function apply_greyscale()
  greyscale_ui()
  desaturate_plugin_ui()
end

apply_greyscale()
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Re-apply greyscale UI after any colorscheme change",
  callback = apply_greyscale,
})
-- Lazy-loaded plugins define their highlight groups only when they load —
-- desaturate again after each one comes in
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  desc = "Desaturate highlight groups of freshly lazy-loaded plugins",
  callback = function()
    vim.schedule(desaturate_plugin_ui)
  end,
})
