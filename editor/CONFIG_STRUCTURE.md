# Neovim Configuration Structure

This document describes the modular organisation of the Neovim configuration.

## Directory Layout

```
editor/
├── init.lua                    # Entry point - orchestrates all modules
├── CONFIG_STRUCTURE.md         # This file
├── config/
│   ├── core.lua               # Basic Vim options, leader key, indentation
│   ├── statusline.lua         # Custom statusline with powerline arrows
│   ├── neovim.lua             # Neovim-specific settings & performance
│   └── autocmds.lua           # Auto commands (trailing whitespace cleanup)
├── keymaps/
│   ├── general.lua            # General navigation & helpers
│   └── buffer.lua             # Buffer/tab management keymaps
├── plugins/
│   ├── init.lua               # Lazy.nvim bootstrap & plugin specs
│   ├── nvim-tree.lua          # File tree navigation
│   ├── nerd-commenter.lua     # Advanced commenting
│   ├── ale.lua                # Linting engine configuration
│   ├── coc.lua                # Language server protocol setup
│   ├── ctrlp.lua              # Fuzzy file finder with ag
│   ├── rainbow.lua            # Rainbow parentheses highlighting
│   └── tagbar.lua             # Code structure navigation
├── theme/
│   └── colours.lua            # Colourscheme & diff highlighting
└── utils/
    └── functions.lua          # Helper functions & custom commands
```

## Module Descriptions

### `config/` - Core Settings
Handles fundamental Vim/Neovim configuration:

- **core.lua** - Basic options (line numbers, indentation, file handling)
- **statusline.lua** - Custom powerline-style statusline with colour highlights
- **neovim.lua** - Neovim-specific settings (performance, undo, wildmenu)
- **autocmds.lua** - Event handlers (trailing whitespace removal on save)

### `keymaps/` - Key Mappings
Organised key bindings by functionality:

- **general.lua** - Navigation helpers, paste formatting, arrow key warnings
- **buffer.lua** - Buffer and tab navigation/management

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

1. Core configuration (core, statusline, neovim, autocmds)
2. Key mappings (general, buffer)
3. Plugins (lazy.nvim bootstrap and all plugins)
4. Theme (colourscheme)
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
- **Plugin-specific** → Keep in the plugin's config file

## Adding New Settings

Determine which category the setting belongs to:
- **Core Vim options** → `config/core.lua`
- **Statusline styling** → `config/statusline.lua`
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
