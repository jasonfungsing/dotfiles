# Neovim Configuration

Modern terminal editor with pure Lua configuration and lazy.nvim plugin manager.

## File Structure

- **`init.lua`** - Neovim configuration (pure Lua, no vimrc)

## Quick Start

### Installation
```bash
# Install via Homebrew (included in Brewfile)
brew install neovim

# Create symlink to configuration
ln -s ~/.dotfiles/editor/init.lua ~/.config/nvim/init.lua
```

### First Launch
On first launch, Neovim automatically:
1. Downloads and bootstraps lazy.nvim plugin manager
2. Installs all plugins defined in init.lua
3. Shows lazy.nvim dashboard with progress

**No manual `:PlugInstall` needed!**

### Common Commands

```bash
# Open a file
nvim myfile.py

# Open multiple files in splits
nvim -O file1.txt file2.txt

# Update plugins
nvim +Lazy sync +qa

# Check health
nvim +CheckHealth
```

## Key Features

- ✅ Pure Lua configuration (no VimScript)
- ✅ lazy.nvim for modern plugin management
- ✅ Auto-installation on first launch
- ✅ Integrated language servers (coc.nvim)
- ✅ Syntax highlighting for 100+ languages
- ✅ Customisable key mappings

## Plugin Management

### View plugins
Inside Neovim:
```vim
:Lazy
```

### Update plugins
```bash
# From terminal
nvim +Lazy sync +qa

# Or inside Neovim
:Lazy sync
```

### Add new plugins
Edit `init.lua` and add to the plugins table:
```lua
{
  'github/author/plugin-name',
  opts = { ... }
}
```

Plugins auto-install on next launch!

## Customisation

### Add keybindings
Edit `init.lua` and add:
```lua
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
```

### Configure plugins
Each plugin can be customised via `opts`:
```lua
{
  'nvim-lualine/lualine.nvim',
  opts = {
    theme = 'dracula'
  }
}
```

## Language Servers

Language servers are managed via coc.nvim extensions:
```bash
# Inside Neovim
:CocInstall coc-python coc-rust-analyzer coc-go
```

## Troubleshooting

### Plugins not installing
```bash
# Check Neovim version (0.9+ required)
nvim --version

# Remove and re-bootstrap
rm -rf ~/.local/share/nvim/lazy
nvim
```

### coc.nvim not working
Requires Node.js:
```bash
# Check Node.js version
node --version

# Install if missing
brew install node
```

### Slow startup
Check startup time:
```bash
nvim --startuptime startup.log
```

## Documentation

For detailed setup and customisation, see:
- **[NEOVIM_SETUP.md](../docs/NEOVIM_SETUP.md)** - Complete Neovim guide
- **[INSTALLATION.md](../docs/INSTALLATION.md)** - Full dotfiles installation

## See Also

- [Neovim Documentation](https://neovim.io/doc/user/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [coc.nvim](https://github.com/neoclide/coc.nvim)
