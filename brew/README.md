# Homebrew Package Management

Quick reference for managing packages, applications, and extensions via Homebrew.

The `Brewfile` is a curated collection of packages optimised for cloud/DevOps work (Docker, Kubernetes), backend development (Go, Python, Node.js, Java, Ruby), and general terminal productivity. `brew bundle` installs everything from the Brewfile; `brew bundle dump` regenerates it from what is currently installed (including casks).

## File Structure

- **`Brewfile`** - Complete package definitions (100+ packages)

## Brewfile Structure

The Brewfile is organised into four sections:

1. **Formulas** - Command-line tools and libraries
2. **Casks** - GUI applications
3. **`mas`** - macOS App Store applications
4. **VS Code Extensions** - Visual Studio Code extensions

> Note: no taps are needed — `gh`, `homebrew/bundle`, and `homebrew/services` have all been merged into Homebrew core.

## Quick Commands

Run these from this directory (or point `--file` at `brew/Brewfile` from the repo root — [install.sh](../install.sh) does this for you).

### Install all packages
```bash
brew bundle --file=Brewfile
```

Install a specific type only:
```bash
brew bundle --file=Brewfile --formula   # CLI tools only
brew bundle --file=Brewfile --cask      # GUI applications only
brew bundle --file=Brewfile --mas       # App Store apps only
```

### Update packages
```bash
brew update
brew upgrade
```

### Add a new package
```bash
brew install <package-name>
brew bundle dump --file=Brewfile --describe --force
```

### Remove a package
```bash
brew uninstall <package-name>
brew bundle dump --file=Brewfile --describe --force
```

### List installed packages
```bash
brew list
brew list --cask
```

## Package Categories

### Formulas (command-line tools)

| Category | Key packages |
|----------|--------------|
| Text processing & search | `ripgrep`, `bat`, `fd`, `jq`, `diff-so-fancy`, `wdiff`, `highlight` |
| Navigation & files | `autojump`, `z`, `eza` (modern `ls` with colours), `nnn`, `tree`, `rename` |
| Languages & runtimes | `go`, `node`, `python3`, `ruby`, `gawk` |
| Version & package managers | `fnm`, `nvm`, `rbenv`/`ruby-build`, `jabba`, `pnpm`, `yarn`, `pipenv`, `uv`, `cocoapods` |
| Build tools | `make`, `cmake`, `gcc`, `gradle`, `maven`, `openjdk`, `protobuf`, `buf`, `pkgconf` |
| DevOps & cloud | `docker`, `docker-compose`, `kubernetes-cli` (kubectl), `kind`, `minikube`, `kops`, `kubectx`, `kustomize`, `helm`, `skaffold`, `stern`, `k6`, `lazydocker` |
| Git & GitHub | `git`, `git-lfs`, `gh`, `lazygit`, `tig`, `gnupg` |
| System & terminal | `tmux`, `reattach-to-user-namespace`, `htop`, `btop`, `coreutils`, `zsh`, `zsh-completions`, `zsh-syntax-highlighting`, `direnv`, `entr`, `watchman`, `shellcheck` |
| Networking | `curl`, `wget`, `nmap`, `mosh` |
| Documentation & media | `pandoc`, `markdown`, `tesseract` (OCR), `graphviz`, `cloc`, `figlet`, `cmatrix` |
| Productivity helpers | `cheat`, `navi`, `noti`, `wtf`, `mas`, `mutt`, `weechat` |

### Casks (GUI applications)

`visual-studio-code`, `slack`, `raycast` (launcher), `little-snitch` (network firewall).

### Mac App Store

Installed via `mas`: AdBlock, Xcode.

### VS Code extensions

AI assistance (Claude Code), language support (Go, Python), containers (Docker), GitHub integration (pull requests, Actions, Codespaces, theme), and Mermaid diagrams. Neovim configuration lives separately in [neovim/](../neovim/README.md).

## Troubleshooting

### Package not found
```bash
brew search <package-name>

# Check available versions
brew search <package-name>@
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

### Missing or out-of-sync packages
```bash
# Verify everything in the Brewfile is installed
brew bundle check --file=Brewfile --verbose
```

## See Also

- [Homebrew Documentation](https://docs.brew.sh/)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- `man brew`
