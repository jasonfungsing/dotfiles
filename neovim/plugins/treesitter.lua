-- Treesitter Configuration (main-branch rewrite, nvim 0.12+)
-- The plugin now only manages parser installation; highlighting, indent
-- and folds are enabled per-buffer through nvim's native vim.treesitter.
-- Note: the old master-branch incremental selection module no longer
-- exists in the rewrite.

local status_ok, ts = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

ts.setup({})

-- Parsers to keep installed (async; no-op when already present).
-- Compiling needs the tree-sitter CLI (brew "tree-sitter").
local parsers = {
  "bash", "c", "css", "dockerfile", "gitignore", "go", "html",
  "javascript", "json", "lua", "markdown", "markdown_inline",
  "python", "query", "rust", "toml", "typescript", "vim", "vimdoc", "yaml",
}
ts.install(parsers)

-- Enable native highlighting and treesitter-driven indent per buffer
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if lang and pcall(vim.treesitter.language.add, lang) then
      pcall(vim.treesitter.start, ev.buf, lang)
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Folding based on treesitter (native foldexpr), folds open at startup
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false

-- ── Structural text objects (nvim-treesitter-textobjects, main branch) ──

local tobj_ok, tobj = pcall(require, "nvim-treesitter-textobjects")
if not tobj_ok then
  return
end

tobj.setup({
  select = { lookahead = true }, -- jump forward to the next textobject
  move = { set_jumps = true },   -- record in jumplist (C-o to go back)
})

local map = vim.keymap.set
local sel = require("nvim-treesitter-textobjects.select")
local mov = require("nvim-treesitter-textobjects.move")

local function select_obj(query)
  return function() sel.select_textobject(query, "textobjects") end
end

map({ "x", "o" }, "af", select_obj("@function.outer"), { desc = "around function" })
map({ "x", "o" }, "if", select_obj("@function.inner"), { desc = "inside function" })
map({ "x", "o" }, "ac", select_obj("@class.outer"), { desc = "around class" })
map({ "x", "o" }, "ic", select_obj("@class.inner"), { desc = "inside class" })
map({ "x", "o" }, "aa", select_obj("@parameter.outer"), { desc = "around argument" })
map({ "x", "o" }, "ia", select_obj("@parameter.inner"), { desc = "inside argument" })

map({ "n", "x", "o" }, "]f", function() mov.goto_next_start("@function.outer", "textobjects") end, { desc = "next function" })
map({ "n", "x", "o" }, "[f", function() mov.goto_previous_start("@function.outer", "textobjects") end, { desc = "previous function" })
map({ "n", "x", "o" }, "]c", function() mov.goto_next_start("@class.outer", "textobjects") end, { desc = "next class" })
map({ "n", "x", "o" }, "[c", function() mov.goto_previous_start("@class.outer", "textobjects") end, { desc = "previous class" })
