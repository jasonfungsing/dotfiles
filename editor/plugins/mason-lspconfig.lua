-- Mason LSP Configuration
-- Automatic LSP server installation and management

require("mason-lspconfig").setup({
  -- Ensure these servers are installed
  ensure_installed = {
    "lua_ls",
    "pyright",
    "ts_ls",
    "gopls",
    "rust_analyzer",
    "jsonls",
    "yamlls",
    "html",
    "cssls",
    "bashls",
  },
  
  -- Automatically install servers configured in lspconfig
  automatic_installation = true,
})