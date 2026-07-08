-- Nvim-Surround Configuration
-- Modern text object manipulation for quotes, brackets, tags, etc.
-- Updated for nvim-surround v4+ (no longer uses setup function for keymaps)

local status_ok, surround = pcall(require, "nvim-surround")
if not status_ok then
  vim.notify("nvim-surround not found!", vim.log.levels.ERROR)
  return
end

-- For nvim-surround v4+, keymaps are set automatically
-- No need to configure keymaps in setup function
surround.setup({
  aliases = {
    ["a"] = ">",
    ["b"] = ")",
    ["B"] = "}",
    ["r"] = "]",
    ["q"] = { '"', "'", "`" },
    ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
  },
  highlight = {
    duration = 0,
  },
  move_cursor = "begin",
  indent_lines = function(start, stop)
    local b = vim.bo
    -- Only re-indent the selection if a formatter is set up already
    if start < stop and (b.equalprg ~= "" or b.indentexpr ~= "" or b.cindent or b.smartindent or b.lisp) then
      vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
    end
  end,
})

-- Default keymaps (automatically set by nvim-surround v4+):
-- Normal mode:
--   ys{motion}{addition} - Add surround
--   yss{addition}        - Add surround to entire line
--   yS{motion}{addition} - Add surround on new lines
--   ySS{addition}        - Add surround to entire line on new lines
--   ds{deletion}         - Delete surround
--   cs{target}{replacement} - Change surround
--   cS{target}{replacement} - Change surround on new lines
--
-- Visual mode:
--   S{addition}          - Add surround to selection
--   gS{addition}         - Add surround to selection on new lines
--
-- Insert mode:
--   <C-g>s{addition}     - Add surround
--   <C-g>S{addition}     - Add surround on new lines