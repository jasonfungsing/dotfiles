# Dotfiles

Personal development environment configuration and setup automation for macOS 26.3+.

## What This Is

This repository contains my dotfiles and an automated setup script to quickly bootstrap a new macOS machine with my preferred development environment, tools, and configurations. It includes shell configurations, editor settings, terminal multiplexer setup, Git configuration, macOS system preferences, and curated development tooling.

## Quick Start

```bash
git clone https://github.com/jasonfungsing/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
exec zsh
```

## Prerequisites

- **macOS 26.3 or later**
- **Command line tools** for Xcode (installed automatically by script)
- **Git** (installed automatically if needed)
- Administrator access (required for some macOS settings and Homebrew installation)
- Internet connection (for downloading packages and tools)
- Approximately 5-10 GB of free disk space (for all packages)

## What Gets Installed

### Dotfiles & Configurations
| File | Purpose |
|------|---------|
| `.zshrc` | Zsh shell configuration with aliases, plugins, and integrations |
| `.alias_prompt.sh` | Custom aliases and prompt configuration |
| `.config/nvim/init.lua` | Neovim editor configuration (pure Lua) |
| `.tmux.conf` | Terminal multiplexer (tmux) configuration |
| `.gitconfig` | Git version control configuration |
| `.hushlogin` | Suppresses macOS login message |

### Homebrew Packages (100+)
Organized by category:
- **DevOps & Cloud**: Docker, Kubernetes, Helm, AWS CLI, GCloud, Skaffold, Kops, Minikube, Kind
- **Development**: Go, Node.js, Python, Java, Ruby, Rust support
- **Build Tools**: Maven, Gradle, Make, CMake, Protobuf
- **CLI Utilities**: git, tmux, kubectl, lazygit, ripgrep, fzf, jq, curl, wget, htop
- **Language Tools**: golangci-lint, rustfmt, shellcheck, pylint
- **Databases**: RocksDB, Temporal
- **Miscellaneous**: GraphQL, Pandoc, Tesseract OCR, Figlet

### Applications (via Homebrew Cask & Mac App Store)
- IDEs: Xcode, Visual Studio Code, Antigravity IDE
- Terminal: iTerm2 (+ Powerline fonts)
- Browsers: Google Chrome
- AI assistants: Claude desktop, Gemini
- Productivity: Raycast, Slack, Setapp, Logi Options+
- Security: Little Snitch, Okta Verify
- Media: AdBlock for Safari, Dark Reader for Safari

### VS Code Extensions
Development extensions including Python, Go, Docker, GitHub integration, and Claude Code.

## Installation

### Automatic Installation (Recommended)

The `install.sh` script automates the entire setup process:

```bash
./install.sh
```

**What it does (in order — apps install before their configs):**
1. Installs Homebrew, then all Brewfile packages, applications, and VS Code extensions
2. Uninstalls brew packages, casks, taps, and VS Code extensions **not** declared in the Brewfile (the Brewfile is the source of truth — skip with `--no-prune`)
3. Installs Oh-My-Zsh and sets Zsh as the default shell
4. Creates symlinks for all dotfiles to your home directory
5. Installs tmux plugins and points iTerm2 at its config folder (app/iterm2/)
6. Sets up the Neovim configuration
7. Applies macOS system preferences and keyboard shortcuts
8. Validates the finished setup

**Failure handling:** the installer only aborts up front for system-wide
problems (not macOS, no network, incomplete repo clone). After that, a
failing step never stops the run — the remaining steps continue, and every
failure is listed in a summary at the end (with a non-zero exit code).
Fix the causes and re-run; all steps are idempotent.

A full installation takes roughly 25-45 minutes, depending on internet and disk speed.

### Command-Line Flags

Install only specific components:

```bash
./install.sh --shell-only        # Only shell config
./install.sh --editor-only       # Only editor config
./install.sh --git-only          # Only Git config
./install.sh --terminal-only     # Only terminal config
./install.sh --system-only       # Only macOS settings
./install.sh --no-brew           # Skip Homebrew packages
./install.sh --no-apps           # Skip applications
./install.sh --dry-run           # Show what would be done
```

Flags can be combined, e.g. `./install.sh --no-brew --no-apps`.

### Manual Installation

If you prefer to install manually:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jasonfungsing/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Create symlinks:**
   ```bash
   ln -s ~/.dotfiles/terminal/zshrc ~/.zshrc
   ln -s ~/.dotfiles/terminal/alias_prompt.sh ~/.alias_prompt.sh
   mkdir -p ~/.config/nvim
   ln -s ~/.dotfiles/neovim/init.lua ~/.config/nvim/init.lua
   ln -s ~/.dotfiles/terminal/tmux.conf ~/.tmux.conf
   ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
   ln -s ~/.dotfiles/mac/hushlogin ~/.hushlogin
   ```

3. **Install Homebrew** and add it to your PATH:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

4. **Install Oh-My-Zsh:**
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

5. **Install packages:**
   ```bash
   brew bundle --file=./brew/Brewfile
   ```

6. **Set Zsh as default shell:**
   ```bash
   grep "$(command -v zsh)" /etc/shells || echo "$(command -v zsh)" | sudo tee -a /etc/shells
   chsh -s "$(command -v zsh)"
   ```

7. **Apply macOS settings:**
   ```bash
   sh ~/.dotfiles/mac/macos.sh
   ```

8. **Reload your shell:**
   ```bash
   exec zsh
   ```

On first launch, Neovim bootstraps lazy.nvim and installs all plugins automatically — no manual steps needed. See the [Neovim documentation](neovim/README.md) for details.

## Customisation

### Modifying Aliases

Edit `alias_prompt.sh` and `zshrc` to add or modify aliases. See the [terminal documentation](terminal/README.md) for the complete list and explanations.

### Private Configuration

Create `~/.zshrc.private` for machine-specific settings:

```bash
# ~/.zshrc.private
export API_KEY="your-key"
alias work="cd /path/to/work"
```

This file is sourced automatically and won't be tracked by git.

### Changing macOS Settings

Edit `mac/macos.sh` to modify system preferences. See the [macOS documentation](mac/README.md) for detailed explanations of each setting.

### Adding Packages

To add new Homebrew packages:

1. Edit `Brewfile` and add your package
2. Run `brew bundle install --file=brew/Brewfile` to install

See the [Homebrew documentation](brew/README.md) for the complete package list and rationale.

### Updating Dependencies

To update all Homebrew packages:

```bash
brew update
brew upgrade
```

## Directory Structure

```
dotfiles/
├── README.md                 # This file
├── CHANGELOG.md              # Version history and changes
├── install.sh                # Main installation script
│
├── brew/                     # Homebrew configuration
│   └── Brewfile              # Homebrew package definitions
│
├── neovim/                   # Neovim editor configuration
│   ├── init.lua              # Entry point (pure Lua)
│   ├── config/               # Core settings and autocmds
│   ├── keymaps/              # Key mappings
│   ├── plugins/              # Plugin specs
│   ├── theme/                # Colourscheme
│   └── utils/                # Helper utilities
│
├── terminal/                 # Terminal configuration (zsh + tmux)
│   ├── zshrc                 # Zsh shell configuration
│   ├── alias_prompt.sh       # Custom aliases and prompt
│   ├── cobalt2.zsh-theme     # Zsh theme
│   └── tmux.conf             # tmux configuration
│
├── git/                      # Git configuration
│   └── gitconfig             # Git version control configuration
│
├── app/                      # Application configuration
│   └── iterm2/
│       └── com.googlecode.iterm2.plist  # iTerm2 terminal settings
│
└── mac/                      # macOS system configuration
    ├── macos.sh              # macOS system preferences script
    ├── export-shortcuts.sh   # Export keyboard shortcuts to JSON
    ├── keyboard-shortcuts.json  # Saved keyboard shortcuts
    └── hushlogin             # Suppress macOS login message
```

## Troubleshooting

### Installation script fails

If the script exits with an error:
1. Ensure you're in the dotfiles directory: `cd ~/.dotfiles`
2. Make the script executable: `chmod +x ./install.sh`
3. Run with bash explicitly: `bash ./install.sh`
4. Check your internet connection and review the error message

### Installation fails with permission errors

Run with appropriate permissions:
```bash
sudo ./install.sh
```

### Symlinks already exist

No action needed — the installer is safe to re-run and always converges on
this repo's state. Correct symlinks are left alone, wrong or dangling ones
are re-pointed, and a pre-existing real file is backed up to
`<name>.backup.<timestamp>` before being replaced, so nothing is lost.

Or remove it outright:
```bash
rm ~/.zshrc && ./install.sh
```

### Zsh not recognised as default shell

Verify installation:
```bash
echo $SHELL
```

If not zsh, ensure it is listed in `/etc/shells` and set it as default:
```bash
grep "$(command -v zsh)" /etc/shells || echo "$(command -v zsh)" | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

### Homebrew installation fails

Ensure you have Command Line Tools installed:
```bash
xcode-select --install
```

Also check free disk space (`df -h`) and run `brew doctor`.

### Package installation fails

Some packages may require additional dependencies. Check individual package documentation or run:
```bash
brew doctor
```

If `brew bundle` fails on a specific package, verify it exists with `brew search <package-name>` and try installing it individually with `brew install <package-name>`.

### macOS settings not applied

Re-run the settings script:
```bash
./mac/macos.sh
```

Some settings require a logout/login. To apply immediately:
```bash
killall Finder Dock Mail SystemUIServer
```

## Validation

A full `./install.sh` run validates the setup automatically at the end. To
validate on its own — after a partial install, or any time something feels
off:

```bash
./install.sh --validate
```

This checks:
- Every symlink exists, points at the right file in this repo, and resolves (dangling symlinks fail)
- Configs actually load: zsh syntax + interactive startup, Neovim headless launch, tmux config parse, git user.name
- Zsh is the default shell and Oh-My-Zsh is present
- `brew bundle check` confirms the machine matches the Brewfile
- Key tools (git, jq, node, python3, go) are on the PATH

It exits 0 only when every check passes.

You can also spot-check individual components manually:

```bash
echo $SHELL           # Should show /opt/homebrew/bin/zsh or /usr/bin/zsh
alias | grep "^t="    # Should show tmux alias
git config user.name  # Should show your name
brew --version        # Should show Homebrew version
```

## Updating

To keep your environment up to date:

```bash
u  # Update all packages, casks, Oh-My-Zsh, and Neovim plugins
```

Or use the full command:
```bash
update  # Alias for: brew update; brew upgrade; brew upgrade --cask --greedy; brew cleanup; omz update; nvim +Lazy sync +qa
```

## Uninstallation

To remove the dotfiles configuration:

```bash
# Remove symlinks
rm ~/.zshrc
rm ~/.tmux.conf
rm ~/.gitconfig
rm ~/.alias_prompt.sh
rm ~/.hushlogin
rm ~/.config/nvim/init.lua

# Set bash back as default shell
chsh -s /bin/bash

# Remove dotfiles directory (if desired)
rm -rf ~/.dotfiles
```

## Documentation

For detailed information, see:
- [macOS Settings](mac/README.md)
- [Homebrew Packages & Lock File](brew/README.md)
- [Shell Aliases & Terminal Setup](terminal/README.md)
- [Neovim Setup](neovim/README.md)

## Technology Stack

This dotfiles configuration supports a modern development stack focused on:
- **Cloud & DevOps**: Docker, Kubernetes, AWS, Google Cloud
- **Backend Development**: Go, Python, Node.js, Java, Ruby
- **Development Tools**: Git, tmux, Vim, VS Code
- **Infrastructure**: Helm, Kops, Minikube, Skaffold

## Contributing

These are personal dotfiles, but feel free to fork and adapt to your needs.

## License

Personal use only. Feel free to use as reference for your own dotfiles.

## Support

For issues or questions:
1. Check [Troubleshooting](#troubleshooting) section
2. Review the relevant folder's README ([brew](brew/README.md), [mac](mac/README.md), [terminal](terminal/README.md), [neovim](neovim/README.md))
3. Check macOS and Homebrew documentation (`brew help`, `man zsh`, `man tmux`)

---

**Last Updated**: March 8, 2026
**macOS Version**: 26.3+
**Shell**: Zsh
**Package Manager**: Homebrew
