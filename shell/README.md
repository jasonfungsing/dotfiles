# Shell Configuration

Zsh configuration with custom aliases, theme, and productivity enhancements.

## File Structure

- **`zshrc`** - Main Zsh configuration
- **`alias_prompt.sh`** - Custom aliases and functions
- **`cobalt2.zsh-theme`** - Custom Zsh theme (Cobalt2)

## Quick Start

### Installation
```bash
# Symlink zshrc
ln -s ~/.dotfiles/shell/zshrc ~/.zshrc

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
- Loads custom aliases from `alias_prompt.sh`
- Sets up environment variables
- Configures plugin behaviour
- Initialises shell utilities (fnm, nvm, rbenv)

### alias_prompt.sh
Custom aliases and commands:
- **`v`** - Open Neovim
- **`u`** - Update everything (brew, casks, Oh-My-Zsh, Neovim plugins)
- **`vu`** - Update Neovim plugins only
- **`t`** - Start tmux
- **`gpa`** - Git pull all directories

### cobalt2.zsh-theme
Custom Zsh theme providing:
- Modern colour scheme
- Git status indicators
- Customised prompt display

## Available Aliases

### Development
```bash
v file.js          # Open file in Neovim
i                  # Open IntelliJ IDEA
k                  # kubectl
gc                 # gcloud
mnk                # minikube
```

### Package Management
```bash
u                  # Update everything
vu                 # Update Neovim plugins only
y                  # yarn
```

### Version Control
```bash
gpa                # Git pull all directories
```

### Utilities
```bash
t                  # tmux
weather London     # Check weather
```

## Adding Custom Aliases

### Temporary (current session only)
```bash
alias myalias="command"
```

### Permanent
1. Edit `alias_prompt.sh`
2. Add: `alias myalias="command"`
3. Reload shell: `source ~/.zshrc`

## Oh-My-Zsh Plugins

Enabled plugins provide additional aliases:
- **git** - Git shortcuts (ga, gc, gd, etc.)
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

## Documentation

For detailed alias reference, see:
- **[SHELL_ALIASES.md](../docs/SHELL_ALIASES.md)** - Complete aliases reference
- **[INSTALLATION.md](../docs/INSTALLATION.md)** - Full dotfiles installation

## See Also

- [Zsh Manual](http://zsh.sourceforge.net/)
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Zsh Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
