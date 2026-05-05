-- Treesitter Configuration
-- Modern syntax highlighting and code understanding

-- Check if treesitter is available before configuring
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  -- Silently return if treesitter is not installed yet
  -- This prevents error messages during initial setup
  return
end

configs.setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "javascript",
    "typescript",
    "python",
    "go",
    "rust",
    "html",
    "css",
    "json",
    "yaml",
    "toml",
    "markdown",
    "markdown_inline",
    "bash",
    "dockerfile",
    "gitignore",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    enable = true,
    -- list of language that will be disabled
    disable = {},
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },
})

-- Enable folding based on treesitter (with fallback)
pcall(function()
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldenable = false -- Disable folding at startup
end)