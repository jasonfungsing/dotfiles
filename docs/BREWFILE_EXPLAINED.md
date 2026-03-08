# Brewfile Documentation

Complete guide to all packages, applications, and extensions installed via Homebrew.

## Overview

The `Brewfile` contains a curated collection of 100+ packages optimised for development in:
- Cloud & DevOps (Docker, Kubernetes, AWS)
- Backend Development (Go, Python, Node.js, Java, Ruby)
- Infrastructure as Code (Helm, Terraform)
- Development Tools (Git, tmux, Vim, VS Code)

## Brewfile Structure

The Brewfile is organised into four sections:

1. **Taps** - Additional package repositories
2. **Formulas** - Command-line tools and libraries
3. **Casks** - GUI applications
4. **App Store** - macOS App Store applications
5. **VS Code Extensions** - Visual Studio Code extensions

## Taps (Package Repositories)

Additional Homebrew repositories providing extra packages:

```bash
tap "antoniorodr/memo"           # Memo note-taking tool
tap "aws/tap"                    # AWS CLI and tools
tap "github/gh"                  # GitHub CLI enhancements
tap "graalvm/tap"                # GraalVM Java distribution
tap "homebrew/bundle"            # Homebrew bundle management
tap "homebrew/services"          # Service management for Homebrew
tap "jesseduffield/lazygit"       # Lazygit version control UI
tap "microsoft/git"              # Microsoft Git enhancements
tap "schniz/tap"                 # Developer tools
tap "steipete/tap"               # Personal tool collection
tap "teamookla/speedtest"        # Speedtest CLI
tap "versent/taps"               # Versent utilities
```

## Formulas (Command-Line Tools)

### Text Processing & Search
| Tool | Purpose |
|------|---------|
| `ack` | Better grep for source code searching |
| `bat` | Cat clone with syntax highlighting |
| `fd` | Fast alternative to find |
| `grep` | Text pattern matching utility |
| `ripgrep` | Ultra-fast grep replacement |
| `the_silver_searcher` | Fast code search tool |
| `diff-so-fancy` | Better git diff output |
| `wdiff` | Word-level diff display |
| `jq` | JSON query and manipulation |
| `highlight` | Syntax highlighter for code |

### Navigation & File Management
| Tool | Purpose |
|------|---------|
| `autojump` | Fast directory navigation |
| `exa` | Modern ls replacement with colors |
| `nnn` | Terminal file browser |
| `tree` | Directory tree display |
| `rename` | Batch file renaming |
| `z` | Jump to frequently used directories |

### Development Languages & Runtimes
| Tool | Purpose |
|------|---------|
| `go` | Go programming language |
| `node` | Node.js JavaScript runtime |
| `node@22` | Specific Node.js version |
| `python@3.13` | Python 3.13 runtime |
| `ruby` | Ruby programming language |
| `perl` | Perl programming language |
| `gawk` | GNU awk for text processing |
| `fnm` | Fast Node.js version manager |
| `rbenv` | Ruby environment manager |
| `ruby-build` | Ruby installation tool |
| `nvm` | Node version manager |

### Build & Compilation Tools
| Tool | Purpose |
|------|---------|
| `make` | Build automation utility |
| `cmake` | Cross-platform build system |
| `gcc` | GNU C/C++ compiler |
| `gradle` | Java/Kotlin build system |
| `maven` | Java build and project tool |
| `openjdk` | Open source Java Development Kit |
| `oracle-jdk@25` | Oracle Java Development Kit |
| `protobuf` | Protocol buffers compiler |
| `buf` | Protocol buffer tooling |

### DevOps & Cloud Tools
| Tool | Purpose |
|------|---------|
| `awscli` | Amazon Web Services CLI |
| `docker` | Container platform |
| `docker-compose` | Multi-container Docker orchestration |
| `docker-credential-helper` | Docker authentication helper |
| `kubectl` | Kubernetes command-line tool |
| `kind` | Kubernetes in Docker |
| `minikube` | Local Kubernetes cluster |
| `kops` | Kubernetes operations tool |
| `kubectx` | Kubernetes context switcher |
| `helm` | Kubernetes package manager |
| `kustomize` | Kubernetes customization tool |
| `skaffold` | Kubernetes development workflow |
| `stern` | Kubernetes log viewer |
| `gitlab-runner` | GitLab CI runner |
| `k6` | Load testing tool |
| `temporal` | Workflow engine |

### Infrastructure & Networking
| Tool | Purpose |
|------|---------|
| `curl` | Data transfer utility |
| `wget` | Download utility |
| `nmap` | Network mapper and security scanner |
| `mosh` | Mobile shell for remote connections |
| `graphviz` | Graph visualization software |
| `pkgconf` | Package configuration tool |

### System & Utilities
| Tool | Purpose |
|------|---------|
| `htop` | Interactive process viewer |
| `tmux` | Terminal multiplexer |
| `reattach-to-user-namespace` | tmux macOS namespace fix |
| `coreutils` | GNU core utilities |
| `zsh` | Z shell |
| `zsh-completions` | Zsh completion scripts |
| `zsh-syntax-highlighting` | Zsh syntax highlighting |
| `shellcheck` | Shell script static analysis |
| `entr` | Run program on file changes |
| `watchman` | File change monitor |
| `direnv` | Environment management tool |

### Development & Productivity
| Tool | Purpose |
|------|---------|
| `vim` | Text editor |
| `neovim` | Modern vim fork |
| `git` | Version control system |
| `git-lfs` | Git Large File Storage |
| `hub` | GitHub command-line helper |
| `gh` | Official GitHub CLI |
| `lazygit` | Git terminal UI |
| `tig` | Git ncurses UI |
| `cheat` | Command-line cheat sheets |
| `navi` | Interactive cheatsheet tool |
| `thefuck` | Automatic command correction |
| `tldr` | Simplified man pages |

### Documentation & Media
| Tool | Purpose |
|------|---------|
| `pandoc` | Document converter |
| `markdown` | Markdown to HTML converter |
| `tesseract` | OCR (Optical Character Recognition) |
| `basictex` | Minimal LaTeX distribution |
| `cloc` | Count lines of code |
| `figlet` | ASCII art text generator |
| `cmatrix` | Matrix movie effect in terminal |

### Language-Specific Tools
| Tool | Purpose |
|------|---------|
| `golangci-lint` | Go code linter |
| `pipenv` | Python dependency management |
| `uv` | Fast Python package installer |
| `cocoapods` | iOS dependency manager |
| `jabba` | Java version manager |

### Monitoring & Performance
| Tool | Purpose |
|------|---------|
| `rocksdb` | Embedded key-value database |
| `icu4c@76` | Unicode support library |
| `lazydocker` | Docker terminal UI |
| `noti` | Notification utility |
| `speedtest` | Internet speed test |
| `wtf` | Personal dashboard utility |

## Casks (GUI Applications)

### Development IDEs & Editors
| Application | Purpose |
|-------------|---------|
| `visual-studio-code` | Code editor with extensions |
| `sublime-text` | Lightweight text editor |
| `sublime-merge` | Git GUI client |
| `neovim` | Modern terminal editor |

### Terminals & System
| Application | Purpose |
|-------------|---------|
| `iterm2` | Advanced terminal emulator |

### Utilities
| Application | Purpose |
|-------------|---------|
| `raycast` | Command launcher and productivity |
| `docker` | Docker Desktop UI |

### Fonts
| Font | Use Case |
|------|----------|
| `font-3270-nerd-font` | Monospace terminal font |
| `font-cascadia-mono` | Microsoft coding font |
| `font-fira-code` | Programming font with ligatures |
| `font-jetbrains-mono` | JetBrains IDE font |

### Productivity & Communication
| Application | Purpose |
|-------------|---------|
| `slack` | Team communication |
| `microsoft-teams` | Microsoft collaboration |
| `microsoft-excel` | Spreadsheet application |
| `microsoft-word` | Word processor |

### Media & Design
| Application | Purpose |
|-------------|---------|
| `basictex` | LaTeX distribution |
| `grammarly` | Writing assistant |
| `grammarly-desktop` | Desktop version of Grammarly |
| `final-cut-pro` | Video editing software |
| `pdf-expert` | PDF reader and editor |
| `openclaw` | Developer tool suite |

### Development Tools
| Application | Purpose |
|-------------|---------|
| `oracle-jdk@25` | Oracle Java Development Kit |
| `microsoft-auto-update` | Microsoft software updates |

### Security
| Application | Purpose |
|-------------|---------|
| `little-snitch` | Network monitor and firewall |

## Mac App Store Applications

| App | Purpose |
|-----|---------|
| `AdBlock` | Ad blocker for Safari |
| `Amphetamine` | Window management automation |
| `CARROTweather` | Weather application |
| `Dark Reader for Safari` | Dark mode for websites |
| `Final Cut Pro` | Professional video editing |
| `PDF Expert` | PDF manipulation |
| `WeChat` | Chinese messaging platform |
| `WhatsApp` | Messaging application |
| `Xcode` | Apple development environment |

## VS Code Extensions

### AI & Coding Assistance
| Extension | Purpose |
|-----------|---------|
| `anthropic.claude-code` | Claude AI integration |
| `saoudrizwan.claude-dev` | Claude Dev assistant |
| `rooveterinaryinc.roo-cline` | Cline AI coding assistant |
| `github.copilot-chat` | GitHub Copilot chat |

### Code Quality & Linting
| Extension | Purpose |
|-----------|---------|
| `dbaeumer.vscode-eslint` | ESLint integration |
| `esbenp.prettier-vscode` | Code formatter |

### Version Control
| Extension | Purpose |
|-----------|---------|
| `github.vscode-pull-request-github` | GitHub PR management |
| `github.vscode-github-actions` | GitHub Actions UI |

### Languages & Development
| Extension | Purpose |
|-----------|---------|
| `golang.go` | Go language support |
| `ms-python.python` | Python language support |
| `ms-python.debugpy` | Python debugger |
| `ms-python.vscode-pylance` | Python language server |
| `ms-python.vscode-python-envs` | Python environment manager |
| `ms-vscode.cpptools` | C/C++ support |
| `redhat.java` | Java language support |
| `vscjava.vscode-java-debug` | Java debugger |
| `vscjava.vscode-java-test` | Java test runner |
| `vscjava.vscode-lombok` | Java Lombok support |
| `vscjava.vscode-maven` | Maven support |
| `vscjava.vscode-java-upgrade` | Java upgrade tools |
| `vscjava.vscode-spring-boot-dashboard` | Spring Boot dashboard |
| `vmware.vscode-spring-boot` | Spring Boot tools |
| `oracle.oracle-java` | Oracle Java tools |

### Infrastructure & DevOps
| Extension | Purpose |
|-----------|---------|
| `ms-azuretools.vscode-docker` | Docker support |
| `ms-azuretools.vscode-containers` | Container management |
| `ms-kubernetes-tools.vscode-kubernetes-tools` | Kubernetes support |
| `redhat.vscode-yaml` | YAML language support |
| `ms-vscode.azure-repos` | Azure Repos integration |

### Remote Development
| Extension | Purpose |
|-----------|---------|
| `ms-vscode-remote.remote-ssh` | SSH remote development |
| `ms-vscode-remote.remote-ssh-edit` | SSH config editing |
| `ms-vscode-remote.remote-explorer` | Remote explorer UI |
| `ms-vscode.remote-explorer` | Remote resource browser |
| `ms-vscode.remote-repositories` | Repository browsing |
| `github.remotehub` | GitHub remote browsing |
| `github.codespaces` | GitHub Codespaces support |

### Git & GitHub
| Extension | Purpose |
|-----------|---------|
| `github.vscode-pull-request-github` | GitHub PR management |
| `github.vscode-github-actions` | GitHub Actions UI |
| `github.github-vscode-theme` | GitHub visual theme |

### Testing & Debugging
| Extension | Purpose |
|-----------|---------|
| `orta.vscode-jest` | Jest test runner |

### Documentation & Utilities
| Extension | Purpose |
|-----------|---------|
| `yzhang.markdown-all-in-one` | Markdown support |
| `tomoki1207.pdf` | PDF viewer |
| `mermaidchart.vscode-mermaid-chart` | Mermaid diagram support |

## Package Categories Summary

| Category | Count | Purpose |
|----------|-------|---------|
| DevOps & Cloud | 15+ | Container, orchestration, cloud |
| Development | 20+ | Languages, runtimes, frameworks |
| Build Tools | 10+ | Compilation, project building |
| CLI Utilities | 25+ | Text processing, navigation |
| System Tools | 15+ | System utilities, networking |
| Applications | 25+ | GUI tools and productivity apps |
| VS Code | 40+ | Editor extensions for development |

## Installation

Install all packages at once:
```bash
brew bundle --file=~/.dotfiles/Brewfile
```

Install specific category:
```bash
# Only formulas
brew bundle --file=~/.dotfiles/Brewfile --formula

# Only casks
brew bundle --file=~/.dotfiles/Brewfile --cask

# Only mas (App Store)
brew bundle --file=~/.dotfiles/Brewfile --mas
```

## Updating

Update all packages:
```bash
brew bundle update --file=~/.dotfiles/Brewfile
brew bundle lock --file=~/.dotfiles/Brewfile --update
```

Update lock file only:
```bash
brew bundle lock --file=~/.dotfiles/Brewfile --update
```

## Adding New Packages

1. Install the package:
   ```bash
   brew install <package-name>
   ```

2. Add to Brewfile:
   ```bash
   brew bundle dump --file=~/.dotfiles/Brewfile --describe
   ```

3. Update lock file:
   ```bash
   brew bundle lock --file=~/.dotfiles/Brewfile --update
   ```

## Removing Packages

1. Remove from system:
   ```bash
   brew uninstall <package-name>
   ```

2. Remove from Brewfile manually or regenerate:
   ```bash
   brew bundle dump --file=~/.dotfiles/Brewfile --describe
   ```

3. Update lock file:
   ```bash
   brew bundle lock --file=~/.dotfiles/Brewfile --update
   ```

## Troubleshooting

### Package not found
```bash
# Search for package
brew search <search-term>

# Check available versions
brew search <package-name>@
```

### Installation fails
```bash
# Run doctor to check system
brew doctor

# Try installing with verbose output
brew install <package-name> --verbose
```

### Cask-specific issues
```bash
# List installed casks
brew list --cask

# Check cask status
brew info <cask-name>
```

## Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- `brew` manual: `man brew`
