# Changelog

All notable changes to this dotfiles project are documented here.

## [Unreleased]

### Added
- Comprehensive README with quick start and detailed installation instructions
- Interactive installer (`install-interactive.sh`) for selective component installation
- Command-line flags for modular installation (`--shell-only`, `--editor-only`, etc.)
- Setup validation script (`validate-setup.sh`) to verify successful installation
- Extensive documentation in `docs/` directory
- Comments in shell configuration for better understanding of aliases and settings
- Directory reorganisation for better structure and maintainability
- Support for both interactive and flag-based installation modes

### Improved
- Enhanced `install.sh` with error handling, validation, and better user feedback
- Refactored `macos.sh` with improved documentation and clarity
- Better organisation of dotfiles into semantic directories (`shell/`, `editor/`, `git/`, etc.)

### Documentation
- [INSTALLATION.md](docs/INSTALLATION.md) - Detailed installation guide
- [MACOS_SETTINGS.md](docs/MACOS_SETTINGS.md) - Explanations of all macOS preferences
- [BREWFILE_EXPLAINED.md](docs/BREWFILE_EXPLAINED.md) - Complete package catalogue with rationale
- [BREWFILE_LOCK.md](docs/BREWFILE_LOCK.md) - Brewfile lock file management
- [SUBLIME_SETUP.md](docs/SUBLIME_SETUP.md) - Sublime Text configuration guide
- [RAYCAST_SCRIPTS.md](docs/RAYCAST_SCRIPTS.md) - Raycast scripts documentation
- [SHELL_ALIASES.md](docs/SHELL_ALIASES.md) - Complete alias reference

## [2.0.0] - 2026-03-08

### Initial Release
- Personal dotfiles configuration
- Basic installation script
- Comprehensive Brewfile with 100+ packages
- Zsh, Vim, tmux, Git configurations
- macOS system preferences automation
- Sublime Text integration
- Raycast scripts
