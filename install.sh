#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
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
Usage: ./install.sh [OPTIONS]

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
  ./install.sh                # Install everything
  ./install.sh --shell-only   # Install only shell config
  ./install.sh --no-brew      # Install everything except packages
  ./install.sh --dry-run      # Show what would be done
EOF
}

install_dotfiles() {
    log "Installing dotfiles..."
    
    local dotfile_source="$REPO_DIR/shell/zshrc"
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
    
    # Shell files
    for file in alias_prompt.sh; do
        local source="$REPO_DIR/shell/$file"
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
    
    # Terminal files
    local terminal_file="$REPO_DIR/terminal/tmux.conf"
    local terminal_target="$HOME/.tmux.conf"
    
    if [ -f "$terminal_file" ]; then
        if [ "$DRY_RUN" = true ]; then
            log "[DRY RUN] Would symlink: $terminal_file → $terminal_target"
        else
            if [ -e "$terminal_target" ] && [ ! -L "$terminal_target" ]; then
                log "Skipping $terminal_target (already exists)"
            else
                ln -sf "$terminal_file" "$terminal_target"
                success "Symlinked $terminal_target"
            fi
        fi
    fi
    
    # Git files
    local git_file="$REPO_DIR/git/gitconfig"
    local git_target="$HOME/.gitconfig"
    
    if [ -f "$git_file" ]; then
        if [ "$DRY_RUN" = true ]; then
            log "[DRY RUN] Would symlink: $git_file → $git_target"
        else
            if [ -e "$git_target" ] && [ ! -L "$git_target" ]; then
                log "Skipping $git_target (already exists)"
            else
                ln -sf "$git_file" "$git_target"
                success "Symlinked $git_target"
            fi
        fi
    fi
    
    # System files
    # Note: iTerm2 config (app/iterm2/) is not symlinked — iTerm2 only loads
    # preferences via Settings → General → Preferences → "Load preferences from
    # a custom folder", which must be set manually in the UI.
    local system_files=("system/hushlogin")
    for file in "${system_files[@]}"; do
        local source="$REPO_DIR/$file"
        local target_name=$(basename "$file")
        local target="$HOME/.$target_name"
        
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


install_neovim_config() {
     log "Setting up Neovim configuration..."
     
     if [ "$DRY_RUN" = true ]; then
         log "[DRY RUN] Would create ~/.config/nvim and symlink all editor files"
         return
     fi
     
     mkdir -p ~/.config/nvim
     
     local editor_dir="$REPO_DIR/editor"
     
     # Programmatically symlink all files and directories from editor/
     # Skip the README.md file and symlink everything else
     find "$editor_dir" -maxdepth 1 \( -type f -o -type d \) ! -name "README.md" ! -name ".git*" | while read -r item; do
         local item_name=$(basename "$item")
         local target="$HOME/.config/nvim/$item_name"
         
         # Skip the editor directory itself
         [ "$item" = "$editor_dir" ] && continue
         
         if [ "$DRY_RUN" = true ]; then
             log "[DRY RUN] Would symlink: $item → $target"
         else
             # Check if target already exists
             if [ -e "$target" ] || [ -L "$target" ]; then
                 # If it's a symlink, check if it points to the correct location
                 if [ -L "$target" ]; then
                     local current_link=$(readlink "$target")
                     if [ "$current_link" = "$item" ]; then
                         log "Symlink $target already correct"
                         continue
                     else
                         log "Updating incorrect symlink: $target"
                         rm "$target"
                     fi
                 # If it's a regular file/directory, skip it
                 elif [ ! -L "$target" ]; then
                     log "Skipping $target (regular file/directory exists)"
                     continue
                 fi
             fi
             
             # Create the symlink
             if ln -sf "$item" "$target" 2>/dev/null; then
                 success "Symlinked $(basename "$item")"
             else
                 log "Failed to create symlink: $item → $target"
             fi
         fi
     done
 }


install_zsh_theme() {
    log "Installing Zsh theme (cobalt2)..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would symlink cobalt2.zsh-theme to ~/.oh-my-zsh/custom/themes/"
        return
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes" ]; then
        log "Oh-My-Zsh custom themes directory not found. Skipping theme installation."
        return
    fi
    
    local theme_source="$REPO_DIR/shell/cobalt2.zsh-theme"
    local theme_target="$HOME/.oh-my-zsh/custom/themes/cobalt2.zsh-theme"
    
    if [ -f "$theme_source" ]; then
        if [ -e "$theme_target" ] && [ ! -L "$theme_target" ]; then
            log "Skipping $theme_target (already exists)"
        else
            ln -sf "$theme_source" "$theme_target"
            success "Symlinked cobalt2.zsh-theme"
        fi
    fi
}


install_tmux_plugins() {
    log "Setting up Tmux Plugin Manager and plugins..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would install TPM and plugins"
        return
    fi
    
    if ! command_exists tmux; then
        log "Tmux not found. Skipping TPM installation."
        return
    fi
    
    local tpm_path="$HOME/.tmux/plugins/tpm"
    
    if [ ! -d "$tpm_path" ]; then
        log "Cloning Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_path"
        success "TPM cloned successfully"
    else
        success "TPM already installed"
    fi
    
    log "Installing Tmux plugins..."
    "$tpm_path/bin/install_plugins" > /dev/null 2>&1
    success "Tmux plugins installed"
}

restore_keyboard_shortcuts() {
    log "Restoring keyboard shortcuts..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would restore keyboard shortcuts from $REPO_DIR/system/keyboard-shortcuts.json"
        return
    fi
    
    local shortcuts_file="$REPO_DIR/system/keyboard-shortcuts.json"
    
    if [ ! -f "$shortcuts_file" ]; then
        log "Keyboard shortcuts file not found. Skipping restoration."
        return
    fi
    
    if ! command_exists jq; then
        log "jq not found. Skipping keyboard shortcuts restoration."
        return
    fi
    
    log "Restoring keyboard shortcuts from $shortcuts_file..."
    
    # Refresh preference daemon cache before editing plists to prevent dirty cache flush overwrites
    log "Clearing cached system preferences..."
    killall cfprefsd 2>/dev/null || true
    sleep 1
    
    # Restore symbolic hotkeys (system-level keyboard shortcuts)
    restore_symbolic_hotkeys "$shortcuts_file"
    
    # Restore app-specific shortcuts
    restore_app_shortcuts "$shortcuts_file"
    
    # CRITICAL: Force kill preference daemon with SIGKILL to discard stale caches in memory and sync from disk
    log "Refreshing cached system preferences..."
    killall -9 cfprefsd 2>/dev/null || true
    sleep 1
    
    success "Keyboard shortcuts restored"
}

get_plist_path() {
    local domain="$1"
    if [ "$domain" = "NSGlobalDomain" ] || [ "$domain" = "Apple Global Domain" ] || [ "$domain" = ".GlobalPreferences" ]; then
        echo "$HOME/Library/Preferences/.GlobalPreferences.plist"
        return
    fi
    
    local paths=(
        "$HOME/Library/Preferences/${domain}.plist"
        "$HOME/Library/Containers/${domain}/Data/Library/Preferences/${domain}.plist"
    )
    for p in "${paths[@]}"; do
        if [ -f "$p" ]; then
            echo "$p"
            return
        fi
    done
}

restore_symbolic_hotkeys() {
    local shortcuts_file="$1"
    local plist_file="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
    
    # Ensure plist file exists
    if [ ! -f "$plist_file" ]; then
        log "Creating symbolic hotkeys plist..."
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict
    fi
    
    # Ensure AppleSymbolicHotKeys parent dictionary key exists in the target plist
    if ! plutil -extract AppleSymbolicHotKeys xml1 "$plist_file" -o - &>/dev/null; then
        plutil -replace AppleSymbolicHotKeys -json '{}' "$plist_file" 2>/dev/null || true
    fi
    
    # Extract and apply each symbolic hotkey using insert-or-replace
    jq -r '.keyboard_shortcuts["com.apple.symbolichotkeys"].AppleSymbolicHotKeys // empty | 
        to_entries[] | "\(.key)|\(.value | @json)"' "$shortcuts_file" | while IFS='|' read -r key value; do
        if [ -n "$key" ] && [ -n "$value" ]; then
            plutil -insert "AppleSymbolicHotKeys.$key" -json "$value" "$plist_file" 2>/dev/null || \
            plutil -replace "AppleSymbolicHotKeys.$key" -json "$value" "$plist_file" 2>/dev/null || true
        fi
    done
}

restore_app_shortcuts() {
    local shortcuts_file="$1"
    
    # Get all domains in keyboard_shortcuts
    jq -r '.keyboard_shortcuts | keys[]' "$shortcuts_file" | while read -r domain; do
        if [ "$domain" = "com.apple.symbolichotkeys" ]; then
            continue
        fi
        
        # Skip empty domains
        if [ -z "$domain" ]; then
            continue
        fi
        
        local plist_path
        plist_path=$(get_plist_path "$domain")
        
        # If the plist file does not exist, initialize it using defaults write
        if [ -z "$plist_path" ] || [ ! -f "$plist_path" ]; then
            log "Initializing preferences file for domain: $domain"
            defaults write "$domain" -dict 2>/dev/null || true
            plist_path=$(get_plist_path "$domain")
        fi
        
        if [ -z "$plist_path" ] || [ ! -f "$plist_path" ]; then
            log "  ⚠ Could not create or find plist path for domain: $domain. Skipping."
            continue
        fi
        
        log "Restoring application shortcuts for: $domain"
        
        # Ensure NSUserKeyEquivalents parent dictionary key exists in the target plist
        if ! plutil -extract NSUserKeyEquivalents xml1 "$plist_path" -o - &>/dev/null; then
            plutil -replace NSUserKeyEquivalents -json '{}' "$plist_path" 2>/dev/null || true
        fi
        
        # Extract and apply each shortcut using insert-or-replace
        jq -r ".keyboard_shortcuts[\"$domain\"].NSUserKeyEquivalents // empty | to_entries[] | \"\(.key)|\(.value | @json)\"" "$shortcuts_file" | while IFS='|' read -r key value; do
            if [ -n "$key" ] && [ -n "$value" ]; then
                plutil -insert "NSUserKeyEquivalents.$key" -json "$value" "$plist_path" 2>/dev/null || \
                plutil -replace "NSUserKeyEquivalents.$key" -json "$value" "$plist_path" 2>/dev/null || true
            fi
        done
    done
}

install_packages() {
    log "Installing Homebrew packages..."

    if [ ! -f "$REPO_DIR/brew/Brewfile" ]; then
        error "Brewfile not found at $REPO_DIR/brew/Brewfile"
    fi

    local bundle_args=(install --file="$REPO_DIR/brew/Brewfile" --verbose)
    if [ "$INSTALL_APPS" = false ]; then
        bundle_args+=(--no-cask --no-mas --no-vscode)
    fi

    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would run: brew bundle ${bundle_args[*]}"
        return
    fi

    if ! command_exists brew; then
        error "Homebrew not installed. Cannot install packages."
    fi

    log "Running: brew bundle ${bundle_args[*]}"
    set +e
    brew bundle "${bundle_args[@]}"
    local bundle_exit=$?
    set -e

    local check_output
    check_output=$(brew bundle check --file="$REPO_DIR/brew/Brewfile" --no-upgrade --verbose 2>&1)
    local check_exit=$?

    if [ $check_exit -ne 0 ]; then
        echo "$check_output" >&2
        error "brew bundle check reports unmet dependencies (bundle exit $bundle_exit, check exit $check_exit). See output above. Likely cause: a renamed/deleted formula or cask in the Brewfile — prune the failing entry and re-run."
    fi

    if [ $bundle_exit -ne 0 ]; then
        log "⚠ brew bundle returned exit $bundle_exit but all required packages are present (likely a deprecated entry skipped). Continuing."
    fi

    success "Packages installed"
}

apply_macos_settings() {
    log "Applying macOS system settings..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would run: $REPO_DIR/system/macos.sh"
        return
    fi
    
    if [ ! -f "$REPO_DIR/system/macos.sh" ]; then
        error "macos.sh not found at $REPO_DIR/system/macos.sh"
    fi
    
    if ! bash "$REPO_DIR/system/macos.sh"; then
        log "⚠ Some macOS settings failed to apply (commonly TCC/Safari sandbox issues). Continuing."
        return 0
    fi

    success "macOS settings applied"
}

print_installation_plan() {
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "Dotfiles Installation Plan"
    echo "═══════════════════════════════════════════════════════════"
    
    [ "$INSTALL_SHELL" = true ] && echo "✓ Shell configuration (Zsh, aliases, Oh-My-Zsh)"
    [ "$INSTALL_EDITOR" = true ] && echo "✓ Editor configuration (Neovim)"
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
        install_homebrew
        install_oh_my_zsh
        configure_zsh
        install_dotfiles
        install_zsh_theme
    fi
    
    if [ "$INSTALL_GIT" = true ]; then
        log "═ Git Configuration ═"
        install_dotfiles
    fi
    
    if [ "$INSTALL_TERMINAL" = true ]; then
        log "═ Terminal Configuration ═"
        install_dotfiles
        install_tmux_plugins
    fi
    
    if [ "$INSTALL_EDITOR" = true ]; then
        log "═ Editor Configuration ═"
        install_dotfiles
        install_neovim_config
    fi
    
    if [ "$INSTALL_BREW" = true ]; then
        log "═ Packages & Applications ═"
        install_homebrew
        install_packages
    fi

    if [ "$INSTALL_SYSTEM" = true ]; then
        log "═ System Preferences ═"
        apply_macos_settings
        restore_keyboard_shortcuts
    fi
    
    echo ""
    if [ "$DRY_RUN" = false ]; then
        success "Installation complete!"
        echo ""
        echo "Next steps:"
        echo "1. Reload your terminal: exec zsh"
        echo "2. Run validation: ./scripts/validate-setup.sh"
        echo "3. Review documentation: https://github.com/jasonfungsing/dotfiles"
    else
        log "Dry run complete. No changes were made."
        echo ""
        echo "To proceed with installation, run:"
        echo "  ./install.sh"
    fi
    echo ""
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
