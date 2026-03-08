#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DRY_RUN=false
INSTALL_SHELL=true
INSTALL_EDITOR=true
INSTALL_GIT=true
INSTALL_TERMINAL=true
INSTALL_SYSTEM=true
INSTALL_BREW=true
INSTALL_APPS=true

log() {
    echo "→ $1"
}

error() {
    echo "✗ Error: $1" >&2
    exit 1
}

success() {
    echo "✓ $1"
}

command_exists() {
    type "$1" > /dev/null 2>&1
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --shell-only)
                INSTALL_EDITOR=false
                INSTALL_GIT=false
                INSTALL_TERMINAL=false
                INSTALL_SYSTEM=false
                INSTALL_BREW=false
                INSTALL_APPS=false
                shift
                ;;
            --editor-only)
                INSTALL_SHELL=false
                INSTALL_GIT=false
                INSTALL_TERMINAL=false
                INSTALL_SYSTEM=false
                INSTALL_BREW=false
                INSTALL_APPS=false
                shift
                ;;
            --git-only)
                INSTALL_SHELL=false
                INSTALL_EDITOR=false
                INSTALL_TERMINAL=false
                INSTALL_SYSTEM=false
                INSTALL_BREW=false
                INSTALL_APPS=false
                shift
                ;;
            --terminal-only)
                INSTALL_SHELL=false
                INSTALL_EDITOR=false
                INSTALL_GIT=false
                INSTALL_SYSTEM=false
                INSTALL_BREW=false
                INSTALL_APPS=false
                shift
                ;;
            --system-only)
                INSTALL_SHELL=false
                INSTALL_EDITOR=false
                INSTALL_GIT=false
                INSTALL_TERMINAL=false
                INSTALL_BREW=false
                INSTALL_APPS=false
                shift
                ;;
            --no-brew)
                INSTALL_BREW=false
                shift
                ;;
            --no-apps)
                INSTALL_APPS=false
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

show_help() {
    cat << 'EOF'
Usage: ./scripts/install.sh [OPTIONS]

OPTIONS:
  --shell-only      Install only shell configuration
  --editor-only     Install only editor configuration
  --git-only        Install only Git configuration
  --terminal-only   Install only terminal configuration
  --system-only     Install only macOS system preferences
  --no-brew         Skip Homebrew packages
  --no-apps         Skip applications
  --dry-run         Show what would be done without making changes
  -h, --help        Show this help message

EXAMPLES:
  ./scripts/install.sh                # Install everything
  ./scripts/install.sh --shell-only   # Install only shell config
  ./scripts/install.sh --no-brew      # Install everything except packages
  ./scripts/install.sh --dry-run      # Show what would be done
EOF
}

install_dotfiles() {
    log "Installing dotfiles..."
    
    local dotfile_source="$REPO_DIR/zshrc"
    local dotfile_target="$HOME/.zshrc"
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would symlink: $dotfile_source → $dotfile_target"
    else
        if [ -e "$dotfile_target" ] && [ ! -L "$dotfile_target" ]; then
            log "Skipping $dotfile_target (already exists)"
        else
            ln -sf "$dotfile_source" "$dotfile_target"
            success "Symlinked $dotfile_target"
        fi
    fi
    
    for file in vimrc alias_prompt.sh gitconfig tmux.conf; do
        local source="$REPO_DIR/$file"
        local target="$HOME/.$file"
        
        if [ ! -f "$source" ]; then
            continue
        fi
        
        if [ "$DRY_RUN" = true ]; then
            log "[DRY RUN] Would symlink: $source → $target"
        else
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                log "Skipping $target (already exists)"
            else
                ln -sf "$source" "$target"
                success "Symlinked $target"
            fi
        fi
    done
    
    local system_files=("com.googlecode.iterm2.plist" "hushlogin" "cobalt2.zsh-theme")
    for file in "${system_files[@]}"; do
        local source="$REPO_DIR/$file"
        local target="$HOME/.$file"
        
        if [ ! -f "$source" ]; then
            continue
        fi
        
        if [ "$DRY_RUN" = true ]; then
            log "[DRY RUN] Would symlink: $source → $target"
        else
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                log "Skipping $target (already exists)"
            else
                ln -sf "$source" "$target"
                success "Symlinked $target"
            fi
        fi
    done
}

install_homebrew() {
    log "Checking Homebrew..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would install Homebrew"
        return
    fi
    
    if ! command_exists brew; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        success "Homebrew installed"
    else
        success "Homebrew already installed"
    fi
    
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_oh_my_zsh() {
    log "Checking Oh-My-Zsh..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would install Oh-My-Zsh"
        return
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh-My-Zsh installed"
    else
        success "Oh-My-Zsh already installed"
    fi
}

configure_zsh() {
    log "Configuring Zsh as default shell..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would set Zsh as default shell"
        return
    fi
    
    local zsh_path
    zsh_path="$(command -v zsh)"
    
    if ! grep "$zsh_path" /etc/shells > /dev/null; then
        log "Adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi
    
    if [ "$SHELL" != "$zsh_path" ]; then
        chsh -s "$zsh_path"
        success "Default shell changed to $zsh_path"
    else
        success "Zsh already default shell"
    fi
}

install_vim_directories() {
    log "Creating Vim directories..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would create ~/.vim-tmp"
        return
    fi
    
    mkdir -p ~/.vim-tmp
    success "Vim directories created"
}

install_packages() {
    log "Installing Homebrew packages..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would run: brew bundle --file=$REPO_DIR/Brewfile"
        return
    fi
    
    if ! command_exists brew; then
        error "Homebrew not installed. Cannot install packages."
    fi
    
    if [ -f "$REPO_DIR/Brewfile" ]; then
        brew bundle --file="$REPO_DIR/Brewfile"
        success "Packages installed"
    else
        error "Brewfile not found at $REPO_DIR/Brewfile"
    fi
}

apply_macos_settings() {
    log "Applying macOS system settings..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would run: $SCRIPT_DIR/macos.sh"
        return
    fi
    
    if [ -f "$SCRIPT_DIR/macos.sh" ]; then
        bash "$SCRIPT_DIR/macos.sh"
        success "macOS settings applied"
    else
        error "macos.sh not found"
    fi
}

print_installation_plan() {
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "Dotfiles Installation Plan"
    echo "═══════════════════════════════════════════════════════════"
    
    [ "$INSTALL_SHELL" = true ] && echo "✓ Shell configuration (Zsh, aliases, Oh-My-Zsh)"
    [ "$INSTALL_EDITOR" = true ] && echo "✓ Editor configuration (Vim)"
    [ "$INSTALL_GIT" = true ] && echo "✓ Git configuration"
    [ "$INSTALL_TERMINAL" = true ] && echo "✓ Terminal configuration (tmux, iTerm2)"
    [ "$INSTALL_SYSTEM" = true ] && echo "✓ macOS system preferences"
    [ "$INSTALL_BREW" = true ] && echo "✓ Homebrew packages"
    [ "$INSTALL_APPS" = true ] && echo "✓ Applications (Casks, App Store)"
    
    [ "$DRY_RUN" = true ] && echo "" && echo "MODE: DRY RUN (no changes will be made)"
    
    echo "═══════════════════════════════════════════════════════════"
    echo ""
}

main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║         Dotfiles Installation Script                   ║"
    echo "║         macOS 26.3+ Development Environment            ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    
    parse_arguments "$@"
    print_installation_plan
    
    if [ "$INSTALL_SHELL" = true ]; then
        log "═ Shell Configuration ═"
        install_dotfiles
        install_homebrew
        install_oh_my_zsh
        configure_zsh
        install_vim_directories
    fi
    
    if [ "$INSTALL_GIT" = true ]; then
        log "═ Git Configuration ═"
        install_dotfiles
    fi
    
    if [ "$INSTALL_TERMINAL" = true ]; then
        log "═ Terminal Configuration ═"
        install_dotfiles
    fi
    
    if [ "$INSTALL_EDITOR" = true ]; then
        log "═ Editor Configuration ═"
        install_dotfiles
    fi
    
    if [ "$INSTALL_SYSTEM" = true ]; then
        log "═ System Preferences ═"
        apply_macos_settings
    fi
    
    if [ "$INSTALL_BREW" = true ] || [ "$INSTALL_APPS" = true ]; then
        log "═ Packages & Applications ═"
        install_homebrew
        install_packages
    fi
    
    echo ""
    if [ "$DRY_RUN" = false ]; then
        success "Installation complete!"
        echo ""
        echo "Next steps:"
        echo "1. Reload your terminal: exec zsh"
        echo "2. Run validation: $SCRIPT_DIR/validate-setup.sh"
        echo "3. Review documentation: https://github.com/jasonfungsing/dotfiles"
    else
        log "Dry run complete. No changes were made."
        echo ""
        echo "To proceed with installation, run:"
        echo "  ./scripts/install.sh"
    fi
    echo ""
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
