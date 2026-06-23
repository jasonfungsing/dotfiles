# Homebrew Package Management

Quick reference for managing packages, applications, and extensions via Homebrew.

`brew bundle dump` will generated all the installed apps including cask
`brew bundle` will install everything from the Brewfile

## File Structure

- **`Brewfile`** - Complete package definitions (100+ packages)
- **`Brewfile.lock.json`** - Locked versions for reproducible installs
- **`Brewfile.readme`** - Homebrew documentation

## Quick Commands

### Install all packages
```bash
brew bundle --file=Brewfile
```

### Update packages
```bash
brew update
brew upgrade
brew bundle update --file=Brewfile
```

### Add a new package
```bash
brew install <package-name>
brew bundle dump --file=Brewfile --describe
brew bundle lock --file=Brewfile --update
```

### Remove a package
```bash
brew uninstall <package-name>
brew bundle dump --file=Brewfile --describe
```

### List installed packages
```bash
brew list
brew list --cask
```

## Package Categories

- **DevOps & Cloud** - Docker, Kubernetes, AWS tools
- **Languages** - Go, Python, Node.js, Ruby, Java
- **Build Tools** - Make, CMake, Gradle, Maven
- **CLI Utilities** - ripgrep, bat, fd, eza, autojump
- **System Tools** - tmux, htop, coreutils, zsh
- **Applications** - Neovim, VS Code, iTerm2
- **Fonts** - Cascadia, Fira Code, Nerd fonts

## Documentation

For detailed information about each package, see:
- **[BREWFILE_EXPLAINED.md](../docs/BREWFILE_EXPLAINED.md)** - Complete package guide with descriptions
- **[BREWFILE_LOCK.md](../docs/BREWFILE_LOCK.md)** - Lock file management

## Troubleshooting

### Package not found
```bash
brew search <package-name>
```

### Installation fails
```bash
brew doctor
brew install <package-name> --verbose
```

### Cask issues
```bash
brew list --cask
brew info <cask-name>
```

## See Also

- [Homebrew Documentation](https://docs.brew.sh/)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
