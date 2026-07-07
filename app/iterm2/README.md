# iTerm2 Configuration

iTerm2 terminal emulator settings.

## File Structure

- **`com.googlecode.iterm2.plist`** - iTerm2 terminal emulator settings

## What It Contains

- Terminal colour schemes
- Font settings
- Window arrangements
- Keyboard shortcuts
- Session profiles
- Advanced settings

## How to Use

Not handled by `install.sh` — iTerm2 only loads external preferences via a
setting that must be picked manually in the UI:

1. Open iTerm2
2. Go to: Settings → General → Preferences
3. Tick "Load preferences from a custom folder or URL"
4. Point to this folder (e.g. `~/Code/dotfiles/app/iterm2/`)
5. Restart iTerm2

## Customisation

- Edit plist file directly (advanced)
- Or modify in iTerm2 UI and export

## Troubleshooting

### Settings not loading
```bash
# Check plist file exists
ls -la ~/.dotfiles/app/iterm2/com.googlecode.iterm2.plist

# Verify plist format
plutil -lint app/iterm2/com.googlecode.iterm2.plist

# Restart iTerm2 completely
killall iTerm

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
