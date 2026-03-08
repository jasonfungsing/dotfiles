# Dotfiles

Personal development environment configuration and setup automation for macOS 26.3+.

## What This Is

This repository contains my dotfiles and an automated setup script to quickly bootstrap a new macOS machine with my preferred development environment, tools, and configurations. It includes shell configurations, editor settings, terminal multiplexer setup, Git configuration, macOS system preferences, and curated development tooling.

## Quick Start

```bash
git clone https://github.com/jasonfungsing/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
```

Then reload your terminal:
```bash
exec zsh
```

## Prerequisites

- **macOS 26.3 or later**
- **Command line tools** for Xcode (installed automatically by script)
- **Git** (installed automatically if needed)
- Administrator access (required for some macOS settings and Homebrew installation)

## What Gets Installed

### Dotfiles & Configurations
| File | Purpose |
|------|---------|
| `.zshrc` | Zsh shell configuration with aliases, plugins, and integrations |
| `.alias_prompt.sh` | Custom aliases and prompt configuration |
| `.vimrc` | Vim editor configuration |
| `.tmux.conf` | Terminal multiplexer (tmux) configuration |
| `.gitconfig` | Git version control configuration |
| `.hushlogin` | Suppresses macOS login message |
| `com.googlecode.iterm2.plist` | iTerm2 terminal settings |

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
- IDEs: Xcode, Visual Studio Code, IntelliJ IDEA
- Editors: Neovim
- Productivity: Raycast, Slack, Microsoft Office, WeChat, WhatsApp
- Development: Docker Desktop, iTerm2
- Security: Little Snitch, Grammarly
- Design: Final Cut Pro, PDF Expert, CARROTweather
- Media: AdBlock for Safari

### VS Code Extensions
Development extensions including Python, Go, Java, Docker, Kubernetes, GitHub integration, and AI coding assistants (Copilot, Claude).

## Installation

### Automatic Installation (Recommended)

The `install.sh` script automates the entire setup process:

```bash
./scripts/install.sh
```

**What it does:**
1. Creates symlinks for all dotfiles to your home directory
2. Installs Homebrew (if not already installed)
3. Installs Oh-My-Zsh framework
4. Sets Zsh as the default shell
5. Applies macOS system preferences
6. Installs all packages from Brewfile
7. Configures VS Code extensions

### Interactive Installation

For selective installation of components:

```bash
./scripts/install-interactive.sh
```

Choose which components to install:
- Shell configuration (zshrc, aliases, Oh-My-Zsh)
- Editor configuration (Vim, VS Code)
- Terminal configuration (tmux, iTerm2)
- Git configuration
- macOS system preferences
- Homebrew packages and applications

### Command-Line Flags

Install only specific components:

```bash
./scripts/install.sh --shell-only        # Only shell config
./scripts/install.sh --editor-only       # Only editor config
./scripts/install.sh --git-only          # Only Git config
./scripts/install.sh --system-only       # Only macOS settings
./scripts/install.sh --no-brew           # Skip Homebrew packages
./scripts/install.sh --no-apps           # Skip applications
./scripts/install.sh --dry-run           # Show what would be done
```

### Manual Installation

If you prefer to install manually:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jasonfungsing/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Create symlinks:**
   ```bash
   ln -s ~/.dotfiles/zshrc ~/.zshrc
   ln -s ~/.dotfiles/vimrc ~/.vimrc
   ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
   ln -s ~/.dotfiles/gitconfig ~/.gitconfig
   ```

3. **Install Homebrew:**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

4. **Install packages:**
   ```bash
   brew bundle --file=./Brewfile
   ```

5. **Set Zsh as default shell:**
   ```bash
   chsh -s $(which zsh)
   ```

## Customisation

### Modifying Aliases

Edit `alias_prompt.sh` and `zshrc` to add or modify aliases. See [Shell Aliases Documentation](docs/SHELL_ALIASES.md) for the complete list and explanations.

### Changing macOS Settings

Edit `scripts/macos.sh` to modify system preferences. See [macOS Settings Documentation](docs/MACOS_SETTINGS.md) for detailed explanations of each setting.

### Adding Packages

To add new Homebrew packages:

1. Edit `Brewfile` and add your package
2. Run `brew bundle` to install
3. Update lock file: `brew bundle lock --update`

See [Brewfile Documentation](docs/BREWFILE_EXPLAINED.md) for the complete package list and rationale.

### Updating Dependencies

To update all Homebrew packages and lock file:

```bash
brew bundle update
brew bundle lock --update
```

To update Brewfile.lock.json:

```bash
brew bundle lock --update
```

See [Brewfile Lock File Guide](docs/BREWFILE_LOCK.md) for detailed information.

## Directory Structure

```
dotfiles/
├── README.md                 # This file
├── CHANGELOG.md              # Version history and changes
├── Brewfile                  # Homebrew package definitions
├── Brewfile.lock.json        # Locked package versions
├── Brewfile.readme           # Brewfile format documentation
│
├── zshrc                     # Zsh shell configuration
├── alias_prompt.sh           # Custom aliases and prompt
├── cobalt2.zsh-theme         # Zsh theme
├── vimrc                     # Vim editor configuration
├── tmux.conf                 # tmux configuration
├── gitconfig                 # Git configuration
├── com.googlecode.iterm2.plist  # iTerm2 settings
├── hushlogin                 # Suppress login message
│
├── scripts/                  # Installation and setup scripts
│   ├── install.sh            # Main installation script
│   ├── validate-setup.sh     # Setup validation script
│   ├── macos.sh              # macOS system preferences
│   └── install-interactive.sh # Interactive installer (planned)
│
├── raycast-scripts/          # Raycast command scripts
│   ├── summarize-screen-ai.sh
│   └── summarize-screen.sh
│
└── docs/                     # Documentation
    ├── INSTALLATION.md       # Detailed installation guide
    ├── MACOS_SETTINGS.md     # macOS settings explanations
    ├── BREWFILE_EXPLAINED.md # Package list with rationale
    ├── BREWFILE_LOCK.md      # Lock file management
    ├── RAYCAST_SCRIPTS.md    # Raycast scripts documentation
    └── SHELL_ALIASES.md      # Shell aliases reference
```

## Troubleshooting

### Installation fails with permission errors

Run with appropriate permissions:
```bash
sudo ./scripts/install.sh
```

### Symlinks already exist

The installer will skip existing symlinks by default. To overwrite:
```bash
rm ~/.zshrc && ./scripts/install.sh
```

### Zsh not recognized as default shell

Verify installation:
```bash
echo $SHELL
```

If not zsh, run:
```bash
chsh -s $(which zsh)
```

### Homebrew installation fails

Ensure you have Command Line Tools installed:
```bash
xcode-select --install
```

### Package installation fails

Some packages may require additional dependencies. Check individual package documentation or run:
```bash
brew doctor
```

### macOS settings not applied

Some settings require a logout/login. To apply immediately:
```bash
killall Finder Dock Mail SystemUIServer
```

## Validation

After installation, validate your setup:

```bash
./scripts/validate-setup.sh
```

This checks:
- Dotfile symlinks are correctly created
- Required packages are installed
- Shell configuration is active
- macOS settings are applied

## Updating

To keep your environment up to date:

```bash
alias u="brew update; brew upgrade; brew upgrade --cask --greedy; brew cleanup; omz update; vim +PlugUpdate +qa"
u
```

Or use the automated update alias:
```bash
update  # or just 'u'
```

## Documentation

For detailed information, see:
- [Installation Guide](docs/INSTALLATION.md)
- [macOS Settings](docs/MACOS_SETTINGS.md)
- [Brewfile Packages](docs/BREWFILE_EXPLAINED.md)
- [Brewfile Lock File](docs/BREWFILE_LOCK.md)
- [Raycast Scripts](docs/RAYCAST_SCRIPTS.md)
- [Shell Aliases](docs/SHELL_ALIASES.md)

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
2. Review relevant [documentation files](docs/)
3. Check macOS and Homebrew documentation

---

**Last Updated**: March 8, 2026
**macOS Version**: 26.3+
**Shell**: Zsh
**Package Manager**: Homebrew
