# Installation & Validation Scripts

Automated scripts for setting up dotfiles, validating installation, and system configuration.

## File Structure

- **`install.sh`** - Main installation script
- **`validate-setup.sh`** - Validates dotfiles setup
- **`export-shortcuts.sh`** - Export keyboard shortcuts

## Quick Start

### Initial Setup
```bash
# Run main installation script
bash scripts/install.sh

# Validate installation
bash scripts/validate-setup.sh
```

### Apply System Settings
```bash
# Configure macOS settings (moved to system directory)
bash system/macos.sh
```

## Script Details

### install.sh
**Purpose:** Complete dotfiles setup automation

**What it does:**
1. Creates necessary directories
2. Symlinks configuration files to home directory
3. Installs Homebrew packages (via Brewfile)
4. Sets up Neovim configuration
5. Initialises shell environment

**Usage:**
```bash
bash scripts/install.sh
```

**Symlinks created:**
- `~/.zshrc` → `.dotfiles/shell/zshrc`
- `~/.config/nvim/init.lua` → `.dotfiles/editor/init.lua`
- `~/.tmux.conf` → `.dotfiles/terminal/tmux.conf`
- `~/.gitconfig` → `.dotfiles/git/gitconfig`

**Packages installed:**
- All formulas from Brewfile
- All casks from Brewfile
- All Mac App Store apps
- All VS Code extensions

---

### validate-setup.sh
**Purpose:** Verify dotfiles installation and system setup

**What it checks:**
- Symlink existence and validity
- Required tools installed (zsh, git, neovim, tmux, etc.)
- Homebrew status
- Development tools (Node.js, Python, Go)
- Shell configuration
- Oh-My-Zsh installation

**Usage:**
```bash
bash scripts/validate-setup.sh
```

**Output:**
```
═══ Shell Configuration ═══
✓ zshrc symlink exists
✓ Neovim init.lua symlink exists

═══ Homebrew ═══
✓ Homebrew is installed
✓ Homebrew is functional

═══ Key Packages ═══
✓ Git is installed
✓ Neovim is installed
✓ Docker is installed
```

---

---

### export-shortcuts.sh
**Purpose:** Export keyboard shortcuts from system configuration

**What it exports:**
- Custom keyboard shortcuts
- Application shortcuts
- System shortcuts

**Usage:**
```bash
bash scripts/export-shortcuts.sh
```

**Output location:**
- Exported to system configuration file

## Installation Workflow

### 1. Clone Repository
```bash
git clone https://github.com/jasonfungsing/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run Installation
```bash
bash scripts/install.sh
```

### 3. Configure macOS (Optional)
```bash
bash system/macos.sh
```

### 4. Validate Setup
```bash
bash scripts/validate-setup.sh
```

### 5. Reload Shell
```bash
source ~/.zshrc
# or
exec zsh
```

## Troubleshooting

### Installation fails
```bash
# Check script syntax
bash -n scripts/install.sh

# Run with verbose output
bash -x scripts/install.sh

# Check for errors
bash scripts/install.sh 2>&1 | tee install.log
```

### Symlinks not created
```bash
# Check if files exist
ls -la ~/.zshrc
ls -la ~/.config/nvim/init.lua

# Re-run installation
bash scripts/install.sh
```

### Validation fails
```bash
# Run full validation
bash scripts/validate-setup.sh

# Check specific tool
command -v neovim
```

### Homebrew issues
```bash
# Check Homebrew status
brew doctor

# Re-run bundle
brew bundle --file=~/.dotfiles/brew/Brewfile
```

## Manual Setup (Alternative)

If scripts fail, you can manually set up:

```bash
# Create directories
mkdir -p ~/.config/nvim

# Create symlinks
ln -s ~/.dotfiles/shell/zshrc ~/.zshrc
ln -s ~/.dotfiles/editor/init.lua ~/.config/nvim/init.lua
ln -s ~/.dotfiles/terminal/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig

# Install packages manually
brew bundle --file=~/.dotfiles/brew/Brewfile

# Reload shell
source ~/.zshrc
```

## Documentation

For more information, see:
- **[INSTALLATION.md](../docs/INSTALLATION.md)** - Complete installation guide
- **[MACOS_SETTINGS.md](../docs/MACOS_SETTINGS.md)** - System settings explanation

## See Also

- [Dotfiles GitHub Repository](https://github.com/jasonfungsing/dotfiles)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
