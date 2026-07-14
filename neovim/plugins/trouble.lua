-- Trouble Configuration (v3)
-- Better diagnostics, references, and quickfix lists.
-- Keymaps live in the lazy spec (plugins/init.lua) so pressing them
-- lazy-loads the plugin; v3 command syntax is `Trouble <mode> toggle`.

local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
  vim.notify("trouble.nvim not found!", vim.log.levels.ERROR)
  return
end

trouble.setup({
  -- v3 defaults are sensible; tweak here if needed (:h trouble.nvim)
  focus = true,        -- focus the window when opened
  auto_preview = true, -- preview the item under the cursor
})
