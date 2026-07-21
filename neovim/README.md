# Neovim Configuration

Modern terminal editor with pure Lua configuration and lazy.nvim plugin manager.

## File Structure

- **`init.lua`** - Entry point that loads the modular configuration
- **`config/`**, **`keymaps/`**, **`plugins/`**, **`theme/`**, **`utils/`** - Modular config directories

See **[CONFIG_STRUCTURE.md](CONFIG_STRUCTURE.md)** for the full directory layout, load order, and where to add new plugins, keymaps, and settings.

## Quick Start

### Installation
```bash
# Install via Homebrew (included in Brewfile)
brew install neovim

# The install script symlinks everything in neovim/ (except this README)
# into ~/.config/nvim
./install.sh

# Or manually:
mkdir -p ~/.config/nvim
for item in ~/.dotfiles/neovim/*; do
  [ "$(basename "$item")" = "README.md" ] || ln -sf "$item" ~/.config/nvim/
done
```

### First Launch
On first launch, Neovim automatically:
1. Downloads and bootstraps lazy.nvim plugin manager
2. Installs all plugins defined in `plugins/init.lua`
3. Installs language servers via Mason
4. Shows lazy.nvim dashboard with progress

**No manual `:PlugInstall` needed!**

### Common Commands

```bash
# Open a file
nvim myfile.py

# Open multiple files in splits
nvim -O file1.txt file2.txt

# Update plugins (quote "+Lazy! sync" as one argument)
nvim --headless "+Lazy! sync" +qa

# Check health
nvim +checkhealth
```

Shell aliases from [terminal/](../terminal/README.md):

```bash
v myfile.js   # Opens file in Neovim
vu            # Updates all plugins (nvim --headless "+Lazy! sync" +qa)
```

## Key Features

- ✅ Pure Lua configuration (no VimScript)
- ✅ lazy.nvim for modern plugin management
- ✅ Auto-installation on first launch
- ✅ Native LSP with Mason-managed language servers
- ✅ Treesitter syntax highlighting and Telescope fuzzy finding
- ✅ Customisable key mappings
- ✅ Greyscale UI chrome (gruvbox syntax + coloured file icons stay)

## Greyscale UI

All UI chrome — dashboard, file tree, statusline, diffs, completion popup,
messages — renders in one grey ramp defined in `theme/palette.lua` (the
canonical definition; zsh/tmux/git/fzf mirror it, see
[terminal/README.md](../terminal/README.md#greyscale-theme)). Code syntax
highlighting and file-type icons keep their colours.

`theme/colours.lua` applies it in two layers: explicit highlight groups for
the designed surfaces, plus an automatic sweep that desaturates any group
matching a known plugin-UI prefix (re-run on colorscheme changes and every
lazy plugin load). Adding a plugin with coloured UI? Add its highlight
prefix to `ui_prefixes` there.

File-type icons follow Antigravity IDE's "Symbols" icon theme as closely
as a terminal font allows — see `plugins/icons.lua` for the mapping and
where its glyphs/colours come from.

## Key Bindings

The leader key is `,`. A few highlights:

| Key | Action |
|-----|--------|
| `Ctrl+/` | **Searchable shortcut sheet** — fuzzy-search every keymap (Telescope); Enter executes the selection |
| `F1` | Which-key view of every keymap (drill into prefixes) |
| `,ne` | Toggle file tree (nvim-tree) |
| `,n<Space>` | Reveal current file in tree |
| `,t` | Toggle code outline (Aerial, LSP symbols) |
| `,f` | Find files (Telescope) |
| `,w` | Live grep (Telescope) |
| `,r` | Recent files (Telescope) |
| `,l` | Open lazy.nvim UI |
| `,m` | Open Mason UI |
| `,h` | Clear search highlight |
| `Ctrl+Q` | Close buffer |

The authoritative list lives in `keymaps/` (plugin-specific mappings sit alongside each plugin's config in `plugins/`).

## Plugin Management

### View plugins
Inside Neovim:
```vim
:Lazy
```

### Update plugins
```bash
# From terminal (quote "+Lazy! sync" as one argument)
nvim --headless "+Lazy! sync" +qa

# Or inside Neovim
:Lazy sync
```

### Add new plugins
Add a spec to `plugins/init.lua` (see [CONFIG_STRUCTURE.md](CONFIG_STRUCTURE.md) for the pattern):
```lua
{
  'author/plugin-name',
  config = function()
    require('plugins.plugin-name')
  end,
}
```

Plugins auto-install on next launch!

## Customisation

### Add keybindings
Add to the appropriate file in `keymaps/`:
```lua
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })

-- File-type specific mapping
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set('n', '<leader>r', ':!python %<CR>')
  end
})
```

### Configure plugins
Each plugin's settings live in its own file under `plugins/` — edit that file rather than the spec in `plugins/init.lua`. For example, in `plugins/lualine.lua`:
```lua
require('lualine').setup({
  options = {
    theme = 'auto'
  }
})
```

## Language Support

Language servers are managed by Mason and installed automatically (see `plugins/mason-lspconfig.lua` for the list — Lua, Python, TypeScript, Rust, JSON, YAML, HTML, CSS, Bash; gopls comes via Homebrew):

```vim
:Mason      " Browse and install servers, formatters, and linters
:LspInfo    " Check what's attached to the current buffer
```

Formatting is handled by conform.nvim (`plugins/conform.lua`) using tools like stylua, black/isort, and prettier.

### Language providers
Some plugins need external runtimes:
```bash
pip3 install pynvim      # Python provider
gem install neovim       # Ruby provider
node --version           # Node.js, used by several plugins
```

Run `:checkhealth` to verify providers.

## Troubleshooting

### Plugins not installing
```bash
# Check Neovim version (0.9+ required)
nvim --version

# Remove and re-bootstrap
rm -rf ~/.local/share/nvim/lazy
nvim
```

### Language server not working
```vim
:LspInfo    " Is a server attached?
:Mason      " Is the server installed?
:messages   " Any errors on startup?
```

### Colours look wrong
True colour (`termguicolors`) is already enabled in `config/core.lua`. Ensure your terminal emulator supports true colour (iTerm2 does), then restart the terminal and Neovim.

### Slow startup
Profile startup time:
```bash
nvim --startuptime startup.log
sort -rn -k 2 startup.log | head -20
```

## Updates and Maintenance

```bash
# Update Neovim itself
brew upgrade neovim

# Update all plugins
nvim --headless "+Lazy! sync" +qa   # or the `vu` alias
```

## Documentation

- **[CONFIG_STRUCTURE.md](CONFIG_STRUCTURE.md)** - Modular config layout and how to extend it
- **[Root README](../README.md)** - Full dotfiles installation

## See Also

- [Neovim Documentation](https://neovim.io/doc/user/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
