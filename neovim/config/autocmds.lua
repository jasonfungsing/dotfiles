-- Auto Commands
-- Event handlers and automatic actions

-- Automatically remove trailing whitespace before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd("%s/\\s\\+$//e")
  end,
})
