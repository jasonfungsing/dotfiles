# Installation Guide

Complete step-by-step guide for installing and configuring your dotfiles environment.

## Prerequisites

Before installing, ensure you have:
- **macOS 26.3 or later**
- **Administrator privileges** (needed for system settings and package management)
- **Internet connection** (for downloading packages and tools)
- **Approximately 5-10 GB of free disk space** (for all packages)

## Quick Installation

For the fastest setup with all default options:

```bash
git clone https://github.com/jasonfungsing/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
exec zsh
```

The script will automatically:
1. Install Homebrew (if needed)
2. Create symlinks for dotfiles
3. Install Oh-My-Zsh
4. Set Zsh as default shell
5. Apply macOS preferences
6. Install all packages from Brewfile
7. Configure VS Code extensions

## Installation Modes

### 1. Automatic Installation (Default)

```bash
./scripts/install.sh
```

Installs everything with default configuration.

**Time estimate:** 20-45 minutes (depending on internet speed and disk speed)

### 2. Interactive Installation

For selective installation with a menu interface:

```bash
./scripts/install-interactive.sh
```

Choose which components to install:
- ✓ Shell configuration (Zsh, aliases, Oh-My-Zsh, theme)
- ✓ Editor configuration (Vim settings)
- ✓ Terminal configuration (tmux, iTerm2)
- ✓ Git configuration
- ✓ macOS system preferences
- ✓ Homebrew packages
- ✓ Applications (Casks)
- ✓ VS Code extensions

**Time estimate:** 15-40 minutes (depending on selections)

### 3. Selective Installation with Flags

Install only specific components:

```bash
# Only shell configuration
./scripts/install.sh --shell-only

# Only editor configuration
./scripts/install.sh --editor-only

# Only Git configuration
./scripts/install.sh --git-only

# Only terminal configuration
./scripts/install.sh --terminal-only

# Only system preferences (no package installation)
./scripts/install.sh --system-only

# Install everything except Homebrew packages
./scripts/install.sh --no-brew

# Install everything except applications
./scripts/install.sh --no-apps

# Show what would be done without making changes
./scripts/install.sh --dry-run

# Combine flags (e.g., no brew and no apps)
./scripts/install.sh --no-brew --no-apps
```

**Time estimate:** 5-10 minutes (depending on selections)

### 4. Manual Installation

If you prefer granular control:

#### Step 1: Clone Repository

```bash
git clone https://github.com/jasonfungsing/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

#### Step 2: Create Symlinks

```bash
# Shell configuration
ln -s ~/.dotfiles/shell/zshrc ~/.zshrc
ln -s ~/.dotfiles/shell/alias_prompt.sh ~/.alias_prompt.sh

# Editor configuration
ln -s ~/.dotfiles/editor/vimrc ~/.vimrc

# Terminal configuration
ln -s ~/.dotfiles/terminal/tmux.conf ~/.tmux.conf

# Git configuration
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig

# System configuration
ln -s ~/.dotfiles/system/hushlogin ~/.hushlogin
```

#### Step 3: Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then add Homebrew to PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jasonfungsing/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

#### Step 4: Install Oh-My-Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Step 5: Set Zsh as Default Shell

```bash
# Check if zsh is in /etc/shells
grep "$(command -v zsh)" /etc/shells || echo "$(command -v zsh)" | sudo tee -a /etc/shells

# Set as default
chsh -s "$(command -v zsh)"
```

#### Step 6: Install Packages

```bash
# Install all packages from Brewfile
brew bundle --file=~/.dotfiles/Brewfile

# Or install only specific formulas/casks
brew bundle --file=~/.dotfiles/Brewfile install
```

#### Step 7: Apply macOS Settings

```bash
sh ~/.dotfiles/scripts/macos.sh
```

#### Step 8: Reload Shell

```bash
exec zsh
```

## Verification

After installation, verify everything is set up correctly:

```bash
./scripts/validate-setup.sh
```

This checks:
- ✓ Dotfile symlinks are in place
- ✓ Zsh is the default shell
- ✓ Required packages are installed
- ✓ Shell configuration is working

### Manual Verification

Check individual components:

```bash
# Verify shell
echo $SHELL  # Should show /opt/homebrew/bin/zsh or /usr/bin/zsh

# Verify aliases work
alias | grep "^t="  # Should show tmux alias

# Verify git configuration
git config user.name  # Should show your name

# Verify homebrew
brew --version

# Verify kubectl (if installed)
kubectl version --client
```

## Troubleshooting

### Installation Script Fails

**Problem:** Script exits with error
```bash
./scripts/install.sh: line X: error...
```

**Solution:**
1. Ensure you're in the dotfiles directory: `cd ~/.dotfiles`
2. Make script executable: `chmod +x ./scripts/install.sh`
3. Run with bash explicitly: `bash ./scripts/install.sh`
4. Check internet connection
5. Review error message for specific issues

### Symlinks Already Exist

**Problem:** `ln: /Users/username/.zshrc: File exists`

**Solution:**
Option 1 - Back up existing files manually:
```bash
mv ~/.zshrc ~/.zshrc.backup
./scripts/install.sh
```

Option 2 - Remove and reinstall:
```bash
rm ~/.zshrc
./scripts/install.sh
```

### Permission Denied

**Problem:** `Permission denied` errors during installation

**Solution:**
```bash
sudo ./scripts/install.sh
```

Or run individual commands with sudo:
```bash
sudo chsh -s $(which zsh)
```

### Zsh Not Set as Default Shell

**Problem:** `echo $SHELL` still shows `/bin/bash`

**Solution:**
```bash
# Verify zsh location
which zsh

# Add to shells if needed
sudo sh -c 'echo /opt/homebrew/bin/zsh >> /etc/shells'

# Set as default
chsh -s /opt/homebrew/bin/zsh
```

### Homebrew Installation Fails

**Problem:** `brew: command not found` or installation fails

**Solution:**
1. Ensure Command Line Tools are installed:
   ```bash
   xcode-select --install
   ```
2. Check disk space:
   ```bash
   df -h
   ```
3. Run Homebrew doctor:
   ```bash
   brew doctor
   ```

### Package Installation Fails

**Problem:** `brew bundle` fails on specific package

**Solution:**
1. Install packages individually:
   ```bash
   brew install <package-name>
   ```
2. Check package exists:
   ```bash
   brew search <package-name>
   ```
3. Check Brewfile syntax
4. See [Brewfile Explained](BREWFILE_EXPLAINED.md) for package information

### macOS Settings Not Applied

**Problem:** System preferences unchanged

**Solution:**
1. Re-run macOS script:
   ```bash
   ./scripts/macos.sh
   ```
2. Restart affected applications:
   ```bash
   killall Finder Dock Mail SystemUIServer
   ```
3. Log out and back in for some settings
4. See [macOS Settings](MACOS_SETTINGS.md) for what should change

## Post-Installation

### Update Everything

```bash
# One-time update
brew update
brew upgrade
brew upgrade --cask --greedy
brew cleanup
omz update

# Or use the alias
update  # or 'u'
```

### Add Private Configuration

Create `~/.zshrc.private` for machine-specific settings:
```bash
# ~/.zshrc.private
export API_KEY="your-key"
alias work="cd /path/to/work"
```

This file is sourced automatically and won't be tracked by git.

### Next Steps

1. Review [Shell Aliases](SHELL_ALIASES.md) to learn available commands
2. Customize [macOS Settings](MACOS_SETTINGS.md) to your preference
3. Explore [Brewfile Packages](BREWFILE_EXPLAINED.md) for installed tools
4. Check [Raycast Scripts](RAYCAST_SCRIPTS.md) for productivity commands

## Uninstallation

To remove dotfiles configuration:

```bash
# Remove symlinks
rm ~/.zshrc
rm ~/.vimrc
rm ~/.tmux.conf
rm ~/.gitconfig
rm ~/.alias_prompt.sh
rm ~/.hushlogin

# Set bash back as default shell
chsh -s /bin/bash

# Remove dotfiles directory (if desired)
rm -rf ~/.dotfiles
```

## Getting Help

For issues:
1. Check the [README Troubleshooting](../README.md#troubleshooting) section
2. Review relevant documentation files
3. Check individual tool documentation:
   - Homebrew: `brew help`
   - Zsh: `man zsh`
   - tmux: `man tmux`

## Performance Tips

If installation is slow:

1. **Parallel package installation:**
   ```bash
   brew install --verbose <package-name>
   ```

2. **Install without casks (faster):**
   ```bash
   ./scripts/install.sh --no-apps
   ```

3. **Check disk space:**
   ```bash
   df -h
   ```

4. **Improve internet:**
   - Use wired connection if possible
   - Close bandwidth-intensive applications

## Estimated Time Breakdown

| Component | Time |
|-----------|------|
| Clone repository | 1-2 min |
| Create symlinks | 1 min |
| Install Homebrew | 5-10 min |
| Install Oh-My-Zsh | 2-3 min |
| Install packages | 10-20 min |
| Apply system settings | 2-3 min |
| Total | 25-45 min |

Actual time varies based on:
- Internet speed
- Disk speed (SSD vs HDD)
- Number of packages installed
- System load
