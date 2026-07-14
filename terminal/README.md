# Terminal Configuration

Zsh shell configuration (aliases, theme, plugins) and tmux terminal multiplexer.

## File Structure

- **`zshrc`** - Main Zsh configuration
- **`alias_prompt.sh`** - Enter-key widget that reminds you when a command has an alias
- **`shortcut-sheet.zsh`** - The dynamic shortcut sheet widget (`Ctrl+/` / `F1`)
- **`cobalt2.zsh-theme`** - Custom Zsh theme (Cobalt2)
- **`tmux.conf`** - tmux configuration and keybindings

---

# Shell (Zsh)

## Quick Start

### Installation
```bash
# Symlink zshrc and the alias reminder it sources
ln -s ~/.dotfiles/terminal/zshrc ~/.zshrc
ln -s ~/.dotfiles/terminal/alias_prompt.sh ~/.alias_prompt.sh

# Reload shell
source ~/.zshrc
```

### Check Configuration
```bash
echo $SHELL
echo $ZSH_THEME
alias
```

## Configuration Files Explained

### zshrc
Main shell configuration file that:
- Sources Oh-My-Zsh framework
- Defines custom aliases (see [Available Aliases](#available-aliases))
- Sets up environment variables
- Configures plugin behaviour
- Initialises shell utilities (nvm, autojump, fzf, direnv, thefuck)

### alias_prompt.sh
ZLE widget sourced by `zshrc` that hijacks the Enter key: if the line you typed is exactly the expansion of an existing alias, it prints the alias and clears the line (the command does not run), nudging you to use the alias. Anything else runs as normal.

### cobalt2.zsh-theme
Custom Zsh theme providing:
- Modern colour scheme
- Git status indicators
- Customised prompt display

## Available Aliases

All custom aliases are defined in `zshrc`, except where a row notes it comes from a plugin or tool hook.

### Terminal & Multiplexing

| Alias | Command | Purpose |
|-------|---------|---------|
| `t` | `tmux` | Start or attach to tmux |
| `mux` | `tmuxinator` | Tmuxinator project manager |

### Development Tools

| Alias | Command | Purpose |
|-------|---------|---------|
| `v` | `nvim` | Open Neovim |

### Git, Cloud & Kubernetes

| Alias | Command | Purpose |
|-------|---------|---------|
| `gpa` | `find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;` | Git pull every repository in the current folder |
| `gc` | `git commit --verbose` | From the omz git plugin |
| `k` | `kubectl` | Kubernetes CLI |
| `mnk` | `minikube` | Minikube local Kubernetes |

### Package Management & Updates

| Alias | Command | Purpose |
|-------|---------|---------|
| `y` | `yarn` | Yarn package manager |
| `update` | `brew update; brew upgrade --yes; brew upgrade --cask --greedy --yes; brew cleanup; omz update; nvim --headless "+Lazy! sync" +qa` | Update all packages, casks, Oh-My-Zsh and Neovim plugins |
| `u` | `update` | Shorthand for `update` |
| `vu` | `nvim --headless "+Lazy! sync" +qa` | Update Neovim plugins only |

### macOS Power & Lid

| Name | Command | Purpose |
|-------|---------|---------|
| `nosleep` | `sudo pmset -c disablesleep 1` | Keep the Mac awake — even with the lid closed — but only while on AC power; on battery it sleeps normally |
| `yessleep` | `sudo pmset -a disablesleep 0` | Restore normal sleep behaviour on all power sources |
| `sleepstatus` | *(function)* | Report whether sleep is currently disabled |
| `islidclosed` | *(function)* | Print `Yes`/`No` for the lid (clamshell) state — handy over SSH |

### Utilities

| Alias | Command | Purpose |
|-------|---------|---------|
| `weather` | `curl wttr.in/$1.` | Check weather for a location |
| `python` | `python3` | Use Python 3 by default |
| `fuck` | `thefuck` | Correct the previous command (hook only loads if thefuck is installed) |

### Usage
```bash
v file.js          # Open file in Neovim
weather Sydney     # Check weather
u                  # Update everything
```

## Managing Aliases

### Temporary (current session only)
```bash
alias myalias="command"
```

### Permanent
1. Edit `zshrc` (the aliases live in the `6. Aliases` section)
2. Add: `alias myalias="command"`
3. Reload shell: `source ~/.zshrc`

### Removing an alias
```bash
unalias myalias    # Current session only
```
To remove permanently, delete the line from `zshrc` and reload the shell.

### Listing all aliases
```bash
alias
```

## Keyboard Shortcuts

All shortcuts live in the **dynamic shortcut sheets** — generated from the
running config on every invocation, so they are always accurate (this
README used to duplicate them in tables, which drifted):

| Where | Keys | What you get |
|---|---|---|
| zsh prompt (incl. inside tmux) | `Ctrl+/` or `F1` | Searchable sheet: tmux keys (with descriptions), aliases, functions, zsh bindings |
| tmux | `C-f ?` | Searchable popup of the tmux bindings |
| Neovim | `Ctrl+/` or `F1` | Searchable keymap sheet (Telescope, Enter executes) / which-key drill-down |

Sheet controls: type to filter (exact substring), `Tab` / `Shift + Tab` to
move, `Enter` runs a tmux/zsh line or puts an alias/function on the prompt,
`Esc` closes. Copy-mode keys appear as `tmux copy …` lines (view-only).

Notes: zsh line editing runs in emacs mode; `Option` shortcuts require
iTerm2's "Left Option key: Esc+" profile setting. `Ctrl+/` needs no iTerm2
configuration and also works in VS Code's terminal and over SSH (it
replaced the redundant `Ctrl+_` undo — undo remains on `Ctrl+X Ctrl+U`).

## Greyscale Theme

The whole terminal renders in one grey ramp — no accent colours except
file-type colours (`ls`, completion listings) and code syntax in nvim:

- **zsh prompt** — segment overrides in `zshrc` (§ Oh-My-Zsh)
- **tmux** — status bar, messages, copy-mode, borders in `tmux.conf`
- **fzf** — `FZF_DEFAULT_OPTS` in `zshrc` (§ Environment); the tmux `C-f ?`
  popup carries a synced copy
- **git output** — `[color "…"]` sections in `git/gitconfig`
- **grep** — `GREP_COLORS` in `zshrc`
- **nvim** — see `neovim/theme/palette.lua`, the canonical ramp definition
  all of the above mirror (shell configs use the matching 256-palette
  indices, since not everything accepts hex)

To retune the ramp: change `palette.lua` for nvim, then update the indices
noted in its header across the shell configs.

## Oh-My-Zsh Plugins

Enabled plugins (the `plugins=(...)` array in `zshrc`) provide additional aliases:
- **git** - Git shortcuts (`gc`, `ga`, `gcmsg`, `gd`, `gco`, `gbr`, etc.)
- **tmux** / **tmuxinator** - Tmux helpers (`tl`, `tksv`, `txs`, etc.)
- **brew** - Homebrew commands (`bubu`, `bi`, etc.)
- **npm** - Node package manager shortcuts and completion
- **macos** - macOS helpers (`showfiles`, `hidefiles`, etc.)
- **gitignore** - Fetch `.gitignore` templates (`gi`)
- **golang** - Go shortcuts (`gor`, `got`, etc.) and completion
- **mvn** - Maven shortcuts (`mvnci`, `mvnct`, etc.)
- **python** - Python utilities (`py`, `pyserver`, etc.)
- **xcode** - Xcode helpers (`xcb`, `xcdd`, etc.)
- **z** - Jump to frecent directories (`z`)
- **kubectl** - Kubernetes commands (`kgp`, `kaf`, etc.) and completion
- **autojump** - Directory jumping (`j`, works with the autojump hook)
- **dotenv** - Auto-loads `.env` files when you `cd` into a directory

### Explore plugins
```bash
# List all aliases
alias

# Search for specific aliases
alias | grep "^g"

# View plugin details
cat ~/.oh-my-zsh/plugins/git/git.plugin.zsh
```

## Environment Variables

### Editor
```bash
EDITOR=nvim        # Default text editor
VISUAL=nvim        # Default visual editor
```

### Version Managers
```bash
NVM_DIR=~/.nvm     # Node Version Manager
```

### Custom Paths
Various paths configured for tools and executables.

## Customisation

### Change theme
Edit `zshrc`:
```bash
ZSH_THEME="robbyrussell"  # or any Oh-My-Zsh theme
```

### Add plugins
Edit `zshrc` plugins array:
```bash
plugins=(git tmux brew npm python)
```

### Modify prompt
Edit `cobalt2.zsh-theme` (or the `prompt_context` override in `zshrc`)

## Troubleshooting

### Shell not loading
```bash
# Check zshrc syntax
zsh -n ~/.zshrc

# Source manually
source ~/.zshrc
```

### Aliases not working
```bash
# Check alias exists
alias myalias

# Reload shell
exec zsh

# Check for conflicts
which myalias
type myalias
```

### Alias conflicts with a command
If an alias shadows a command you want to run directly:
```bash
# Bypass the alias
\mycommand

# Or use the full path
/usr/bin/mycommand
```

### Theme not displaying
```bash
# Verify theme file exists (install.sh symlinks it into oh-my-zsh's custom themes)
ls ~/.oh-my-zsh/custom/themes/cobalt2.zsh-theme

# Check theme is loaded
echo $ZSH_THEME

# Restart terminal
```

---

# Terminal Multiplexer (tmux)

## Quick Start

### Installation
```bash
# Install tmux (included in Brewfile)
brew install tmux

# Symlink configuration
ln -s ~/.dotfiles/terminal/tmux.conf ~/.tmux.conf

# Reload tmux
tmux source ~/.tmux.conf
```

### Start Using tmux
```bash
# Start new session
tmux

# Or with a name
tmux new-session -s myproject

# Attach to existing session
tmux attach-session -t myproject

# List sessions
tmux list-sessions
```

## Key Features

- ✅ Optimised keybindings for productivity
- ✅ Mouse support for pane selection
- ✅ Vim-style pane navigation (pain-control)
- ✅ Vi-like keybindings for copy mode
- ✅ Manual session save/restore (resurrect)
- ✅ Custom status bar with CPU and battery
- ✅ Plugin support (via tpm)

## Keyboard Shortcuts

**The prefix is `Ctrl+f`** (not tmux's default `Ctrl+b`): press `Ctrl+f`,
release, then the key. All bindings are documented by the live sheets —
`C-f ?` for the tmux popup, or `Ctrl+/` from any shell pane for the
combined sheet (which also covers copy-mode keys) — always current, plugin
overrides included.

## Status Bar

The status bar sits at the **top** of the screen and displays:
- Current session name
- Window list with active indicator
- Battery percentage *(tmux-battery)*
- CPU percentage *(tmux-cpu)*
- Day, date and time

Customise by editing `tmux.conf`:
```bash
set-option -g status-position top
set -g status-style fg=white,bg=blue
set -g status-right 'Batt:#{battery_percentage} | CPU:#{cpu_percentage} | %a %d %h %H:%M '
```

## Common Workflows

### Development Environment
```bash
# Create session
tmux new-session -s dev

# Create windows for different tasks
Prefix + c                    # Editor window
Prefix + c                    # Build/testing window
Prefix + c                    # Logs/debugging window

# Name windows for clarity
Prefix + ,                    # Rename to "editor"
Prefix + ,                    # Rename to "build"
Prefix + ,                    # Rename to "logs"
```

### Split Layout
```bash
# Start with main editor pane
tmux new-session -s work

# Split for logs
Prefix + %

# Navigate between panes
Prefix + left/right arrow
```

### Detach and Reattach
```bash
# Work in tmux session
Prefix + d                    # Detach session

# Close terminal, disconnect, etc.

# Later, reattach to your work
tmux attach-session -t work
```

## Plugins

tmux supports plugins via tpm (tmux plugin manager).

### Install tpm
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Installed Plugins
- `tmux-plugins/tpm` - Plugin manager
- `tmux-plugins/tmux-sensible` - Sensible defaults
- `tmux-plugins/tmux-resurrect` - Manual session save/restore (`C-f C-s` / `C-f C-r`)
- `tmux-plugins/tmux-yank` - Copy to the macOS clipboard
- `tmux-plugins/tmux-copycat` - Regex/URL/file searches
- `tmux-plugins/tmux-open` - Open highlighted files/URLs
- `tmux-plugins/tmux-pain-control` - Standard pane bindings
- `tmux-plugins/tmux-cpu` + `tmux-battery` - Status line info

### Add Plugin to Config
```bash
set -g @plugin 'tmux-plugins/tmux-resurrect'

# At end of conf file:
run '~/.tmux/plugins/tpm/tpm'
```

## Troubleshooting

### Configuration not loading
```bash
# Check syntax
tmux source-file -nv ~/.tmux.conf

# Reload configuration
tmux source ~/.tmux.conf
```

### Keybindings not working
```bash
# Check current keybindings
tmux list-keys

# Search for specific binding
tmux list-keys | grep "Prefix"

# Verify configuration file
cat ~/.tmux.conf | grep "bind"
```

### Pane navigation not working
```bash
# Check tmux version
tmux -V

# List the actual live bindings
tmux list-keys -T prefix
```

### Colors not displaying correctly
```bash
# Check terminal color support
echo $TERM

# Set to 256-color or truecolor
export TERM=screen-256color
```

## Advanced Configuration

### Custom Key Bindings
```bash
# Example: Bind custom key for common operation
bind-key -T copy-mode-vi 'V' send-keys -X begin-selection
bind-key -T copy-mode-vi 'Y' send-keys -X copy-selection
```

### Custom Commands
```bash
# Create alias for common tmux commands
alias tmuxd="tmux detach-client -t"
alias tmuxl="tmux list-sessions"
alias tmuxa="tmux attach-session -t"
```

### Sessions and Dotfiles
```bash
# Save session configuration
tmux list-windows -t myproject

# Export session layout
tmux capture-pane -t myproject -p > session-layout.txt
```

## Documentation

For full dotfiles installation, see the **[root README](../README.md)**.


## See Also

- [Zsh Manual](http://zsh.sourceforge.net/)
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Zsh Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
- [tmux Manual](http://man.openbsd.org/tmux)
- [tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- [tmux Cheat Sheet](https://cheatsheets.quartermaster.me/tmux.html)
