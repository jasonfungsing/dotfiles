-- LuaSnip Configuration
-- Modern snippet engine

local luasnip = require("luasnip")

-- Load snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Custom snippets can be added here
luasnip.config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

-- Key mappings for snippet navigation
vim.keymap.set({"i", "s"}, "<C-l>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-h>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, {silent = true})

vim.keymap.set("i", "<C-k>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, {silent = true})