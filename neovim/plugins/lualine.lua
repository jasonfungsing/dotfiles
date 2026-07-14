-- Lualine Configuration
-- Modern statusline with LSP integration

-- Greyscale theme matching the zsh prompt greys: every vim mode uses the
-- same grey ramp (from theme/palette.lua) instead of gruvbox's per-mode
-- accent colours (green command mode, blue insert, …)
local c = require("theme.palette")
local grey = {
  a = { fg = c.darkest, bg = c.bright, gui = "bold" },
  b = { fg = c.brightest, bg = c.dim },
  c = { fg = c.bright, bg = c.faint },
}
local greyscale_theme = {
  normal = grey,
  insert = grey,
  visual = grey,
  replace = grey,
  command = grey,
  terminal = grey,
  inactive = {
    a = { fg = c.mid, bg = c.faint },
    b = { fg = c.mid, bg = c.faint },
    c = { fg = c.mid, bg = c.faint },
  },
}

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = greyscale_theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {"filename"},
    lualine_x = {
      {
        "encoding",
        cond = function()
          return vim.bo.fileencoding ~= "utf-8"
        end,
      },
      "fileformat",
      "filetype"
    },
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {"nvim-tree", "fugitive"}
})
