# System Configuration

macOS system settings, preferences, and configuration files.

## File Structure

- **`macos.sh`** - macOS system configuration script
- **`export-shortcuts.sh`** - Export keyboard shortcuts from system
- **`com.googlecode.iterm2.plist`** - iTerm2 terminal emulator settings
- **`keyboard-shortcuts.json`** - Custom keyboard shortcuts
- **`hushlogin`** - Terminal startup message control

## Quick Start

### Apply System Settings
```bash
# Run macOS configuration script
bash system/macos.sh

# Restore iTerm2 settings
# Preferences → General → Preferences
# Load preferences from folder: ~/.dotfiles/system/
```

### Manual Import
```bash
# Copy iTerm2 settings
cp system/com.googlecode.iterm2.plist ~/.config/iTerm2/

# Reload terminal
```

## Configuration Files Explained

### com.googlecode.iterm2.plist
**Purpose:** iTerm2 terminal emulator configuration

**Contains:**
- Terminal colour schemes
- Font settings
- Window arrangements
- Keyboard shortcuts
- Session profiles
- Advanced settings

**How to use:**
1. Open iTerm2
2. Go to: Preferences → General
3. Under "Preferences", select "Load preferences from a folder"
4. Point to: `~/.dotfiles/system/`
5. Restart iTerm2

**Customisation:**
- Edit plist file directly (advanced)
- Or modify in iTerm2 UI and export

---

### keyboard-shortcuts.json
**Purpose:** System-wide keyboard shortcuts

**Contains:**
- Application-specific shortcuts
- System shortcuts
- Custom keybindings

**Format:** JSON configuration file

**How to use:**
- Manually import to System Preferences
- Or use provided configuration

**macOS Shortcut Location:**
```
System Preferences → Keyboard → Shortcuts
```

---

### hushlogin
**Purpose:** Control terminal startup messages

**What it does:**
- Suppresses "Last login" message on terminal startup
- Cleans up terminal appearance on new sessions
- Simply by existing (empty file)

**Usage:**
```bash
# Already symlinked by install.sh
ls -la ~/.hushlogin
```

---

### macos.sh
**Purpose:** Automated macOS system configuration

**What it does:**
1. Configures system preferences
2. Sets keyboard repeat rates
3. Customises Finder behaviour
4. Adjusts Dock settings
5. Enables/disables system features
6. Applies security settings

**Usage:**
```bash
# Run configuration script
bash system/macos.sh

# May require sudo authentication
# Some settings require restart
```

**Configuration includes:**
- Keyboard repeat rate and delay
- Dock auto-hide and appearance
- Finder hidden files visibility
- Spotlight indexing settings
- Security and privacy preferences
- User interface customisations

**Customisation:**
Edit `macos.sh` to add or modify:
```bash
# Example: Change dock auto-hide
defaults write com.apple.dock autohide -bool true
killall Dock
```

**Important Notes:**
- Backup system settings before running
- Some settings require system restart
- May need to authenticate with sudo
- Test in safe environment first

---

### export-shortcuts.sh
**Purpose:** Export keyboard shortcuts from system configuration

**What it does:**
1. Reads current system keyboard shortcuts
2. Exports to JSON format
3. Stores configuration for backup/sharing

**Usage:**
```bash
# Export current keyboard shortcuts
bash system/export-shortcuts.sh

# Output: keyboard-shortcuts.json
```

**Output:**
- Exports to `keyboard-shortcuts.json`
- JSON format for easy sharing
- Can be imported into other systems

**Use cases:**
- Backup current shortcuts
- Share configuration with team
- Migrate shortcuts to new Mac
- Version control shortcuts in dotfiles

**Important Notes:**
- Run after customising keyboard shortcuts
- Updates existing `keyboard-shortcuts.json`
- Can be run periodically to capture changes

## System Settings Configuration

### Set via Script
```bash
# Apply all macOS settings
bash system/macos.sh
```

### Manual Configuration
Common macOS settings to configure:

**Keyboard:**
```bash
# Key repeat rate
defaults write -g KeyRepeat -int 1

# Initial key repeat delay
defaults write -g InitialKeyRepeat -int 10
```

**Dock:**
```bash
# Auto-hide dock
defaults write com.apple.dock autohide -bool true

# Reload dock
killall Dock
```

**Finder:**
```bash
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Reload Finder
killall Finder
```

**System Preferences:**
```bash
# Disable spotlight indexing of certain folders
defaults write com.apple.spotlight orderedItems
```

## Troubleshooting

### iTerm2 settings not loading
```bash
# Check plist file exists
ls -la ~/.dotfiles/system/com.googlecode.iterm2.plist

# Verify plist format
plutil -lint system/com.googlecode.iterm2.plist

# Restart iTerm2 completely
killall iTerm

# Open iTerm2 again
open -a iTerm
```

### Keyboard shortcuts not working
```bash
# Check shortcuts file
cat system/keyboard-shortcuts.json

# Verify JSON format
python3 -m json.tool system/keyboard-shortcuts.json

# Restart system services
sudo launchctl stop com.apple.securityd
sudo launchctl start com.apple.securityd
```

### Terminal startup messages still showing
```bash
# Verify hushlogin exists
ls -la ~/.hushlogin

# If missing, create symlink
ln -s ~/.dotfiles/system/hushlogin ~/.hushlogin
```

## Advanced Configuration

### Export Current Settings
```bash
# Export iTerm2 settings
defaults export com.googlecode.iterm2 - > iterm2-backup.plist

# Export keyboard shortcuts
defaults export com.apple.symbolichotkeys - > shortcuts-backup.plist
```

### Reset to Defaults
```bash
# Reset iTerm2
defaults delete com.googlecode.iterm2

# Reset keyboard shortcuts
defaults delete com.apple.symbolichotkeys

# Log out and back in, or restart
```

### List All Settings
```bash
# View all iTerm2 settings
defaults read com.googlecode.iterm2

# View all keyboard shortcuts
defaults read com.apple.symbolichotkeys
```

## Documentation

For system settings details, see:
- **[MACOS_SETTINGS.md](../docs/MACOS_SETTINGS.md)** - Complete macOS settings guide
- **[INSTALLATION.md](../docs/INSTALLATION.md)** - Full dotfiles installation

## See Also

- [macOS defaults Commands](https://macos-defaults.com/)
- [iTerm2 Documentation](https://iterm2.com/documentation.html)
- [System Preferences](https://support.apple.com/en-au/guide/mac-help/mh15217/mac)
