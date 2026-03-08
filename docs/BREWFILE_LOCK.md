# Brewfile Lock File Management

Guide to understanding and managing the `Brewfile.lock.json` file.

## What is Brewfile.lock.json?

The lock file (`Brewfile.lock.json`) records the exact versions of all installed packages at a specific point in time. It ensures reproducible installations across machines and sessions.

## When to Update

### Automatic Updates
The lock file is automatically updated when you:
1. Install a new package: `brew install <package>`
2. Upgrade packages: `brew upgrade`
3. Run bundle update: `brew bundle update`

### Manual Update
Explicitly update without changing packages:
```bash
brew bundle lock --file=~/.dotfiles/Brewfile --update
```

## Common Tasks

### Update All Packages and Lock File
```bash
brew bundle update --file=~/.dotfiles/Brewfile
brew bundle lock --file=~/.dotfiles/Brewfile --update
```

### Update Lock File Only
```bash
brew bundle lock --file=~/.dotfiles/Brewfile --update
```

### View Lock File
```bash
cat ~/dotfiles/Brewfile.lock.json
```

### Reset to Lock File Versions
```bash
brew bundle --file=~/.dotfiles/Brewfile
```

## Version Control

### Committing Lock File
```bash
git add Brewfile.lock.json
git commit -m "chore: update brewfile lock"
```

### Handling Merge Conflicts
If conflicts occur in lock file:
```bash
# Accept incoming changes
git checkout --theirs Brewfile.lock.json

# Or regenerate
brew bundle lock --file=~/.dotfiles/Brewfile --update
```

## Troubleshooting

### Lock File Out of Sync
```bash
# Regenerate lock file
brew bundle lock --file=~/.dotfiles/Brewfile --update
```

### Missing Packages
```bash
# Verify installation
brew bundle check --file=~/.dotfiles/Brewfile
```

### Version Conflicts
```bash
# Update specific package
brew install <package-name>@<version>
```

## Best Practices

1. **Commit lock file changes** - Keep version history
2. **Update regularly** - Keep packages current
3. **Test before committing** - Verify all packages install
4. **Document major changes** - Note breaking updates in CHANGELOG

## Resources

- [Homebrew Bundle Documentation](https://github.com/Homebrew/homebrew-bundle)
- [Homebrew Versioning](https://docs.brew.sh/)
