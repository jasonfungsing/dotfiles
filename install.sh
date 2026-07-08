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
VALIDATE_ONLY=false

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

# link_file <source> <target>
# Symlinks target → source, overriding whatever is there so re-runs always
# converge on the repo's state: correct symlinks are left alone, wrong or
# dangling ones are re-pointed, and a pre-existing real file or directory is
# moved to <target>.backup.<timestamp> before linking so nothing is lost.
link_file() {
    local source="$1" target="$2"

    if [ ! -e "$source" ]; then
        log "Skipping $target (source $source missing)"
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would symlink: $source → $target"
        return
    fi

    if [ -L "$target" ]; then
        if [ "$(readlink "$target")" = "$source" ]; then
            success "Symlinked $target (already correct)"
            return
        fi
    elif [ -e "$target" ]; then
        local backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
        mv "$target" "$backup"
        log "Backed up existing $target → $backup"
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$source" "$target"
    success "Symlinked $target"
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
            --validate)
                VALIDATE_ONLY=true
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
  --validate        Validate the current setup without installing anything
  --dry-run         Show what would be done without making changes
  -h, --help        Show this help message

EXAMPLES:
  ./install.sh                # Install everything (validates at the end)
  ./install.sh --shell-only   # Install only shell config
  ./install.sh --no-brew      # Install everything except packages
  ./install.sh --validate     # Only run setup validation
  ./install.sh --dry-run      # Show what would be done
EOF
}

install_dotfiles() {
    log "Installing dotfiles..."

    link_file "$REPO_DIR/terminal/zshrc" "$HOME/.zshrc"
    link_file "$REPO_DIR/terminal/alias_prompt.sh" "$HOME/.alias_prompt.sh"
    link_file "$REPO_DIR/terminal/tmux.conf" "$HOME/.tmux.conf"
    link_file "$REPO_DIR/git/gitconfig" "$HOME/.gitconfig"
    # Note: iTerm2 config (app/iterm2/) is not symlinked — iTerm2 only loads
    # preferences via Settings → General → Preferences → "Load preferences from
    # a custom folder", which must be set manually in the UI.
    link_file "$REPO_DIR/mac/hushlogin" "$HOME/.hushlogin"
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

    # Symlink every file and directory from neovim/ (except README.md)
    local item name
    for item in "$REPO_DIR/neovim"/*; do
        name="$(basename "$item")"
        [ "$name" = "README.md" ] && continue
        link_file "$item" "$HOME/.config/nvim/$name"
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

    link_file "$REPO_DIR/terminal/cobalt2.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/cobalt2.zsh-theme"
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
        log "[DRY RUN] Would restore keyboard shortcuts from $REPO_DIR/mac/keyboard-shortcuts.json"
        return
    fi
    
    local shortcuts_file="$REPO_DIR/mac/keyboard-shortcuts.json"
    
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
        log "[DRY RUN] Would run: $REPO_DIR/mac/macos.sh"
        return
    fi
    
    if [ ! -f "$REPO_DIR/mac/macos.sh" ]; then
        error "macos.sh not found at $REPO_DIR/mac/macos.sh"
    fi
    
    if ! bash "$REPO_DIR/mac/macos.sh"; then
        log "⚠ Some macOS settings failed to apply (commonly TCC/Safari sandbox issues). Continuing."
        return 0
    fi

    success "macOS settings applied"
}

# ═══ Setup validation ═══
# Every check either passes or fails — failures are counted and reported,
# so a green run means the setup actually works.

PASSED=0
FAILED=0

v_pass() {
    echo "✓ $1"
    PASSED=$((PASSED+1))
}

v_fail() {
    echo "✗ $1${2:+ — $2}"
    FAILED=$((FAILED+1))
}

v_section() {
    echo ""
    echo "═══ $1 ═══"
}

# v_check <description> <command...>
# Runs the command; passes on exit 0, otherwise fails and shows the first
# line of its output as the reason.
v_check() {
    local desc="$1" out
    shift
    if out=$("$@" 2>&1); then
        v_pass "$desc"
    else
        v_fail "$desc" "$(echo "$out" | head -1)"
    fi
}

# v_check_symlink <link> <expected-target>
# The link must exist, be a symlink, point at the expected repo file,
# and resolve (a dangling symlink is a failure, not a pass).
v_check_symlink() {
    local link="$1" expected="$2" actual
    local desc="$link"
    [ "${link#"$HOME"/}" != "$link" ] && desc="~/${link#"$HOME"/}"
    desc="$desc → ${expected#"$REPO_DIR"/}"
    if [ ! -e "$link" ] && [ ! -L "$link" ]; then
        v_fail "$desc" "missing"
    elif [ ! -L "$link" ]; then
        v_fail "$desc" "exists but is not a symlink"
    else
        actual="$(readlink "$link")"
        if [ "$actual" != "$expected" ]; then
            v_fail "$desc" "points to $actual"
        elif [ ! -e "$link" ]; then
            v_fail "$desc" "dangling symlink"
        else
            v_pass "$desc"
        fi
    fi
}

v_check_nvim_loads() {
    local err
    # First launch may bootstrap plugins (lazy.nvim) — warm it up, then
    # require a clean, silent start.
    nvim --headless +quitall > /dev/null 2>&1 || true
    err=$(nvim --headless +quitall 2>&1)
    if [ -n "$err" ]; then
        echo "$err"
        return 1
    fi
}

v_check_tmux_config() {
    local sock="validate-$$" err rc
    err=$(tmux -L "$sock" -f "$HOME/.tmux.conf" new-session -d true 2>&1)
    rc=$?
    tmux -L "$sock" kill-server 2>/dev/null
    if [ $rc -ne 0 ] || [ -n "$err" ]; then
        echo "$err"
        return 1
    fi
}

v_check_brew_bundle() {
    local out rc missing
    out=$(brew bundle check --file="$REPO_DIR/brew/Brewfile" --verbose 2>/dev/null)
    rc=$?
    if [ $rc -ne 0 ]; then
        missing=$(echo "$out" | grep -c "needs to be installed")
        echo "$missing entries missing or outdated (brew bundle check --verbose for the list)"
        return 1
    fi
}

run_validation() {
    # Checks are expected to fail without aborting the script
    set +e
    PASSED=0
    FAILED=0

    v_section "Symlinks"

    v_check_symlink "$HOME/.zshrc" "$REPO_DIR/terminal/zshrc"
    v_check_symlink "$HOME/.alias_prompt.sh" "$REPO_DIR/terminal/alias_prompt.sh"
    v_check_symlink "$HOME/.tmux.conf" "$REPO_DIR/terminal/tmux.conf"
    v_check_symlink "$HOME/.gitconfig" "$REPO_DIR/git/gitconfig"
    v_check_symlink "$HOME/.hushlogin" "$REPO_DIR/mac/hushlogin"
    v_check_symlink "$HOME/.oh-my-zsh/custom/themes/cobalt2.zsh-theme" "$REPO_DIR/terminal/cobalt2.zsh-theme"

    # install.sh symlinks every item in neovim/ (except README.md) into ~/.config/nvim
    local item name
    for item in "$REPO_DIR/neovim"/*; do
        name="$(basename "$item")"
        [ "$name" = "README.md" ] && continue
        v_check_symlink "$HOME/.config/nvim/$name" "$item"
    done

    v_section "Configs Load"

    if command_exists zsh; then
        v_check "zshrc has valid syntax" zsh -n "$HOME/.zshrc"
        v_check "zsh starts interactively" zsh -ic 'exit 0'
    else
        v_fail "zsh installed" "not found"
    fi

    if command_exists nvim; then
        v_check "Neovim loads config headlessly" v_check_nvim_loads
    else
        v_fail "Neovim installed" "not found"
    fi

    if command_exists tmux; then
        v_check "tmux config parses" v_check_tmux_config
    else
        v_fail "tmux installed" "not found"
    fi

    v_check "gitconfig is readable (user.name set)" git config --get user.name

    v_section "Shell Environment"

    v_check "Zsh is the default shell" sh -c 'echo "$SHELL" | grep -q zsh'
    [ -d "$HOME/.oh-my-zsh" ] && v_pass "Oh-My-Zsh is installed" || v_fail "Oh-My-Zsh is installed" "~/.oh-my-zsh missing"

    v_section "Homebrew"

    if command_exists brew; then
        v_pass "Homebrew is installed"
        v_check "Brewfile packages installed (brew bundle check)" v_check_brew_bundle
    else
        v_fail "Homebrew is installed" "not found"
    fi

    v_section "Key Tools"

    local tool
    for tool in git jq node python3 go; do
        v_check "$tool is installed" command -v "$tool"
    done

    v_section "Repo Health"

    if command_exists jq; then
        v_check "keyboard-shortcuts.json is valid JSON" jq empty "$REPO_DIR/mac/keyboard-shortcuts.json"
    fi
    v_check "install.sh has valid syntax" bash -n "$REPO_DIR/install.sh"

    v_section "Summary"

    echo ""
    echo "Validation Results:"
    echo "  ✓ Passed: $PASSED"
    echo "  ✗ Failed: $FAILED"
    echo ""

    if [ "$FAILED" -eq 0 ]; then
        echo "Setup validation successful!"
    else
        echo "Some checks failed. Review the output above."
    fi

    set -e
    [ "$FAILED" -eq 0 ]
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

    if [ "$VALIDATE_ONLY" = true ]; then
        if run_validation; then
            exit 0
        else
            exit 1
        fi
    fi

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

        local validation_ok=true
        if [ "$INSTALL_SHELL" = true ] && [ "$INSTALL_EDITOR" = true ] && \
           [ "$INSTALL_GIT" = true ] && [ "$INSTALL_TERMINAL" = true ] && \
           [ "$INSTALL_SYSTEM" = true ] && [ "$INSTALL_BREW" = true ]; then
            log "═ Validating Setup ═"
            run_validation || validation_ok=false
        else
            echo ""
            echo "Partial install — validate the full setup with: ./install.sh --validate"
        fi

        echo ""
        echo "Next steps:"
        echo "1. Reload your terminal: exec zsh"
        echo "2. Review documentation: https://github.com/jasonfungsing/dotfiles"

        if [ "$validation_ok" = false ]; then
            echo ""
            error "Installation finished but validation failed. Review the output above."
        fi
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
