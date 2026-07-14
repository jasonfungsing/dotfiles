# Homebrew Package Management

Quick reference for managing packages, applications, and extensions via Homebrew.

The `Brewfile` is a curated collection of packages optimised for cloud/DevOps work (Docker, Kubernetes), backend development (Go, Python, Node.js, Java, Ruby), and general terminal productivity. `brew bundle` installs everything from the Brewfile; `brew bundle dump` regenerates it from what is currently installed (including casks).

The Brewfile is the **source of truth**: `../install.sh` both installs what it declares and uninstalls anything undeclared (`--no-prune` to skip the latter). To keep a package, declare it here — installing it by hand only lasts until the next install.sh run.

## File Structure

- **`Brewfile`** - Complete package definitions (100+ packages)

## Brewfile Structure

The Brewfile is organised into four sections:

1. **Formulas** - Command-line tools and libraries
2. **Casks** - GUI applications
3. **`mas`** - macOS App Store applications
4. **VS Code Extensions** - Visual Studio Code extensions

`cask_args adopt: true` applies to every cask: an app that already exists on
disk (installed manually) is adopted under brew management instead of
failing the install — brew takes ownership of the existing copy when the
version matches, rather than downloading a duplicate.

> Note: no taps are needed — `gh`, `homebrew/bundle`, and `homebrew/services` have all been merged into Homebrew core.

## Quick Commands

Run these from this directory (or point `--file` at `brew/Brewfile` from the repo root — [install.sh](../install.sh) does this for you).

### Install all packages
```bash
brew bundle --file=Brewfile
```

> `brew bundle` has no per-type install filters — it always installs every entry type. To skip individual entries by name, list them (space-separated) in the `HOMEBREW_BUNDLE_BREW_SKIP`, `HOMEBREW_BUNDLE_CASK_SKIP` or `HOMEBREW_BUNDLE_MAS_SKIP` environment variables.

### Update packages
```bash
brew update
brew upgrade
```

### Add a new package
```bash
brew install <package-name>
brew bundle dump --file=Brewfile --force --no-describe
```

### Remove a package
```bash
brew uninstall <package-name>
brew bundle dump --file=Brewfile --force --no-describe
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
| Text processing & search | `ripgrep`, `bat`, `fd`, `fzf`, `jq`, `diff-so-fancy`, `wdiff`, `highlight`, `grep` (GNU) |
| Navigation & files | `autojump`, `z`, `eza` (modern `ls` with colours), `nnn`, `tree`, `rename` |
| Languages & runtimes | `go`, `golangci-lint`, `node`, `python3`, `ruby`, `gawk` |
| Version & package managers | `fnm`, `nvm`, `rbenv`/`ruby-build`, `jabba`, `pnpm`, `yarn`, `pipenv`, `uv`, `cocoapods` |
| Build tools | `make`, `cmake`, `gcc`, `gradle`, `maven`, `openjdk`, `protobuf`, `buf`, `pkgconf` |
| DevOps & cloud | `docker`, `docker-compose`, `docker-credential-helper`, `kubernetes-cli` (kubectl), `kind`, `minikube`, `kops`, `kubectx`, `kustomize`, `helm`, `skaffold`, `stern`, `k6`, `lazydocker` |
| Git & GitHub | `git`, `git-lfs`, `gh`, `lazygit`, `tig`, `gnupg` |
| System & terminal | `tmux`, `tmuxinator`, `reattach-to-user-namespace`, `htop`, `btop`, `coreutils`, `zsh`, `zsh-completions`, `zsh-syntax-highlighting`, `bash-completion@2`, `direnv`, `entr`, `watchman`, `shellcheck` |
| Editors | `neovim` (configuration lives in [neovim/](../neovim/README.md)) |
| Networking | `curl`, `wget`, `nmap`, `mosh`, `tailscale` |
| Documentation & media | `pandoc`, `markdown`, `tesseract` (OCR), `graphviz`, `cloc`, `figlet`, `cmatrix` |
| Productivity helpers | `cheat`, `navi`, `thefuck`, `noti`, `wtf`, `mas`, `mutt`, `weechat` |
| Libraries & databases | `rocksdb` |

### Casks (GUI applications)

`visual-studio-code`, `iterm2`, `google-chrome`, `docker-desktop`, `slack`, `claude` (Claude desktop), `claude-code` (CLI), `google-gemini`, `antigravity-cli`/`antigravity-ide`, `raycast` (launcher), `little-snitch` (network firewall), `okta-verify`, `logi-options+` (Logitech devices), `setapp`, `basictex` (LaTeX), and coding fonts (`font-fira-code`, `font-cascadia-mono`, plus the Powerline-glyph Nerd Font `font-3270-nerd-font`).

> Corporate security agents (CrowdStrike Falcon, Workspace ONE Hub) are deliberately not managed by brew — they belong to device management.

### Mac App Store

Installed via `mas`: AdBlock, Dark Reader for Safari, Xcode.

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
- [Homebrew Bundle & Brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- `man brew`
