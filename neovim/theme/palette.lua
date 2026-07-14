-- Greyscale palette — single source of truth for every UI surface in nvim
-- (theme/colours.lua highlight overrides, plugins/lualine.lua statusline).
-- The zsh prompt and tmux status bar use the matching 256-colour indices
-- noted below (see terminal/zshrc and terminal/tmux.conf).
return {
  brightest = "#bcbcbc", -- 250 · primary text, current line number
  bright    = "#949494", -- 246 · highlights, folder icons, git marks
  mid       = "#767676", -- 243 · secondary text, shortcuts, arrows
  dim       = "#4e4e4e", -- 239 · selections, added lines, separators
  faint     = "#3a3a3a", -- 237 · statusline, subtle tints
  subtle    = "#303030", --       cursor line/column, sign column tint
  darkest   = "#262626", -- 235 · popup background, text on light greys
}
