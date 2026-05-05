-- Colorizer Configuration
-- Show actual colors for hex codes, CSS colors, and more

local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  vim.notify("nvim-colorizer not found!", vim.log.levels.ERROR)
  return
end

colorizer.setup({
  filetypes = {
    "*", -- Highlight all files, but customize some others.
    css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
    html = { names = false }, -- Disable parsing "names" like Blue or Gray
    "!vim", -- Exclude vim from highlighting.
  },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue or blue
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = false, -- CSS rgb() and rgba() functions
    hsl_fn = false, -- CSS hsl() and hsla() functions
    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available modes for `mode`: foreground, background,  virtualtext
    mode = "background", -- Set the display mode.
    -- Available methods are false / true / "normal" / "lsp" / "both"
    -- True is same as normal
    tailwind = false, -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
    virtualtext = "■",
    -- update color values even if buffer is not focused
    -- example use: cmp_menu, cmp_docs
    always_update = false
  },
  -- all the sub-options of filetypes apply to buftypes
  buftypes = {},
})

-- Keymaps for colorizer
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Toggle colorizer
keymap("n", "<leader>ct", "<cmd>ColorizerToggle<cr>", opts)
keymap("n", "<leader>cr", "<cmd>ColorizerReloadAllBuffers<cr>", opts)