# Shell Aliases Reference

Complete documentation of all shell aliases and custom commands available in your environment.

## Terminal & Multiplexing

| Alias | Command | Purpose |
|-------|---------|---------|
| `t` | `tmux` | Start or attach to tmux session |
| `mux` | `tmuxinator` | Tmuxinator project manager |

## Development Tools

| Alias | Command | Purpose |
|-------|---------|---------|
| `v` | `vim` | Open Vim editor |
| `i` | `idea` | Open IntelliJ IDEA |

## Version Control & Git

| Alias | Command | Purpose |
|-------|---------|---------|
| `gpa` | `find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;` | Git pull all directories in current folder |
| `gc` | `gcloud` | Google Cloud CLI |
| `k` | `kubectl` | Kubernetes CLI |
| `mnk` | `minikube` | Minikube local Kubernetes |

## Package Management & Updates

| Alias | Command | Purpose |
|-------|---------|---------|
| `y` | `yarn` | Yarn package manager |
| `update` | `brew update; brew upgrade; brew upgrade --cask --greedy; brew cleanup; omz update; vim +PlugUpdate +qa` | Update all packages, casks, Oh-My-Zsh, and Vim plugins |
| `u` | `update` | Shorthand for update |
| `vu` | `vim +PlugUpdate +qa` | Update Vim plugins only |

## System & Utilities

| Alias | Command | Purpose |
|-------|---------|---------|
| `weather` | `curl wttr.in/$1.` | Check weather for a location (e.g., `weather London`) |
| `python` | `python3` | Use Python 3 by default |

## How to Use Aliases

### Running Aliases
Simply type the alias followed by any arguments:
```bash
# Open Vim
v myfile.txt

# Check weather
weather Sydney

# Update everything
u
```

### Creating Temporary Aliases
For the current session:
```bash
alias myalias="command"
```

### Adding Permanent Aliases
1. Edit `~/.alias_prompt.sh`
2. Add: `alias myalias="command"`
3. Reload shell: `source ~/.zshrc`

### Listing All Aliases
```bash
alias
```

### Removing an Alias
Temporarily remove for current session:
```bash
unalias myalias
```

Permanently remove:
1. Edit `~/.alias_prompt.sh`
2. Remove the alias line
3. Reload shell: `source ~/.zshrc`

## Oh-My-Zsh Plugins

Your Zsh configuration includes many Oh-My-Zsh plugins that provide additional aliases:

### Git Aliases (from git plugin)
```bash
ga .        # git add .
gcmsg       # git commit -m
gd          # git diff
gco         # git checkout
gbr         # git branch
```

### Common Plugin Aliases
- `git` - Git operations
- `tmux` - Terminal multiplexing
- `brew` - Homebrew operations
- `npm` - Node package manager
- `python` - Python operations
- `aws` - AWS CLI operations
- `kubectl` - Kubernetes operations

### Exploring Plugin Aliases
```bash
# List aliases from specific plugin
alias | grep "^g"  # Git aliases

# View plugin documentation
cat ~/.oh-my-zsh/plugins/git/git.plugin.zsh
```

## Custom Functions

The shell configuration includes custom functions:

### Prompt Context
Custom prompt display showing current user context.

### Keyboard Configuration
Fast keyboard repeat rate and short delay configured via shell settings.

## Environment Variables

Key environment variables configured:

| Variable | Value | Purpose |
|----------|-------|---------|
| `EDITOR` | `vim` | Default text editor |
| `NVM_DIR` | `~/.nvm` | Node Version Manager directory |
| `PATH` | Various | Search paths for executables |

## Customisation

### Adding New Aliases

Edit `~/.alias_prompt.sh`:
```bash
# Add new alias
alias myalias="command --flags"
```

Then reload:
```bash
source ~/.zshrc
```

### Modifying Existing Aliases

Find the alias in `~/.alias_prompt.sh`:
```bash
# Original
alias v="vim"

# Modified
alias v="nvim"  # Use Neovim instead
```

Reload:
```bash
source ~/.zshrc
```

### Documenting Aliases

Add comments above aliases for clarity:
```bash
# Open files with Neovim
alias v="nvim"

# Update everything quickly
alias u="brew update && brew upgrade"
```

## Tips & Tricks

### Abbreviate Long Commands
```bash
alias k8s="kubectl"
alias kx="kubectx"
alias tf="terraform"
```

### Group Related Commands
```bash
# Docker aliases
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
```

### Frequently Used Directories
```bash
alias proj="cd ~/Projects"
alias work="cd ~/work"
```

### Common Operations
```bash
alias ll="ls -la"
alias c="clear"
alias q="exit"
```

## Safety Aliases

The configuration includes defensive aliases:
```bash
# Confirm before dangerous operations
alias rm="rm -i"      # Prompt before delete
alias mv="mv -i"      # Prompt before overwrite
alias cp="cp -i"      # Prompt before overwrite
```

## Troubleshooting

### Alias Not Working
```bash
# Check if alias exists
alias myalias

# Reload shell configuration
source ~/.zshrc

# Check for conflicts with functions/commands
which myalias
type myalias
```

### Alias Conflicts with Commands
If an alias has the same name as a command:
```bash
# Use command directly (bypass alias)
\mycommand

# Or use full path
/usr/bin/mycommand
```

### Temporary Override
For current session only:
```bash
# Disable alias
unalias myalias

# Or use \command to bypass
\mycommand args
```

## Resources

- [Zsh Manual - Aliases](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Aliases)
- [Oh-My-Zsh Plugin Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
- [Bash/Zsh Alias Best Practices](https://www.gnu.org/software/bash/manual/html_node/Aliases.html)

## Advanced Usage

### Conditional Aliases
```bash
# Alias with conditions (requires function)
myfunction() {
  if [ $# -eq 0 ]; then
    # No arguments
    command
  else
    # With arguments
    command "$@"
  fi
}
alias mycommand="myfunction"
```

### Global Aliases
```bash
# Works anywhere in command line
alias -g STDLOG=">> /tmp/log"
```

Use with: `command STDLOG`

### Listing Alias Statistics
```bash
# Count aliases
alias | wc -l

# Find longest alias
alias | awk -F= '{print length, $0}' | sort -rn | head -5
```
