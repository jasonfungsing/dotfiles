# macOS Configuration

macOS system settings, preferences, and configuration files.

## File Structure

- **`macos.sh`** - macOS system configuration script
- **`export-shortcuts.sh`** - Export keyboard shortcuts from system
- **`keyboard-shortcuts.json`** - Custom keyboard shortcuts
- **`hushlogin`** - Terminal startup message control

> iTerm2 settings have moved to [app/iterm2/](../app/iterm2/)

## Quick Start

### Apply System Settings
```bash
# Run macOS configuration script
bash mac/macos.sh
```

The script automatically restarts affected applications (Safari, Finder, Dock, Mail, System UI Server). Some settings only take effect after logging out and back in, or restarting.

## Configuration Files Explained

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

Applies customised system preferences to optimise the macOS environment for development. See [What Each Setting Does](#what-each-setting-does) below for details.

**Usage:**
```bash
# Run configuration script
bash mac/macos.sh

# May require sudo authentication
# Some settings require restart
```

**Important Notes:**
- Backup system settings before running
- Test in safe environment first
- Safari settings are TCC-protected on modern macOS; grant your terminal "Full Disk Access" in System Settings → Privacy & Security for them to apply

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
bash mac/export-shortcuts.sh

# Output: keyboard-shortcuts.json
```

**Use cases:**
- Backup current shortcuts
- Share configuration with team
- Migrate shortcuts to new Mac
- Version control shortcuts in dotfiles

**Important Notes:**
- Run after customising keyboard shortcuts
- Updates existing `keyboard-shortcuts.json`
- Can be run periodically to capture changes

## What Each Setting Does

Detailed explanations of the settings applied by `macos.sh`.

### Finder

**Show hidden files**
```bash
defaults write com.apple.Finder AppleShowAllFiles -bool false
```
Hides hidden files by default in Finder. Toggle with `Cmd + Shift + .` in Finder.

**Expand save dialog**
```bash
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
```
Automatically expands the file browser when opening "Save As" dialogs.

**Use current directory as default search scope**
```bash
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
```
Makes Finder search the current directory by default instead of all locations.

**Path bar**
```bash
defaults write com.apple.finder ShowPathbar -bool false
```
Hides the path bar in Finder (showing full directory path at bottom).

**Status bar**
```bash
defaults write com.apple.finder ShowStatusBar -bool false
```
Hides the status bar in Finder (showing file count and size info).

### System-Wide

**Full keyboard access**
```bash
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
```
Enables full keyboard navigation for all controls, allowing Tab to move through modal dialogs and menus. Essential for keyboard-driven workflows.

**Subpixel font rendering**
```bash
defaults write NSGlobalDomain AppleFontSmoothing -int 2
```
Enables subpixel font rendering on non-Apple displays for smoother text appearance on external monitors.

**Disable press-and-hold for keys**
```bash
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
```
Disables the character selection popup when holding keys, preferring key repeat instead. Better for developers using keyboard shortcuts.

**Fast keyboard repeat rate**
```bash
defaults write NSGlobalDomain KeyRepeat -int 1
```
Sets keyboard repeat rate to maximum (1 = fastest). Improves responsiveness when holding keys for navigation.

**Short key repeat delay**
```bash
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```
Reduces delay before key repeat starts (15 = 225ms). Enables faster key repeat activation.

**Disable app opening dialog**
```bash
defaults write com.apple.LaunchServices LSQuarantine -bool false
```
Disables the "Are you sure you want to open this application?" dialog for downloaded apps.

### Dock

**Auto-hide Dock**
```bash
defaults write com.apple.dock autohide -bool true
```
Automatically hides the Dock when not in use, providing more screen space. Move the mouse to the Dock's edge of the screen to reveal it.

**Dock position**
```bash
defaults write com.apple.dock orientation -string "right"
```
Positions the Dock on the right side of the screen.

### Safari

**Enable debug menu**
```bash
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
```
Enables Safari's hidden debug menu for development and troubleshooting.

**Remove bookmarks bar icons**
```bash
defaults write com.apple.Safari ProxiesInBookmarksBar "()"
```
Removes default useless icons from Safari's bookmarks bar (like Top Sites, Reading List, etc.).

### Trackpad

**Tap to click**
```bash
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
```
Enables tapping on trackpad to register as a click instead of requiring physical click.

### Commented Out Settings

The `macos.sh` script includes many commented-out settings. These are disabled by default but can be uncommented if desired:

- **Display:** show all filename extensions, show ~/Library folder in Finder, show path in Finder title bar, display ASCII control characters
- **Performance:** 2D Dock, disable window animations, disable Get Info animations
- **Finder behaviour:** allow quitting Finder via Cmd+Q, show indicator lights in Dock, spring loading for Dock items
- **Security:** require password immediately after sleep, disable "reopen windows when logging back in"
- **Auto-correct:** disable automatic spelling correction
- **Disk images:** skip disk image verification, auto-open volumes when mounted
- **Screenshots:** disable shadow in screenshots

## Customisation

To modify these settings:

1. Edit `mac/macos.sh`
2. Uncomment desired settings or add new ones
3. Run `bash mac/macos.sh`
4. Restart affected applications or log out/in

### Finding New Settings

To discover other macOS settings you can configure:

```bash
# List all defaults
defaults read

# List specific app defaults
defaults read com.apple.Finder

# Search for specific settings
defaults read | grep -i "searchterm"
```

### Testing Settings

Before applying globally, test a single setting:

```bash
# Read current value
defaults read NSGlobalDomain KeyRepeat

# Set new value
defaults write NSGlobalDomain KeyRepeat -int 2

# Test and revert if needed
defaults delete NSGlobalDomain KeyRepeat
```

## Reverting Settings

To revert to macOS defaults, run:
```bash
# Restore specific settings
defaults delete NSGlobalDomain AppleKeyboardUIMode

# Remove all custom settings
defaults delete NSGlobalDomain
defaults delete com.apple.Finder
defaults delete com.apple.dock
defaults delete com.apple.Safari
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad
```

Then restart applications:
```bash
killall Finder Dock Mail SystemUIServer
```

## Troubleshooting

### Keyboard shortcuts not working
```bash
# Check shortcuts file
cat mac/keyboard-shortcuts.json

# Verify JSON format
python3 -m json.tool mac/keyboard-shortcuts.json

# Restart system services
sudo launchctl stop com.apple.securityd
sudo launchctl start com.apple.securityd
```

### Terminal startup messages still showing
```bash
# Verify hushlogin exists
ls -la ~/.hushlogin

# If missing, create symlink (from the repo root)
ln -s "$(pwd)/mac/hushlogin" ~/.hushlogin
```

## Advanced Configuration

### Export Current Settings
```bash
# Export keyboard shortcuts
defaults export com.apple.symbolichotkeys - > shortcuts-backup.plist
```

### Reset to Defaults
```bash
# Reset keyboard shortcuts
defaults delete com.apple.symbolichotkeys

# Log out and back in, or restart
```

### List All Settings
```bash
# View all keyboard shortcuts
defaults read com.apple.symbolichotkeys
```

## Version Compatibility

These settings are compatible with macOS 26.3+, and most work on older versions. Some settings may not apply or work differently on older macOS versions — test before deploying to critical machines.

## See Also

- **[Main README](../README.md)** - Full dotfiles installation
- [iTerm2 configuration](../app/iterm2/) (moved to app/iterm2)
- [macOS Defaults Documentation](https://macos-defaults.com/)
- [Awesome macOS Defaults](https://github.com/kevinSuttle/macOS-Defaults)
- `defaults` man page: `man defaults`
- [System Preferences](https://support.apple.com/en-au/guide/mac-help/mh15217/mac)
