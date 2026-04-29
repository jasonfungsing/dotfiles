# Terminal Multiplexer Configuration

tmux configuration for terminal multiplexing, window management, and productivity.

## File Structure

- **`tmux.conf`** - tmux configuration and keybindings

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
- ✅ Seamless pane navigation (with vim-tmux-navigator)
- ✅ Vi-like keybindings for copy mode
- ✅ Custom status bar
- ✅ Plugin support (via tpm)

## Core Keybindings

### Session Management
```bash
tmux new-session -s name      # Create new session
tmux list-sessions            # List all sessions
tmux attach-session -t name   # Attach to session
tmux kill-session -t name     # Kill session
```

### Window Management
```bash
Prefix + c                    # Create new window
Prefix + n                    # Next window
Prefix + p                    # Previous window
Prefix + w                    # List windows
Prefix + &                    # Kill window
Prefix + ,                    # Rename window
```

### Pane Management
```bash
Prefix + %                    # Split pane vertically
Prefix + "                    # Split pane horizontally
Prefix + arrow keys           # Navigate panes
Prefix + x                    # Kill pane
Prefix + z                    # Zoom pane (toggle)
```

### Copy Mode
```bash
Prefix + [                    # Enter copy mode
j/k                           # Move down/up
w/b                           # Move forward/backward word
/                             # Search forward
?                             # Search backward
Space                         # Start selection
Enter                         # Copy selection
Prefix + ]                    # Paste
```

## Prefix Key

Default prefix: `Ctrl + b`

To customise, edit `tmux.conf`:
```bash
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix
```

## Mouse Support

Mouse support is enabled:
- Click to select pane
- Scroll to navigate in copy mode
- Click and drag to select text

Toggle mouse:
```bash
# Inside tmux
Prefix + m                    # Toggle mouse on/off
```

## Integration with Vim/Neovim

Navigate between tmux panes and vim splits seamlessly with vim-tmux-navigator plugin.

**From tmux pane to vim:**
```bash
Ctrl + h/j/k/l               # Navigate left/down/up/right
```

**From vim to tmux pane:**
```bash
Ctrl + h/j/k/l               # Navigate left/down/up/right
```

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

### Popular Plugins
- `tmux-plugins/tmux-resurrect` - Restore tmux sessions
- `tmux-plugins/tmux-continuum` - Continuous session saving
- `tmux-plugins/tmux-sensible` - Sensible defaults
- `christoomey/vim-tmux-navigator` - Seamless vim/tmux navigation

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
# Ensure vim-tmux-navigator is installed
# Check tmux version (2.3+ required for some features)
tmux -V

# Test basic navigation
Prefix + hjkl
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

For detailed tmux information, see:
- **[INSTALLATION.md](../docs/INSTALLATION.md)** - Full dotfiles installation

## See Also

- [tmux Manual](http://man.openbsd.org/tmux)
- [tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- [Vim Tmux Navigator](https://github.com/christoomey/vim-tmux-navigator)
- [tmux Cheat Sheet](https://cheatsheets.quartermaster.me/tmux.html)
