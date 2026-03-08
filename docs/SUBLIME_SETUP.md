# Sublime Text Configuration

Guide to Sublime Text setup and configuration via dotfiles.

## Overview

The dotfiles repository includes automated setup for Sublime Text configuration through the `sublime.sh` script. This script synchronises your Sublime Text settings with iCloud for cross-machine synchronisation.

## Setup

### Automatic Setup

The `sublime.sh` script is run during installation:

```bash
sh ~/.dotfiles/scripts/sublime.sh
```

### What It Does

The script:
1. Navigates to Sublime Text packages directory
2. Removes the default `User` folder
3. Creates a symbolic link to your iCloud-synced configuration
4. Enables cross-machine settings synchronisation

## iCloud Configuration

### Prerequisites

- Sublime Text installed
- iCloud Drive enabled
- iCloud folder path: `~/Library/Mobile Documents/com~apple~CloudDocs/Apps/Sublime/User`

### Sync Setup

The script creates:
- **From**: `~/.dotfiles/scripts/sublime.sh`
- **To**: Sublime Text `Packages/User` directory
- **Links to**: iCloud Apps/Sublime/User folder

### What Gets Synced

All Sublime Text configuration files:
- User preferences
- Keybindings
- Snippets
- Plugins
- Theme settings
- Package Control settings

## Manual Setup

If you prefer manual configuration:

```bash
# Navigate to Sublime packages
cd ~/Library/Application\ Support/Sublime\ Text/Packages

# Backup existing User folder
mv User User.backup

# Create symlink to iCloud
ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Apps/Sublime/User
```

## Configuration Files

### Main Settings
Location: `~/Library/Mobile Documents/com~apple~CloudDocs/Apps/Sublime/User/Preferences.sublime-settings`

### Keybindings
Location: `~/Library/Mobile Documents/com~apple~CloudDocs/Apps/Sublime/User/Default (OSX).sublime-keymap`

### Snippets
Location: `~/Library/Mobile Documents/com~apple~CloudDocs/Apps/Sublime/User/`

Saved as `.sublime-snippet` files

## Customising Configuration

### Edit via Sublime

1. Open Sublime Text
2. Click `Sublime Text` → `Preferences` → `Settings`
3. Edit in the right pane (User settings)
4. Changes sync automatically to iCloud

### Common Settings

```json
{
  "font_face": "Fira Code",
  "font_size": 12,
  "theme": "Default Dark.sublime-theme",
  "color_scheme": "Monokai.sublime-color-scheme",
  "word_wrap": true,
  "trim_trailing_white_space_on_save": true,
  "ensure_newline_before_close": true,
  "tab_size": 2,
  "translate_tabs_to_spaces": true
}
```

## Package Control

### Installation

If Package Control isn't installed:

1. Open Sublime Console: `Ctrl+`` (backtick)
2. Paste installation code from [packagecontrol.io](https://packagecontrol.io/installation)
3. Restart Sublime

### Recommended Packages

- **LSP** - Language Server Protocol support
- **SublimeLinter** - Code linting
- **Prettier** - Code formatting
- **GitGutter** - Git integration
- **Markdown Extended** - Markdown support
- **Theme - Material** - Material design theme

### Installing Packages

1. Open Command Palette: `Cmd+Shift+P`
2. Type: `Package Control: Install Package`
3. Search for package name
4. Press Enter to install

## Troubleshooting

### Symlink Already Exists

If you get "File exists" error:

```bash
# Check existing link
ls -la ~/Library/Application\ Support/Sublime\ Text/Packages/User

# Remove and try again
rm ~/Library/Application\ Support/Sublime\ Text/Packages/User
sh ~/.dotfiles/scripts/sublime.sh
```

### Settings Not Syncing

1. Check iCloud status: `System Preferences` → `Apple ID` → `iCloud`
2. Verify iCloud Drive is enabled
3. Check folder exists: `~/Library/Mobile Documents/com~apple~CloudDocs/Apps/Sublime/User`

If missing, create it manually and copy settings.

### iCloud Path Different

If your iCloud path differs, edit `sublime.sh`:

```bash
# Update this line with your path
ln -s /path/to/your/icloud/Sublime/User ~/Library/Application\ Support/Sublime\ Text/Packages/User
```

### Permissions Error

If permissions denied:

```bash
# Fix permissions
chmod 755 ~/Library/Application\ Support/Sublime\ Text/Packages
```

## Multi-Machine Setup

### First Machine

1. Run `sublime.sh` on your first machine
2. Configure Sublime settings as desired
3. Settings automatically sync to iCloud

### Additional Machines

1. Install Sublime Text
2. Run `sublime.sh` in dotfiles
3. Settings automatically restore from iCloud

## Backing Up Settings

### Manual Backup

```bash
# Backup to file
cp -r ~/Library/Mobile\ Documents/com~apple~CloudDocs/Apps/Sublime/User ~/Documents/Sublime-backup-$(date +%Y%m%d)
```

### Version Control

To version control Sublime settings:

```bash
# Symlink to dotfiles
ln -s ~/.dotfiles/sublime-user ~/.dotfiles/sublime-user-backup
```

Then add to git:

```bash
git add sublime-user-backup/
git commit -m "chore: backup sublime settings"
```

## Resetting Configuration

### Reset to Default

```bash
# Move current settings
mv ~/Library/Mobile\ Documents/com~apple~CloudDocs/Apps/Sublime/User ~/Documents/Sublime-backup

# Sublime will create new default settings on restart
```

### Restore from Backup

```bash
# Remove symlink
rm ~/Library/Application\ Support/Sublime\ Text/Packages/User

# Restore backup
cp -r ~/Documents/Sublime-backup ~/Library/Mobile\ Documents/com~apple~CloudDocs/Apps/Sublime/User

# Re-create symlink
ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Apps/Sublime/User ~/Library/Application\ Support/Sublime\ Text/Packages/User
```

## Additional Resources

- [Sublime Text Documentation](https://www.sublimetext.com/docs/)
- [Package Control Documentation](https://packagecontrol.io/)
- [Settings Best Practices](https://www.sublimetext.com/docs/settings)
- [Keyboard Shortcuts Guide](https://www.sublimetext.com/docs/key_bindings)

## Tips & Tricks

### Command Palette
- Open: `Cmd+Shift+P`
- Type command names to execute
- Searchable and customisable

### Quick Open
- Open: `Cmd+P`
- Jump to any file in project
- Use `@` for symbols, `:` for line numbers

### Multi-Selection
- Click to select multiple locations
- Edit all at once with `Cmd+D`

### Split View
- Menu: `View` → `Layout` → `Columns` or `Rows`
- Drag tabs to split panes
- Open file in adjacent pane: `Cmd+Shift+P` → `Open In` 

### Distraction-Free Mode
- Menu: `View` → `Enter Distraction Free Mode`
- Or: `Ctrl+Shift+Cmd+F`
