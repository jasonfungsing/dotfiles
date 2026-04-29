# Neovim Setup Guide

This guide explains how to use your Neovim configuration with pure Lua setup from your dotfiles.

## Overview

Your dotfiles now include a Neovim-only setup with:
- ✅ Pure Lua configuration (`init.lua`)
- ✅ Modern plugin management
- ✅ Language server protocol (LSP) support
- ✅ Asynchronous linting and formatting
- ✅ Optimised for development workflows

## Installation

### Prerequisites

```bash
# Install Neovim via Homebrew on macOS
brew install neovim

# Or install the latest development version
brew install --HEAD neovim
```

### Setup Steps

The installation script handles this automatically, but here's what happens:

1. **Create Neovim config directory:**
   ```bash
   mkdir -p ~/.config/nvim
   ```

2. **Symlink init.lua:**
   ```bash
   ln -s ~/.dotfiles/editor/init.lua ~/.config/nvim/init.lua
   ```

3. **Bootstrap lazy.nvim (plugin manager):**
   The configuration automatically bootstraps lazy.nvim on first launch.

### First Launch

On first launch, Neovim will:
1. Load `init.lua` from `~/.config/nvim/`
2. Automatically bootstrap lazy.nvim plugin manager
3. Install all plugins specified in the configuration

```bash
# Open Neovim (lazy.nvim will auto-install plugins)
nvim

# Inside Neovim, lazy.nvim dashboard will show plugin installation progress
# Press 'q' to close the dashboard and start editing

# Install language server extensions
:CocInstall coc-tsserver coc-python coc-go coc-eslint coc-prettier

# View plugin status
:Lazy
```

## Configuration Structure

Your `init.lua` is the main entry point with:
- Plugin declarations
- Key mappings
- Editor settings
- LSP configuration
- Autocommands

## Usage

### Basic Commands

```bash
# Start Neovim
nvim

# Open a file
nvim myfile.py

# Open multiple files in tabs
nvim file1.js file2.js

# Open in splits
nvim -O file1.txt file2.txt
```

### Key Bindings

Common keybindings from your configuration:

| Key | Action |
|-----|--------|
| `,ne` | Toggle NERDTree |
| `,n` | Find current file in NERDTree |
| `,t` | Toggle Tagbar |
| `,1` | Source config and update plugins |
| `Ctrl+J` | Next buffer |
| `Ctrl+K` | Previous buffer |
| `Ctrl+T` | New empty buffer |
| `Ctrl+Q` | Close buffer |
| `\` | Search with Silver Searcher (ag) |
| `K` | Grep word under cursor |

### Shell Aliases

Quick access to Neovim:

```bash
v myfile.js   # Opens file in Neovim (alias)
nvim myfile   # Explicit Neovim command
```

## Language Support

### Setup Language Servers

Language servers are configured via coc.nvim extensions:

**TypeScript/JavaScript:**
```bash
:CocInstall coc-tsserver coc-eslint coc-prettier
```

**Python:**
```bash
:CocInstall coc-python
pip3 install pylint flake8
```

**Go:**
```bash
:CocInstall coc-go
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

**JSON:**
```bash
:CocInstall coc-json
```

**Git:**
```bash
:CocInstall coc-git
```

### Linting Configuration

ALE (Asynchronous Lint Engine) is configured with:

**JavaScript/TypeScript:**
```bash
npm install -g eslint
```

**Python:**
```bash
pip3 install pylint flake8
```

**Go:**
```bash
brew install golangci-lint
```

**Java:**
- Configured via coc-java and Eclipse LSP

## Troubleshooting

### Plugins Not Installing

**Solution:**
```bash
nvim
:PlugInstall
:PlugUpdate
```

### coc.nvim Not Working

**Solution:**
```bash
# Check status
:CocStatus

# Reinstall extensions
:CocInstall coc-tsserver coc-python coc-go coc-eslint coc-prettier

# Restart Neovim
:qa
nvim
```

### Linters Not Running

**Solution:**
Ensure linters are installed:

```bash
# JavaScript
npm install -g eslint

# Python
pip3 install pylint flake8

# Go
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

### Colours Look Wrong

**Solution:**
Ensure your terminal supports true colours:

```bash
# Set in your shell config (~/.zshrc)
export TERM=xterm-256color

# Restart terminal and Neovim
```

### Performance Issues

**Solution:**
Profile startup time:

```bash
nvim --startuptime startup.log
cat startup.log | sort -rn -k 2 | head -20
```

Common causes:
- Too many plugins
- Large files with complex syntax
- Missing plugin compilation

## Customisation

### Adding Custom Keybindings

Edit `~/.config/nvim/init.lua` to add custom mappings:

```lua
-- Example: Custom mapping
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

-- Example: File-type specific mapping
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set('n', '<leader>r', ':!python %<CR>')
  end
})
```

### Installing Additional Plugins

Add to the `Plug` section in your configuration:

```lua
-- After existing plugins
Plug 'your-github-org/plugin-name'
```

Then:
```bash
nvim
:PlugInstall
```

## Advanced Setup

### Python Support

```bash
pip3 install pynvim
```

### Node.js Support

coc.nvim requires Node.js:
```bash
# Verify installation
node --version

# Should be 12.12 or newer
```

### Ruby Support

```bash
gem install neovim
```

## Performance Tips

1. **Lazy load plugins** - Only load when needed
2. **Profile startup** - Use `--startuptime` flag
3. **Disable unused plugins** - Comment out unneeded ones
4. **Use async linting** - ALE is already configured
5. **Limit file sizes** - Complex files slow syntax highlighting

## Updates and Maintenance

### Update Plugins

```bash
nvim
:Lazy sync   # Update all plugins via lazy.nvim
```

### Update Neovim

```bash
brew upgrade neovim
```

### Update Extensions

```bash
nvim
:CocUpdate
```

## Further Reading

- [Neovim Documentation](https://neovim.io/doc/user/)
- [vim-plug Guide](https://github.com/junegunn/vim-plug)
- [coc.nvim Documentation](https://github.com/neoclide/coc.nvim/wiki)
- [ALE Documentation](https://github.com/dense-analysis/ale)

## Support

If you encounter issues:

1. Check health in Neovim: `:CheckHealth`
2. Review error messages: `:messages`
3. Check plugin documentation on GitHub
4. Consider filing an issue in the dotfiles repository

---

**Last Updated:** April 2026
**Neovim Version:** 0.9+ recommended
**Configuration:** Pure Lua (`init.lua`)
