# Terminal Configuration

Zsh shell configuration (aliases, theme, plugins) and tmux terminal multiplexer.

## File Structure

- **`zshrc`** - Main Zsh configuration
- **`alias_prompt.sh`** - Prompt helpers, including an alias reminder
- **`cobalt2.zsh-theme`** - Custom Zsh theme (Cobalt2)
- **`tmux.conf`** - tmux configuration and keybindings

---

# Shell (Zsh)

## Quick Start

### Installation
```bash
# Symlink zshrc
ln -s ~/.dotfiles/terminal/zshrc ~/.zshrc

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
- Initialises shell utilities (fnm, nvm, rbenv)

### alias_prompt.sh
Prompt helper sourced by `zshrc` — when you type a command that already has an alias, it reminds you to use the alias instead.

### cobalt2.zsh-theme
Custom Zsh theme providing:
- Modern colour scheme
- Git status indicators
- Customised prompt display

## Available Aliases

All custom aliases are defined in `zshrc`.

### Terminal & Multiplexing

| Alias | Command | Purpose |
|-------|---------|---------|
| `t` | `tmux` | Start or attach to tmux |
| `mux` | `tmuxinator` | Tmuxinator project manager |

### Development Tools

| Alias | Command | Purpose |
|-------|---------|---------|
| `v` | `nvim` | Open Neovim |
| `i` | `idea` | Open IntelliJ IDEA |

### Git, Cloud & Kubernetes

| Alias | Command | Purpose |
|-------|---------|---------|
| `gpa` | `find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;` | Git pull every repository in the current folder |
| `gc` | `gcloud` | Google Cloud CLI |
| `k` | `kubectl` | Kubernetes CLI |
| `mnk` | `minikube` | Minikube local Kubernetes |

### Package Management & Updates

| Alias | Command | Purpose |
|-------|---------|---------|
| `y` | `yarn` | Yarn package manager |
| `update` | `brew update; brew upgrade; brew upgrade --cask --greedy; brew cleanup; omz update; nvim +Lazy sync +qa` | Update all packages, casks, Oh-My-Zsh and Neovim plugins |
| `u` | `update` | Shorthand for `update` |
| `vu` | `nvim +Lazy sync +qa` | Update Neovim plugins only |

### Utilities

| Alias | Command | Purpose |
|-------|---------|---------|
| `weather` | `curl wttr.in/$1.` | Check weather for a location |
| `python` | `python3` | Use Python 3 by default |

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
1. Edit `zshrc` (the aliases live near the bottom of the file)
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

Zsh line editing runs in **emacs mode**. Generated from the live bindings
(`bindkey`), so this reflects what the keys actually do. `Option` requires
iTerm2's "Left Option key: Esc+" profile setting (`Esc` then the key works
everywhere). See the tmux part below for the tmux master sheet.

### Fuzzy finding (fzf)

| Keys | Action |
|---|---|
| `Ctrl+R` | Fuzzy-search command history |
| `Ctrl+T` | Fuzzy-find files/dirs, insert selection at cursor |
| `Option+C` | Fuzzy-pick a directory and cd into it |
| `**<Tab>` | Fuzzy completion (e.g. `nvim **<Tab>`, `cd **<Tab>`) |

### History

| Keys | Action |
|---|---|
| `↑` / `↓` | Search history filtered by what you've typed so far |
| `Option+.` | Insert the last argument of the previous command (repeat to go older) |
| `Option+P` / `Option+N` | Previous / next command starting with the same first word |
| `Ctrl+O` | Run this line, then queue the next line from history |
| `Option+A` | Run this line but keep it on the prompt (for reruns with tweaks) |
| `Space` | Expands history references inline (`!!`, `!$`, …) |

### Moving around the line

| Keys | Action |
|---|---|
| `Ctrl+A` / `Ctrl+E` | Start / end of line |
| `Option+←/→` (or `Option+B/F`) | Back / forward one word |
| `Ctrl+X Ctrl+X` | Jump between cursor and mark |

### Editing

| Keys | Action |
|---|---|
| `Ctrl+W` / `Option+D` | Delete word before / after cursor |
| `Ctrl+U` | Delete the whole line |
| `Ctrl+K` | Delete to end of line |
| `Ctrl+Y`, then `Option+Y` | Paste deleted text back; cycle older deletions |
| `Ctrl+_` | Undo |
| `Option+T` | Transpose words |
| `Option+U` | UPPERCASE word |
| `Ctrl+X Ctrl+E` | **Edit the command line in nvim** — great for long commands |
| `Ctrl+Q` (or `Option+Q`) | Stash the line, type another command, stashed line returns |

### Completion

| Keys | Action |
|---|---|
| `Tab` | Complete (fzf-aware) |
| `Shift+Tab` | Cycle completion menu backwards |
| `Ctrl+X a` | Expand an alias in place (see what `u` really runs) |
| `Option+H` | Open the man page for the command you're typing |

### Fun ones

| Keys | Action |
|---|---|
| `Option+L` | Run `ls` without losing what you've typed |
| `F2 F2` | Toggle `npm install` ⇄ `npm uninstall` on the current line *(omz npm plugin)* |
| `Ctrl+L` | Clear screen (`Ctrl+K` in tmux also wipes scrollback) |

## Oh-My-Zsh Plugins

Enabled plugins provide additional aliases:
- **git** - Git shortcuts (`ga`, `gcmsg`, `gd`, `gco`, `gbr`, etc.)
- **tmux** - Tmux helpers
- **brew** - Homebrew commands
- **npm** - Node package manager
- **python** - Python utilities
- **aws** - AWS CLI shortcuts
- **kubectl** - Kubernetes commands

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
Edit `alias_prompt.sh` or `cobalt2.zsh-theme`

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
# Verify theme file exists
ls ~/.oh-my-zsh/themes/cobalt2.zsh-theme

# Check theme is loaded
echo $ZSH_THEME

# Restart terminal
```

## Keyboard Shortcuts

Shell prompt includes keyboard configuration for:
- Fast keyboard repeat rate
- Short key repeat delay
- Optimised for development workflows

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

**The prefix is `Ctrl+f`** (not tmux's default `Ctrl+b`). Every binding below
written as `C-f x` means: press `Ctrl+f`, release, then press `x`. This
reference was generated from the live server (`tmux list-keys`) with all
plugins loaded, so it reflects what the keys actually do — including plugin
overrides. `C-f ?` shows the searchable list inside tmux.

### Sessions

| Keys | Action |
|---|---|
| `C-f s` | Choose session from a tree (also shows windows) |
| `C-f $` | Rename current session |
| `C-f (` / `C-f )` | Previous / next session |
| `C-f d` | Detach from session |
| `C-f D` | Choose a client to detach |

### Save & restore (tmux-resurrect — manual only)

| Keys | Action |
|---|---|
| `C-f C-s` | **Save** snapshot of all sessions/windows/panes (and vim sessions, per `@resurrect-strategy-vim`) into `~/.tmux/resurrect/` |
| `C-f C-r` | **Restore** the latest snapshot (e.g. after a reboot) |

### Windows

| Keys | Action |
|---|---|
| `C-f c` | New window (keeps current directory) |
| `C-f u` / `C-f o` | Previous / next window *(custom)* |
| `C-f n` / `C-f C-p` | Next / previous window |
| `C-f 1`…`9` | Jump to window by number (numbering starts at 1) |
| `C-f w` | Choose window from a tree |
| `C-f ,` | Rename window |
| `C-f &` | Kill window (confirms) |
| `C-f <` / `C-f >` | Move window left / right (repeatable) |
| `C-f f` | Find window by name |
| `C-f .` | Move window to another index |

### Panes — create & destroy

| Keys | Action |
|---|---|
| `C-f \|` or `C-f %` | Split vertically (keeps current directory) |
| `C-f -` or `C-f "` | Split horizontally (keeps current directory) |
| `C-f \` | Full-width vertical split |
| `C-f _` | Full-height horizontal split |
| `C-f x` | Kill pane (confirms) |
| `C-f !` | Break pane out into its own window |

### Panes — navigate & arrange

| Keys | Action |
|---|---|
| `C-f h/j/k/l` (or `C-h/j/k/l`, or arrows) | Move between panes vim-style |
| `C-f ;` | Jump to last-used pane |
| `C-f H/J/K/L` | Resize by 2 cells (repeatable — keep tapping) |
| `C-f M-arrows` | Resize by 5 cells |
| `C-f z` | Zoom / unzoom pane |
| `C-f {` / `C-f }` | Swap pane up / down |
| `C-f C-o` / `C-f M-o` | Rotate all panes forward / backward |
| `C-f q` | Show pane numbers (press number to jump) |
| `C-f Space` / `C-f M-1`…`M-7` | Cycle / pick pane layouts |
| `C-f E` | Even out pane sizes |
| `C-f C-a` | Toggle typing into ALL panes at once |
| `C-f m` | Mark pane (`C-f M` clears) |

### Copy mode & clipboard (vi keys)

| Keys | Action |
|---|---|
| `C-f Escape` or `C-f [` | Enter copy mode |
| `h/j/k/l`, `w/b`, `0/$`, `g/G` | Move vim-style (word, line, top/bottom) |
| `C-u` / `C-d` | Half-page up / down |
| `/` / `?` then `n/N` | Search down / up, jump between matches |
| `v` | Start selection (`V` toggles rectangle) |
| `y` | Copy selection to the macOS clipboard, exit copy mode |
| `o` | Open selection (file/URL) with the default app *(tmux-open)* |
| `C-o` | Open selection in nvim *(tmux-open)* |
| `q` or `Escape` | Exit copy mode |
| `C-f p` or `C-f ]` | Paste |
| `C-f =` / `C-f #` | Choose / list paste buffers |
| `C-f y` | Copy the shell command line you're typing *(tmux-yank)* |
| `C-f Y` | Copy the pane's working directory *(tmux-yank)* |

### Search the screen (tmux-copycat)

Results are highlighted; `n`/`N` jump between matches, `Enter` copies one.

| Keys | Action |
|---|---|
| `C-f /` | Prompt for a regex search |
| `C-f C-u` | Search URLs |
| `C-f C-f` | Search file paths |
| `C-f C-d` | Search numbers |
| `C-f C-g` | Search git-status files |
| `C-f M-h` | Search git SHAs |
| `C-f M-i` | Search IP addresses |

### No prefix needed

| Keys | Action |
|---|---|
| `C-k` | Clear screen **and** scrollback history |
| Mouse drag | Select text (copies to clipboard on release) |
| Mouse wheel | Scroll (enters copy mode automatically) |
| Right-click | Context menus on panes, windows, status bar |
| Drag pane border | Resize panes |

### Config & plugins

| Keys | Action |
|---|---|
| `C-f r` (or `C-f R`) | Reload tmux.conf |
| `C-f I` | Install plugins listed in tmux.conf *(tpm)* |
| `C-f U` | Update plugins *(tpm)* |
| `C-f M-u` | Remove plugins no longer listed *(tpm)* |
| `C-f ?` | Searchable list of every binding |
| `C-f :` | tmux command prompt |
| `C-f t` | Clock 🕐 |

## Status Bar

The status bar displays:
- Current session name
- Window list with active indicator
- System information (time, date)
- Custom status text

Customise by editing `tmux.conf`:
```bash
set-option -g status-bg black
set-option -g status-fg white
set-option -g status-left "[#S] "
set-option -g status-right "%H:%M %d-%b-%y"
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
