# macOS Settings Documentation

Detailed explanations of all macOS system preferences configured by `macos.sh`.

## Overview

The `macos.sh` script applies customised system preferences to optimise the macOS environment for development. These settings enhance productivity, improve performance, and adjust system behaviour to match personal preferences.

## Finder Settings

### Show Hidden Files
```bash
defaults write com.apple.Finder AppleShowAllFiles -bool false
```
Hides hidden files by default in Finder. Toggle with `Cmd + Shift + .` in Finder.

### Expand Save Dialog
```bash
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
```
Automatically expands the file browser when opening "Save As" dialogs.

### Use Current Directory as Default Search Scope
```bash
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
```
Makes Finder search the current directory by default instead of all locations.

### Path Bar
```bash
defaults write com.apple.finder ShowPathbar -bool false
```
Hides the path bar in Finder (showing full directory path at bottom).

### Status Bar
```bash
defaults write com.apple.finder ShowStatusBar -bool false
```
Hides the status bar in Finder (showing file count and size info).

## System-Wide Settings

### Full Keyboard Access
```bash
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
```
Enables full keyboard navigation for all controls, allowing Tab to move through modal dialogs and menus. Essential for keyboard-driven workflows.

### Subpixel Font Rendering
```bash
defaults write NSGlobalDomain AppleFontSmoothing -int 2
```
Enables subpixel font rendering on non-Apple displays for smoother text appearance on external monitors.

### Disable Press-and-Hold for Keys
```bash
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
```
Disables the character selection popup when holding keys, preferring key repeat instead. Better for developers using keyboard shortcuts.

### Fast Keyboard Repeat Rate
```bash
defaults write NSGlobalDomain KeyRepeat -int 1
```
Sets keyboard repeat rate to maximum (1 = fastest). Improves responsiveness when holding keys for navigation.

### Short Key Repeat Delay
```bash
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```
Reduces delay before key repeat starts (15 = 225ms). Enables faster key repeat activation.

### Disable App Opening Dialog
```bash
defaults write com.apple.LaunchServices LSQuarantine -bool false
```
Disables the "Are you sure you want to open this application?" dialog for downloaded apps.

## Dock Settings

### Auto-Hide Dock
```bash
defaults write com.apple.dock autohide -bool true
```
Automatically hides the Dock when not in use, providing more screen space. Move mouse to bottom to reveal.

## Safari Settings

### Enable Debug Menu
```bash
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
```
Enables Safari's hidden debug menu for development and troubleshooting.

### Remove Bookmarks Bar Icons
```bash
defaults write com.apple.Safari ProxiesInBookmarksBar "()"
```
Removes default useless icons from Safari's bookmarks bar (like Top Sites, Reading List, etc.).

## Trackpad Settings

### Tap to Click
```bash
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
```
Enables tapping on trackpad to register as a click instead of requiring physical click.

## Commented Out Settings

The `macos.sh` script includes many commented-out settings. These are disabled by default but can be uncommented if desired:

### Display Settings
- Show all filename extensions
- Show ~/Library folder in Finder
- Show path in Finder title bar
- Display ASCII control characters

### Performance
- 2D Dock
- Disable window animations
- Disable Get Info animations

### Finder Behaviour
- Allow quitting Finder via Cmd+Q
- Show indicator lights in Dock
- Spring loading for Dock items

### Security
- Require password immediately after sleep
- Disable "reopen windows when logging back in"

### Auto-Correct
- Disable automatic spelling correction

### Disk Images
- Skip disk image verification
- Auto-open volumes when mounted

### Screenshots
- Disable shadow in screenshots
- Screenshots location

## Applying Settings

### Apply All Settings
```bash
./scripts/macos.sh
```

### Kill Affected Applications
The script automatically restarts these applications to apply changes:
- Finder
- Dock
- Mail
- System UI Server

For some settings to take effect, you may need to:
1. Log out and log back in
2. Restart the computer
3. Manually restart the application

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

## Customisation

To modify these settings:

1. Edit `scripts/macos.sh`
2. Uncomment desired settings or add new ones
3. Run `./scripts/macos.sh`
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

## Resources

- [macOS Defaults Documentation](https://macos-defaults.com/)
- [Awesome macOS Defaults](https://github.com/kevinSuttle/macOS-Defaults)
- `defaults` man page: `man defaults`

## Version Compatibility

These settings are compatible with:
- macOS 26.3+
- Most settings work on older versions

Some settings may not apply or work differently on older macOS versions. Test before deploying to critical machines.
