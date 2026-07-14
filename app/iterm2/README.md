# iTerm2 Configuration

iTerm2 terminal emulator settings.

## File Structure

- **`com.googlecode.iterm2.plist`** - iTerm2 terminal emulator settings

## What It Contains

- Terminal colour schemes
- Font settings
- Window and tab behaviour
- Keyboard shortcuts
- Session profiles
- Advanced settings

## How to Use

`install.sh` configures this automatically (after installing iTerm2 via the
Brewfile's `iterm2` cask): it points iTerm2's "Load settings from a custom
folder or URL" setting at this folder, skipping the step if iTerm2 isn't
installed. Quit iTerm2 before running the installer, or re-run it afterwards
— a running iTerm2 can overwrite the setting when it quits. The installer's
validation step (`./install.sh --validate`) checks the setting took effect.

To set it manually instead:

1. Open iTerm2
2. Go to: Settings → General → Settings
3. Tick "Load settings from a custom folder or URL"
4. Point to this folder (e.g. `~/Code/dotfiles/app/iterm2/`)
5. Restart iTerm2

## Customisation

- Edit plist file directly (advanced)
- Or modify in iTerm2 UI and export

## Troubleshooting

### Settings not loading
```bash
# Check plist file exists
ls -la ~/Code/dotfiles/app/iterm2/com.googlecode.iterm2.plist

# Verify plist format
plutil -lint ~/Code/dotfiles/app/iterm2/com.googlecode.iterm2.plist

# Check iTerm2 is pointed at this folder
defaults read com.googlecode.iterm2 PrefsCustomFolder

# Restart iTerm2 completely
killall iTerm2

# Open iTerm2 again
open -a iTerm
```

## Advanced

```bash
# Export current iTerm2 settings
defaults export com.googlecode.iterm2 - > iterm2-backup.plist

# Reset iTerm2 to defaults
defaults delete com.googlecode.iterm2

# View all iTerm2 settings
defaults read com.googlecode.iterm2
```

## See Also

- [iTerm2 Documentation](https://iterm2.com/documentation.html)
