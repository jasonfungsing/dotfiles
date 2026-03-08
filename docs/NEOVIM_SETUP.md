# Neovim Setup Guide

This guide explains how to use your optimised dotfiles configuration with Neovim.

## Overview

Your dotfiles now include full Neovim support with:
- ✅ Optimised `vimrc` with Neovim-aware paths
- ✅ Modern `init.lua` configuration
- ✅ ALE (Asynchronous Lint Engine) for async linting
- ✅ coc.nvim with extended language support (Go, Python, TypeScript, etc.)
- ✅ All your existing Vim plugins and settings
- ✅ Backward compatibility with Vim

## Installation

### Prerequisites

```bash
# Install Neovim (via Homebrew on macOS)
brew install neovim

# Or if you prefer the latest development version
brew install --HEAD neovim
```

### Setup Steps

#### Option 1: Symlink (Recommended)

Create a symlink from your dotfiles to Neovim config directory:

```bash
# Create Neovim config directory if it doesn't exist
mkdir -p ~/.config/nvim

# Symlink the init.lua
ln -s ~/Code/dotfiles/editor/init.lua ~/.config/nvim/init.lua

# Symlink the vimrc (init.lua will source this)
ln -s ~/Code/dotfiles/editor/vimrc ~/.vimrc
```

#### Option 2: Copy Files

Copy files directly to Neovim config:

```bash
mkdir -p ~/.config/nvim
cp ~/Code/dotfiles/editor/init.lua ~/.config/nvim/init.lua
cp ~/Code/dotfiles/editor/vimrc ~/.vimrc
```

### First Launch

On first launch, Neovim will:
1. Load `init.lua` from `~/.config/nvim/`
2. Source your `~/.vimrc` for all Vim settings and plugins
3. Automatically install vim-plug if missing
4. Install all plugins from your `Plug` declarations

```bash
nvim
# Inside Neovim, run:
:PlugInstall

# Then install coc extensions
:CocInstall coc-tsserver coc-python coc-go coc-eslint coc-prettier
```

## Configuration Changes

### What's New in This Setup

#### 1. **Updated Plugin Manager Paths**

The vimrc now detects Neovim and uses appropriate paths:

```vim
if has('nvim')
  let plug_dir = stdpath('data') . '/site/plugged'
  let autoload_dir = stdpath('config') . '/autoload'
else
  let plug_dir = '~/.vim/plugged'
endif
```

**Implications:**
- Vim: Plugins install to `~/.vim/plugged`
- Neovim: Plugins install to `~/.local/share/nvim/site/plugged` (macOS/Linux)

#### 2. **Plugin Changes**

| Old Plugin | New Plugin | Reason |
|-----------|-----------|--------|
| `syntastic` | `dense-analysis/ale` | ALE is async, faster, and Neovim-native |
| `mdempsky/gocode` | Removed | Deprecated; use `coc-go` instead |
| `majutsushi/tagbar` | `preservim/tagbar` | Updated to actively maintained fork |

#### 3. **New coc.nvim Extensions**

Added extensions for better language support:
- `coc-go` - Go language support
- `coc-eslint` - JavaScript/TypeScript linting
- `coc-prettier` - Code formatting

#### 4. **Lua Configuration**

The new `init.lua` adds Neovim-specific enhancements:
- True colour support (`termguicolors`)
- Performance optimisations
- Persistent undo
- Terminal mode mappings
- Custom `:ReloadConfig` command

## Usage

### Switching Between Vim and Neovim

Since your setup is backward compatible, you can use both:

```bash
# Use Vim (uses ~/.vimrc)
vim filename.js

# Use Neovim (uses ~/.config/nvim/init.lua which sources ~/.vimrc)
nvim filename.js
```

### Common Commands

```bash
# Start Neovim
nvim

# Open a file
nvim myfile.py

# Open multiple files in tabs
nvim file1.js file2.js

# Open in split
nvim -O file1.txt file2.txt
```

### Useful Keybindings

These work in both Vim and Neovim:

| Key | Action |
|-----|--------|
| `,ne` | Toggle NERDTree |
| `,n` | Find current file in NERDTree |
| `,t` | Toggle Tagbar |
| `,1` | Source vimrc and update plugins |
| `Ctrl+J` | Next buffer |
| `Ctrl+K` | Previous buffer |
| `Ctrl+T` | New empty buffer |
| `Ctrl+Q` | Close buffer |
| `\` | Silver Searcher (ag) grep |
| `K` | Grep word under cursor |

## Troubleshooting

### Issue: Plugins not installing

**Solution:**

```bash
# Ensure you're in Neovim
nvim

# Inside Neovim:
:PlugInstall
:PlugUpdate
```

### Issue: coc.nvim not working

**Solution:**

```bash
# Check coc status
:CocStatus

# Reinstall extensions
:CocInstall coc-tsserver coc-python coc-go coc-eslint coc-prettier

# Restart Neovim
```

### Issue: ALE linters not running

**Solution:**

Ensure linters are installed globally:

```bash
# JavaScript/TypeScript
npm install -g eslint

# Python
pip3 install pylint flake8

# Go
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Java
# Usually handled by Eclipse LSP or coc-java
```

### Issue: Colours look wrong

**Solution:**

Make sure your terminal supports true colours and set `TERM` correctly:

```bash
# In your shell config (~/.zshrc, ~/.bashrc)
export TERM=xterm-256color

# Then restart your terminal and Neovim
```

### Issue: Performance is slow

**Solution:**

Check what's slowing things down:

```bash
# Inside Neovim, profile startup
nvim --startuptime startup.log
cat startup.log | sort -rn -k 2 | head -20
```

Common culprits:
- Too many plugins
- Large files with complex syntax highlighting
- Missing compiled plugins (`:UpdateRemotePlugins`)

## Advanced Setup

### Using pynvim for Python Support

```bash
pip3 install pynvim
```

### Using Node.js Support (for coc.nvim)

```bash
# Ensure Node.js is installed
node --version

# coc.nvim will use the system Node.js automatically
```

### Custom init.lua Extensions

You can add custom Lua configurations to `~/.config/nvim/init.lua` after sourcing vimrc:

```lua
-- Example: Custom mapping
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

-- Example: Custom autocommand
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.py',
  callback = function()
    vim.cmd(':Black')
  end
})
```

## Performance Comparison

| Aspect | Vim | Neovim |
|--------|-----|--------|
| Startup time | ~100ms | ~80ms |
| Async operations | Limited | Native |
| Plugin ecosystem | Mature | Growing faster |
| Configuration | VimScript only | VimScript + Lua |
| Maintainability | Good | Excellent |

## Further Reading

- [Neovim Documentation](https://neovim.io/doc/user/)
- [vim-plug Guide](https://github.com/junegunn/vim-plug)
- [coc.nvim Documentation](https://github.com/neoclide/coc.nvim/wiki)
- [ALE Documentation](https://github.com/dense-analysis/ale/blob/master/README.md)

## Support

If you encounter issues:

1. Check `:CheckHealth` in Neovim (built-in diagnostics)
2. Review error messages with `:messages`
3. Check plugin documentation on GitHub
4. Consider filing an issue in the dotfiles repository

---

**Last Updated:** March 2026
**Neovim Version:** 0.9+ recommended
**Configuration Format:** init.lua sourcing vimrc (hybrid approach)
