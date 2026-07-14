#!/usr/bin/env bash

# No `set -e` on purpose: individual step failures are recorded and reported
# at the end while the rest of the install continues. Only preflight_checks
# (conditions under which nothing could install) aborts the script.

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
PRUNE_BREW=true
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

# ═══ Step failure handling ═══
# Steps run through run_step: a failing step is recorded and the install
# moves on. All failures are listed in a summary at the end and make the
# script exit non-zero.

FAILED_STEPS=()

# run_step <description> <function> [args...]
run_step() {
    local desc="$1"
    shift
    if "$@"; then
        return 0
    fi
    FAILED_STEPS+=("$desc")
    echo "⚠ Step failed (continuing): $desc" >&2
}

# Installs Xcode Command Line Tools if missing. Tries the headless
# softwareupdate route first (a touch-file makes the CLT appear in the
# update catalogue — the same trick CI systems use), then falls back to
# the GUI installer and waits for the user to click through.
ensure_command_line_tools() {
    if xcode-select -p > /dev/null 2>&1; then
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would install Xcode Command Line Tools"
        return 0
    fi

    log "Xcode Command Line Tools missing — attempting automatic install..."

    local touchfile="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
    touch "$touchfile"
    local label
    label=$(softwareupdate -l 2>/dev/null | grep -o 'Label: Command Line Tools.*' | sed 's/^Label: //' | sort -V | tail -1)
    if [ -n "$label" ]; then
        log "Installing: $label (this can take 5-15 minutes)..."
        sudo softwareupdate -i "$label" --verbose
    fi
    rm -f "$touchfile"

    if xcode-select -p > /dev/null 2>&1; then
        success "Command Line Tools installed"
        return 0
    fi

    # Headless route failed — hand over to the GUI installer and wait
    if [ -t 0 ]; then
        log "Opening the Command Line Tools installer — click Install in the dialog (waiting up to 30 minutes)..."
        xcode-select --install > /dev/null 2>&1
        local waited=0
        until xcode-select -p > /dev/null 2>&1; do
            sleep 15
            waited=$((waited + 15))
            [ "$waited" -ge 1800 ] && break
        done
    fi

    if xcode-select -p > /dev/null 2>&1; then
        success "Command Line Tools installed"
        return 0
    fi

    error "Could not install Xcode Command Line Tools automatically. Run: xcode-select --install  (then re-run this script)"
}

# Fatal, system-wide conditions only — anything that means NOTHING could
# install. Everything else is a recoverable per-step failure.
preflight_checks() {
    [ "$(uname -s)" = "Darwin" ] || error "This script only supports macOS."

    [ "$(id -u)" -ne 0 ] || error "Do not run as root/sudo — Homebrew refuses root and symlinks would land in root's home. Run as your normal user; steps that need admin rights prompt for the password themselves."

    [ -n "$HOME" ] && [ -w "$HOME" ] || error "\$HOME is not set or not writable."

    ensure_command_line_tools

    local f
    for f in brew/Brewfile terminal/zshrc mac/macos.sh neovim/init.lua; do
        [ -e "$REPO_DIR/$f" ] || error "Repository incomplete: $REPO_DIR/$f is missing. Re-clone the dotfiles repo."
    done

    # A full install needs ~5-10 GB (Xcode's App Store copy alone is huge)
    local free_gb
    free_gb=$(df -g "$HOME" 2>/dev/null | awk 'NR==2 {print $4}')
    if [ -n "$free_gb" ] && [ "$free_gb" -lt 10 ]; then
        echo "⚠ Only ${free_gb} GB free — a full install needs 5-10 GB; downloads may fail partway." >&2
    fi

    if [ "$DRY_RUN" = false ]; then
        if ! curl -fsSL --max-time 10 --head https://github.com > /dev/null 2>&1; then
            error "No network connectivity (github.com unreachable) — Homebrew, packages, Oh-My-Zsh, and tmux plugins all need it. Connect and re-run. (On a corporate network, an SSL-inspecting proxy can also cause this — check HTTPS_PROXY settings.)"
        fi
    fi
}

# Ask for the admin password once up front and keep it fresh in the
# background — several cask installers (Okta Verify, Logi Options+,
# Little Snitch) and App Store removals need sudo, and a mid-run prompt
# can time out unnoticed during long downloads.
SUDO_KEEPALIVE_PID=""

prime_sudo() {
    if [ ! -t 0 ]; then
        log "Non-interactive run — skipping sudo priming; steps needing admin rights may fail and will be listed in the summary."
        return 0
    fi
    log "Some app installers need admin rights — you may be asked for your password now (once)."
    if sudo -v; then
        ( while sleep 50; do sudo -n -v 2> /dev/null || exit; kill -0 "$$" 2> /dev/null || exit; done ) &
        SUDO_KEEPALIVE_PID=$!
        trap '[ -n "$SUDO_KEEPALIVE_PID" ] && kill "$SUDO_KEEPALIVE_PID" 2> /dev/null' EXIT
    else
        log "⚠ Could not obtain admin rights — steps needing sudo may fail and will be listed in the summary."
    fi
    return 0
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
        if ! mv "$target" "$backup"; then
            FAILED_STEPS+=("symlink $target (could not back up existing file)")
            echo "⚠ Could not back up $target — leaving it untouched" >&2
            return 1
        fi
        log "Backed up existing $target → $backup"
    fi

    if ! mkdir -p "$(dirname "$target")" || ! ln -sfn "$source" "$target"; then
        FAILED_STEPS+=("symlink $target")
        echo "⚠ Failed to symlink $target" >&2
        return 1
    fi
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
            --no-prune)
                PRUNE_BREW=false
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
  --no-prune        Keep brew packages that are not declared in the Brewfile
  --validate        Validate the current setup without installing anything
  --dry-run         Show what would be done without making changes
  -h, --help        Show this help message

The Brewfile is the source of truth: by default, brew packages, casks, taps,
and VS Code extensions NOT declared in it are uninstalled during a run.
Pass --no-prune to keep undeclared extras.

EXAMPLES:
  ./install.sh                # Install everything (validates at the end)
  ./install.sh --shell-only   # Install only shell config
  ./install.sh --no-brew      # Install everything except packages
  ./install.sh --no-prune     # Install, but keep undeclared brew extras
  ./install.sh --validate     # Only run setup validation
  ./install.sh --dry-run      # Show what would be done
EOF
}

# Per-component dotfile linking. link_file records its own failures, so
# these always return 0 — a failed link is reported without failing the
# surrounding step twice.

install_shell_dotfiles() {
    log "Linking shell dotfiles..."
    link_file "$REPO_DIR/terminal/zshrc" "$HOME/.zshrc"
    link_file "$REPO_DIR/terminal/alias_prompt.sh" "$HOME/.alias_prompt.sh"
    return 0
}

install_git_dotfiles() {
    log "Linking git config..."
    link_file "$REPO_DIR/git/gitconfig" "$HOME/.gitconfig"
    return 0
}

install_terminal_dotfiles() {
    log "Linking terminal dotfiles..."
    # Note: iTerm2 config (app/iterm2/) is not symlinked — configure_iterm2
    # points iTerm2's "load settings from a custom folder" setting at it.
    link_file "$REPO_DIR/terminal/tmux.conf" "$HOME/.tmux.conf"
    return 0
}

install_system_dotfiles() {
    log "Linking system dotfiles..."
    link_file "$REPO_DIR/mac/hushlogin" "$HOME/.hushlogin"
    return 0
}

install_homebrew() {
    log "Checking Homebrew..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would install Homebrew"
        return
    fi
    
    if ! command_exists brew; then
        log "Installing Homebrew..."
        if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
            log "✗ Homebrew installation failed"
            return 1
        fi
        success "Homebrew installed"
    else
        success "Homebrew already installed"
    fi

    # Put brew on this script's PATH regardless of prefix:
    # /opt/homebrew on Apple Silicon, /usr/local on Intel.
    local prefix
    for prefix in /opt/homebrew /usr/local; do
        if [ -x "$prefix/bin/brew" ]; then
            eval "$("$prefix/bin/brew" shellenv)"
            break
        fi
    done

    command_exists brew || { log "✗ brew still not on PATH after install"; return 1; }
}

install_oh_my_zsh() {
    log "Checking Oh-My-Zsh..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would install Oh-My-Zsh"
        return
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh-My-Zsh..."
        if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
            log "✗ Oh-My-Zsh installation failed"
            return 1
        fi
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

    if [ -z "$zsh_path" ]; then
        log "✗ zsh not found on PATH"
        return 1
    fi

    if ! grep "$zsh_path" /etc/shells > /dev/null; then
        log "Adding $zsh_path to /etc/shells"
        if ! echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null; then
            log "✗ Could not add $zsh_path to /etc/shells"
            return 1
        fi
    fi

    if [ "$SHELL" != "$zsh_path" ]; then
        if ! chsh -s "$zsh_path"; then
            log "✗ chsh failed to change the default shell"
            return 1
        fi
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


configure_iterm2() {
    log "Configuring iTerm2 preferences folder..."

    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would point iTerm2 at $REPO_DIR/app/iterm2 for preferences"
        return
    fi

    if [ ! -d "/Applications/iTerm.app" ]; then
        log "iTerm2 not installed. Skipping preferences configuration."
        return
    fi

    if pgrep -xq iTerm2; then
        log "⚠ iTerm2 is running — it may overwrite this setting when it quits. Re-run after closing iTerm2 if it doesn't stick."
    fi

    if ! defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$REPO_DIR/app/iterm2" || \
       ! defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true; then
        log "✗ Failed to write iTerm2 preference keys"
        return 1
    fi
    success "iTerm2 set to load settings from $REPO_DIR/app/iterm2"
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
        log "✗ tmux not found — it should have been installed by the packages step"
        return 1
    fi

    local tpm_path="$HOME/.tmux/plugins/tpm"

    if [ ! -d "$tpm_path" ]; then
        log "Cloning Tmux Plugin Manager..."
        if ! git clone https://github.com/tmux-plugins/tpm "$tpm_path"; then
            log "✗ Failed to clone TPM"
            return 1
        fi
        success "TPM cloned successfully"
    else
        success "TPM already installed"
    fi

    log "Installing Tmux plugins..."
    if ! "$tpm_path/bin/install_plugins" > /dev/null 2>&1; then
        log "✗ TPM plugin installation failed (run $tpm_path/bin/install_plugins to see why)"
        return 1
    fi
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
        log "✗ Keyboard shortcuts file not found at $shortcuts_file"
        return 1
    fi

    if ! command_exists jq; then
        log "✗ jq not found — it should have been installed by the packages step"
        return 1
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

    # Current brew bundle has no per-type install filters (--no-cask etc.
    # were removed) — for --no-apps, install from a formulae-only copy of
    # the Brewfile instead.
    local brewfile="$REPO_DIR/brew/Brewfile"
    if [ "$INSTALL_APPS" = false ]; then
        brewfile=$(mktemp /tmp/Brewfile.formulae.XXXXXX)
        grep -E '^(tap|brew) ' "$REPO_DIR/brew/Brewfile" > "$brewfile"
        log "Apps skipped — installing formulae only (${brewfile})"
    fi

    local bundle_args=(install --file="$brewfile" --verbose)

    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would run: brew bundle ${bundle_args[*]}"
        return
    fi

    if ! command_exists brew; then
        log "✗ Homebrew not installed. Cannot install packages."
        return 1
    fi

    log "Running: brew bundle ${bundle_args[*]}"
    # One transient download failure (CDN 503, dropped connection) makes brew
    # bundle abort the whole batch before installing anything. Run it once for
    # bulk speed, then install whatever is still unmet entry-by-entry below —
    # a bad download then only fails that one entry.
    brew bundle "${bundle_args[@]}"

    local unmet
    unmet=$(unmet_brewfile_entries)
    if [ -z "$unmet" ]; then
        success "Packages installed"
        return 0
    fi

    log "⚠ brew bundle left some entries unsatisfied — installing them individually so one failure can't block the rest..."
    while IFS= read -r line; do
        install_unmet_entry "$line"
    done <<< "$unmet"

    unmet=$(unmet_brewfile_entries)
    if [ -n "$unmet" ]; then
        echo "$unmet" >&2
        log "✗ Some Brewfile entries could not be installed (each is listed in the failure summary). Transient download errors usually clear — re-run ./install.sh later."
        return 1
    fi

    success "Packages installed (some recovered individually)"
}

# Unmet Brewfile entries as "→ ..." lines from brew bundle check.
# Respects --no-apps by only reporting formulae in that mode.
unmet_brewfile_entries() {
    local out
    out=$(brew bundle check --file="$REPO_DIR/brew/Brewfile" --no-upgrade --verbose 2>&1 | grep "^→ ")
    if [ "$INSTALL_APPS" = false ]; then
        out=$(echo "$out" | grep "^→ Formula" || true)
    fi
    echo "$out"
}

# brew_item <description> <command...> — one package/app/extension install;
# a failure is recorded by name and the caller moves on to the next entry.
brew_item() {
    local desc="$1" out
    shift
    log "Installing $desc..."
    if out=$("$@" 2>&1); then
        success "$desc"
        return 0
    fi
    echo "$out" | tail -2 >&2
    FAILED_STEPS+=("brew entry: $desc")
    echo "⚠ Failed: $desc (continuing with remaining entries)" >&2
    return 1
}

# install_unmet_entry <line> — dispatch one "→ ..." line from bundle check.
install_unmet_entry() {
    local line="${1#→ }" name id
    case "$line" in
        "Formula "*" needs to be linked."*)
            name="${line#Formula }"; name="${name%% needs*}"
            local link_out
            if link_out=$(brew link --overwrite "$name" 2>&1); then
                success "link formula $name"
            elif echo "$link_out" | grep -q "keg-only"; then
                success "formula $name is keg-only — linking not required"
            else
                echo "$link_out" | tail -2 >&2
                FAILED_STEPS+=("brew entry: link formula $name")
                echo "⚠ Failed: link formula $name (continuing with remaining entries)" >&2
            fi
            ;;
        "Formula "*)
            name="${line#Formula }"; name="${name%% needs*}"
            if brew list --formula "$name" > /dev/null 2>&1; then
                brew_item "formula $name (upgrade)" brew upgrade "$name"
            else
                brew_item "formula $name" brew install "$name"
            fi
            ;;
        "Cask "*)
            name="${line#Cask }"; name="${name%% needs*}"
            if brew list --cask "$name" > /dev/null 2>&1; then
                brew_item "cask $name (upgrade)" brew upgrade --cask "$name"
            else
                # --adopt takes ownership of an already-installed app
                # instead of erroring; a plain install when absent.
                brew_item "cask $name" brew install --cask --adopt "$name"
            fi
            ;;
        "App "*)
            name="${line#App }"; name="${name%% needs*}"
            id=$(grep -F "mas \"$name\"" "$REPO_DIR/brew/Brewfile" | sed -E 's/.*id: ([0-9]+).*/\1/' | head -1)
            if [ -n "$id" ]; then
                brew_item "App Store app $name" mas install "$id"
            else
                FAILED_STEPS+=("brew entry: App Store app $name (no id found in Brewfile)")
            fi
            ;;
        "VSCode Extension "*)
            name="${line#VSCode Extension }"; name="${name%% needs*}"
            brew_item "VS Code extension $name" code --install-extension "$name"
            ;;
        *)
            FAILED_STEPS+=("brew entry: unrecognised bundle check line: $line")
            ;;
    esac
}

# Uninstalls every brew formula, cask, tap, and VS Code extension that is
# not declared in the Brewfile (dependencies of declared packages are kept).
# The Brewfile is the source of truth; --no-prune skips this step.
prune_packages() {
    log "Pruning brew packages not declared in the Brewfile..."

    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would uninstall all brew packages, casks, taps, and VS Code extensions not declared in the Brewfile"
        return
    fi

    if ! command_exists brew; then
        log "✗ Homebrew not installed. Nothing to prune."
        return 1
    fi

    local plan
    plan=$(brew bundle cleanup --file="$REPO_DIR/brew/Brewfile" 2>&1 | grep -v "bundle cleanup --force")

    # cleanup exits 1 both for "items pending" and real errors — the output
    # is the reliable signal. An error must not read as "nothing to prune".
    if echo "$plan" | grep -q "^Error"; then
        echo "$plan" | grep "^Error" >&2
        log "✗ brew bundle cleanup failed — cannot tell whether undeclared packages remain"
        return 1
    fi

    if ! echo "$plan" | grep -q "Would"; then
        success "Nothing to prune — machine matches the Brewfile"
        return 0
    fi

    echo "$plan" | sed 's/^Would uninstall/Removing/; s/^Would untap/Untapping/'
    log "Removing (App Store apps may prompt for your password)..."
    brew bundle cleanup --force --file="$REPO_DIR/brew/Brewfile"

    # brew bundle can report App Store uninstalls as done even when sudo was
    # denied — verify convergence instead of trusting its exit status.
    local remaining
    remaining=$(brew bundle cleanup --file="$REPO_DIR/brew/Brewfile" 2>/dev/null | grep -v "bundle cleanup --force")
    if echo "$remaining" | grep -q "Would"; then
        echo "$remaining"
        log "✗ Some undeclared items could not be removed (App Store apps need an admin password — remove them via Finder, or declare them in the Brewfile)"
        return 1
    fi

    brew autoremove > /dev/null 2>&1 || true
    success "Machine now matches the Brewfile"
}

apply_macos_settings() {
    log "Applying macOS system settings..."
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY RUN] Would run: $REPO_DIR/mac/macos.sh"
        return
    fi
    
    if ! bash "$REPO_DIR/mac/macos.sh"; then
        log "✗ macos.sh exited with an error"
        return 1
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

    if [ -d "/Applications/iTerm.app" ]; then
        if [ "$(defaults read com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null)" = "$REPO_DIR/app/iterm2" ]; then
            v_pass "iTerm2 loads preferences from app/iterm2"
        else
            v_fail "iTerm2 loads preferences from app/iterm2" "PrefsCustomFolder is $(defaults read com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null || echo unset)"
        fi
    fi

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

    preflight_checks
    print_installation_plan

    if [ "$INSTALL_BREW" = true ] && [ "$INSTALL_APPS" = true ] && [ "$DRY_RUN" = false ]; then
        prime_sudo
    fi

    # Packages and applications install first so config steps that need the
    # binaries (tmux plugins, Neovim bootstrap, iTerm2 preferences) find them.
    if [ "$INSTALL_BREW" = true ] || [ "$INSTALL_SHELL" = true ]; then
        log "═ Homebrew ═"
        run_step "Install Homebrew" install_homebrew
    fi

    if [ "$INSTALL_BREW" = true ]; then
        log "═ Packages & Applications ═"
        run_step "Install Brewfile packages and applications" install_packages
        if [ "$PRUNE_BREW" = true ]; then
            run_step "Prune brew packages not in the Brewfile" prune_packages
        fi
    fi

    if [ "$INSTALL_SHELL" = true ]; then
        log "═ Shell Configuration ═"
        run_step "Install Oh-My-Zsh" install_oh_my_zsh
        run_step "Set Zsh as default shell" configure_zsh
        run_step "Link shell dotfiles" install_shell_dotfiles
        run_step "Install cobalt2 zsh theme" install_zsh_theme
    fi

    if [ "$INSTALL_GIT" = true ]; then
        log "═ Git Configuration ═"
        run_step "Link git config" install_git_dotfiles
    fi

    if [ "$INSTALL_TERMINAL" = true ]; then
        log "═ Terminal Configuration ═"
        run_step "Link terminal dotfiles" install_terminal_dotfiles
        run_step "Install tmux plugins" install_tmux_plugins
        run_step "Configure iTerm2 preferences folder" configure_iterm2
    fi

    if [ "$INSTALL_EDITOR" = true ]; then
        log "═ Editor Configuration ═"
        run_step "Link Neovim config" install_neovim_config
    fi

    if [ "$INSTALL_SYSTEM" = true ]; then
        log "═ System Preferences ═"
        run_step "Link system dotfiles" install_system_dotfiles
        run_step "Apply macOS settings" apply_macos_settings
        run_step "Restore keyboard shortcuts" restore_keyboard_shortcuts
    fi

    echo ""
    if [ "$DRY_RUN" = false ]; then
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

        # Failure summary — every recorded step failure, listed at the end.
        echo ""
        if [ ${#FAILED_STEPS[@]} -eq 0 ]; then
            success "Installation complete — all steps succeeded!"
        else
            echo "⚠ Installation finished with ${#FAILED_STEPS[@]} failed step(s):"
            local s
            for s in "${FAILED_STEPS[@]}"; do
                echo "  ✗ $s"
            done
            echo ""
            echo "Fix the causes and re-run ./install.sh — completed steps are idempotent."
        fi

        echo ""
        echo "Next steps:"
        echo "1. Reload your terminal: exec zsh"
        echo "2. Review documentation: https://github.com/jasonfungsing/dotfiles"

        if [ ${#FAILED_STEPS[@]} -gt 0 ] || [ "$validation_ok" = false ]; then
            exit 1
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
