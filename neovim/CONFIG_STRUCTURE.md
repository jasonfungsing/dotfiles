# Neovim Configuration Structure

This document describes the modular organisation of the Neovim configuration.

## Directory Layout

```
neovim/
├── init.lua                    # Entry point - orchestrates all modules
├── CONFIG_STRUCTURE.md         # This file
├── config/
│   ├── core.lua               # Basic Vim options, leader key, indentation
│   ├── neovim.lua             # Neovim-specific settings & performance
│   └── autocmds.lua           # Auto commands (trailing whitespace cleanup)
├── keymaps/
│   ├── general.lua            # General navigation & helpers
│   ├── buffer.lua             # Buffer/tab management keymaps
│   ├── lsp.lua                # Window navigation, editing & plugin keymaps
│   └── dashboard.lua          # Leader shortcuts mirroring the Alpha dashboard
├── plugins/
│   ├── init.lua               # Lazy.nvim bootstrap & all plugin specs
│   └── <plugin-name>.lua      # One config file per configured plugin
│                              # (lsp, nvim-cmp, mason-lspconfig, conform,
│                              #  telescope, nvim-tree, treesitter, trouble,
│                              #  bufferline, lualine, gitsigns, diffview,
│                              #  toggleterm, harpoon, alpha, which-key, …)
├── theme/
│   └── colours.lua            # Colourscheme (gruvbox) & diff highlighting
└── utils/
    └── functions.lua          # Helper functions & custom commands
```

## Module Descriptions

### `config/` - Core Settings
Handles fundamental Vim/Neovim configuration:

- **core.lua** - Basic options (line numbers, indentation, file handling)
- **neovim.lua** - Neovim-specific settings (performance, undo, wildmenu)
- **autocmds.lua** - Event handlers (trailing whitespace removal on save)

### `keymaps/` - Key Mappings
Organised key bindings by functionality:

- **general.lua** - Navigation helpers, paste formatting, arrow key warnings
- **buffer.lua** - Tab/buffer management (new tab, close buffer, NvimTree)
- **lsp.lua** - Window navigation (Ctrl+H/J/K/L), resizing, text moving, diagnostics float
- **dashboard.lua** - Leader shortcuts matching the Alpha dashboard buttons

### `plugins/` - Plugin Management
All plugin-related configuration through lazy.nvim:

- **init.lua** - Plugin specifications and lazy.nvim bootstrap
- Individual plugin configs keep settings isolated and easy to find

### `theme/` - Visual Appearance
Handles colourscheme and visual customisations:

- **colours.lua** - Gruvbox colourscheme setup and diff highlighting

### `utils/` - Utilities
Helper functions and custom commands:

- **functions.lua** - Configuration reload command and other helpers

## Load Order

The `init.lua` entry point loads modules in this order:

1. Core configuration (core, neovim, autocmds)
2. Key mappings (general, buffer, lsp, dashboard)
3. Plugins (lazy.nvim bootstrap and all plugins)
4. Theme (gruvbox colourscheme)
5. Utilities (custom functions)

This order ensures settings are applied before keymaps, and plugins load after core settings.

## Adding New Plugins

To add a new plugin:

1. Add the plugin specification to `plugins/init.lua`
2. If configuration is needed, create `plugins/plugin-name.lua`
3. Reference it with `config = function() require("plugins.plugin-name") end`

Example:
```lua
{
  "user/awesome-plugin",
  config = function()
    require("plugins.awesome-plugin")
  end,
}
```

## Adding New Key Mappings

Determine if the mapping is:
- **General navigation/utility** → Add to `keymaps/general.lua`
- **Buffer/tab related** → Add to `keymaps/buffer.lua`
- **Window/editing/diagnostics** → Add to `keymaps/lsp.lua`
- **Plugin-specific** → Prefer the plugin's `keys = {...}` in `plugins/init.lua`
  (lazy-loads the plugin on first press), or the plugin's config file

## Adding New Settings

Determine which category the setting belongs to:
- **Core Vim options** → `config/core.lua`
- **Statusline styling** → `plugins/lualine.lua`
- **Neovim-specific** → `config/neovim.lua`
- **Visual/theme** → `theme/colours.lua`

## Benefits of This Structure

✅ **Modularity** - Each concern isolated in its own file  
✅ **Maintainability** - Easy to locate and modify features  
✅ **Scalability** - Simple to add new plugins or configurations  
✅ **Readability** - Reduced cognitive load per file  
✅ **Reusability** - Shared functions and configs where needed  

## Migration from Monolithic Config

All original functionality has been preserved during the refactoring. The modular structure makes it easier to:
- Find specific settings
- Test configuration changes in isolation
- Share configuration snippets
- Update individual components without affecting others
