-- LSP Configuration
-- Modern Native Neovim LSP setup (0.11+)

-- Setup LSP capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP keymaps (applied when LSP attaches to buffer). Only maps that don't
-- shadow global keys: formatting is conform's <leader>mp, the diagnostic
-- float is <leader>xf, and K / [d / ]d / grn / gra / grr / gri are nvim
-- built-in defaults. <C-k> stays free for window navigation.
local on_attach = function(client, bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- LSP navigation
  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("gi", vim.lsp.buf.implementation, "Go to implementation")
  map("gr", vim.lsp.buf.references, "LSP references")
  map("gt", vim.lsp.buf.type_definition, "Go to type definition")

  -- Code actions and refactoring
  map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")

  -- Workspace management
  map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
end

-- Configure diagnostics display
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  float = {
    source = "always",
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Modern LSP server configurations using vim.lsp.config
local servers = {
  -- Lua Language Server
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
  
  -- Python
  pyright = {},
  
  -- TypeScript/JavaScript (updated from deprecated tsserver)
  ts_ls = {},
  
  -- Go
  gopls = {},
  
  -- Rust
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
  
  -- JSON
  jsonls = {},
  
  -- YAML
  yamlls = {},
  
  -- HTML
  html = {},
  
  -- CSS
  cssls = {},
  
  -- Bash
  bashls = {},
}

-- Setup each LSP server using modern vim.lsp.config API
for server_name, config in pairs(servers) do
  -- Merge default config with server-specific config
  local server_config = vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach = on_attach,
  }, config)
  
  -- Use modern vim.lsp.config API (Neovim 0.11+)
  vim.lsp.config(server_name, server_config)
end