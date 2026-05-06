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
    local system_files=("system/com.googlecode.iterm2.plist" "system/hushlogin")
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

install_raycast_scripts() {
    log "Installing Raycast scripts..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would symlink Raycast scripts"
        return
    fi
    
    if [ ! -d "$HOME/Library/Application Support/Raycast" ]; then
        log "Raycast not found. Skipping Raycast scripts installation."
        return
    fi
    
    mkdir -p "$HOME/Library/Application Support/Raycast/Extensions/scripts"
    
    local raycast_scripts=("summarize-screen.sh" "summarize-screen-ai.sh")
    for script in "${raycast_scripts[@]}"; do
        local source="$REPO_DIR/raycast-scripts/$script"
        local target="$HOME/Library/Application Support/Raycast/Extensions/scripts/$script"
        
        if [ ! -f "$source" ]; then
            continue
        fi
        
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            log "Skipping $target (already exists)"
        else
            ln -sf "$source" "$target"
            chmod +x "$target"
            success "Symlinked $script"
        fi
    done
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
    
    # Restore symbolic hotkeys (system-level keyboard shortcuts)
    restore_symbolic_hotkeys "$shortcuts_file"
    
    # Restore Safari NSUserKeyEquivalents
    restore_safari_shortcuts "$shortcuts_file"
    
    # Restore all other app preferences (Chrome, VSCode, iTerm2, etc.)
    restore_all_app_preferences "$shortcuts_file"
    
    success "Keyboard shortcuts restored"
}

restore_symbolic_hotkeys() {
    local shortcuts_file="$1"
    local plist_file="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
    
    # Ensure plist file exists
    if [ ! -f "$plist_file" ]; then
        log "Creating symbolic hotkeys plist..."
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict
    fi
    
    # Extract and apply each symbolic hotkey
    jq -r '.keyboard_shortcuts["com.apple.symbolichotkeys"].AppleSymbolicHotKeys // empty | 
        to_entries[] | "\(.key)|\(.value | @json)"' "$shortcuts_file" | while IFS='|' read -r key value; do
        if [ -n "$key" ] && [ -n "$value" ]; then
            plutil -insert "AppleSymbolicHotKeys.$key" -json "$value" "$plist_file" 2>/dev/null || true
        fi
    done
}

restore_safari_shortcuts() {
    local shortcuts_file="$1"
    
    # Extract Safari NSUserKeyEquivalents
    jq -r '.keyboard_shortcuts["com.apple.Safari"].NSUserKeyEquivalents // empty | 
        to_entries[] | "\(.key)|\(.value)"' "$shortcuts_file" | while IFS='|' read -r menuitem shortcut; do
        if [ -n "$menuitem" ] && [ -n "$shortcut" ]; then
            defaults write com.apple.Safari NSUserKeyEquivalents -dict-add "$menuitem" "$shortcut" 2>/dev/null || true
        fi
    done
}

restore_all_app_preferences() {
    local shortcuts_file="$1"
    
    # Get all domains in keyboard_shortcuts
    jq -r '.keyboard_shortcuts | keys[]' "$shortcuts_file" | while read -r domain; do
        # Skip already-handled domains
        if [[ "$domain" == "com.apple.symbolichotkeys" ]] || [[ "$domain" == "com.apple.Safari" ]]; then
            continue
        fi
        
        # Skip empty domain names
        if [ -z "$domain" ]; then
            continue
        fi
        
        log "Restoring preferences for: $domain"
        
        local plist_path="$HOME/Library/Preferences/${domain}.plist"
        local domain_json=$(jq ".keyboard_shortcuts[\"$domain\"]" "$shortcuts_file" 2>/dev/null || echo '{}')
        
        # Only proceed if we have valid JSON data
        if [ "$domain_json" != "{}" ] && [ -n "$domain_json" ]; then
            # Write preferences using defaults write for each key-value pair
            jq -r 'to_entries[] | "\(.key)|\(.value | @json)"' <<< "$domain_json" | while IFS='|' read -r key value; do
                if [ -n "$key" ] && [ -n "$value" ]; then
                    # Try to write the preference (handles various types)
                    defaults write "$domain" "$key" -json "$value" 2>/dev/null || true
                fi
            done
        fi
    done
}

install_packages() {
    log "Installing Homebrew packages..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would run: brew bundle --file=$REPO_DIR/brew/Brewfile"
        return
    fi
    
    if ! command_exists brew; then
        error "Homebrew not installed. Cannot install packages."
    fi
    
    if [ -f "$REPO_DIR/brew/Brewfile" ]; then
        brew bundle --file="$REPO_DIR/brew/Brewfile"
        success "Packages installed"
    else
        error "Brewfile not found at $REPO_DIR/brew/Brewfile"
    fi
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
        error "Failed to apply macOS settings"
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
        install_raycast_scripts
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
    
    if [ "$INSTALL_SYSTEM" = true ]; then
        log "═ System Preferences ═"
        apply_macos_settings
        restore_keyboard_shortcuts
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
