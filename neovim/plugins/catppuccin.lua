-- Catppuccin Colorscheme Configuration
-- Modern, beautiful colorscheme with multiple variants

local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
  vim.notify("catppuccin not found!", vim.log.levels.ERROR)
  return
end

catppuccin.setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = true,
    mini = false,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    alpha = true,
    bufferline = true,
    dap = {
      enabled = true,
      enable_ui = true, -- enable nvim-dap-ui
    },
    harpoon = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    lsp_trouble = true,
    mason = true,
    telescope = {
      enabled = true,
      -- style = "nvchad"
    },
    which_key = true,
  },
})

-- Setup the colorscheme
vim.cmd.colorscheme "catppuccin"