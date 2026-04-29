#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_FILE="$REPO_DIR/system/keyboard-shortcuts.json"

log() {
    echo "→ $1"
}

success() {
    echo "✓ $1"
}

error() {
    echo "✗ Error: $1" >&2
    exit 1
}

export_shortcuts() {
    log "Exporting keyboard shortcuts from macOS defaults..."
    
    local temp_file="/tmp/shortcuts_export.json"
    
    # Start JSON structure
    echo "{" > "$temp_file"
    
    # Export common application shortcuts
    # Finder
    log "Exporting Finder shortcuts..."
    {
        echo '  "com.apple.finder": {'
        defaults read com.apple.finder 2>/dev/null | grep -E "^\s+\".*\" = " | sed 's/^[[:space:]]*//' | head -10 || true
        echo '  },'
    } >> "$temp_file"
    
    # Global shortcuts
    log "Exporting global shortcuts..."
    {
        echo '  "NSGlobalDomain": {'
        defaults read NSGlobalDomain 2>/dev/null | grep -E "^\s+\".*\" = " | sed 's/^[[:space:]]*//' | head -20 || true
        echo '  },'
    } >> "$temp_file"
    
    # System Preferences (macOS Settings)
    log "Exporting System Preferences shortcuts..."
    {
        echo '  "com.apple.systempreferences": {'
        defaults read com.apple.systempreferences 2>/dev/null | grep -E "^\s+\".*\" = " | sed 's/^[[:space:]]*//' | head -10 || true
        echo '  }'
    } >> "$temp_file"
    
    echo "}" >> "$temp_file"
    
    # Format with jq if available, otherwise just copy
    if command -v jq &> /dev/null; then
        log "Formatting JSON..."
        jq . "$temp_file" > "$OUTPUT_FILE" 2>/dev/null || cp "$temp_file" "$OUTPUT_FILE"
    else
        cp "$temp_file" "$OUTPUT_FILE"
    fi
    
    rm -f "$temp_file"
    success "Keyboard shortcuts exported to $OUTPUT_FILE"
}

export_defaults_comprehensive() {
    log "Performing comprehensive defaults export..."
    
    # Create a more comprehensive export using all defaults domains
    local temp_file="/tmp/shortcuts_comprehensive.json"
    
    echo "{" > "$temp_file"
    echo '  "keyboard_shortcuts": {' >> "$temp_file"
    
    # First, try to export symbolic hotkeys (system-wide keyboard shortcuts)
    log "Exporting system symbolic hotkeys..."
    local symbolic_hotkeys=$(defaults export com.apple.symbolichotkeys /tmp/symbolic_hotkeys.plist 2>/dev/null && plutil -convert json /tmp/symbolic_hotkeys.plist -o - 2>/dev/null || echo '{}')
    
    if [ "$symbolic_hotkeys" != "{}" ] && [ -n "$symbolic_hotkeys" ]; then
        echo -n '    "com.apple.symbolichotkeys": ' >> "$temp_file"
        echo "$symbolic_hotkeys" >> "$temp_file"
    else
        echo '    "com.apple.symbolichotkeys": {}' >> "$temp_file"
    fi
    
    # Now export Safari preferences directly (includes custom shortcuts)
    log "Exporting Safari preferences (including custom shortcuts)..."
    local safari_prefs="$HOME/Library/Preferences/com.apple.Safari.plist"
    if [ -f "$safari_prefs" ]; then
        echo "," >> "$temp_file"
        local safari_json=$(plutil -convert json "$safari_prefs" -o - 2>/dev/null)
        if [ -n "$safari_json" ] && [ "$safari_json" != "{}" ]; then
            echo -n '    "com.apple.Safari": ' >> "$temp_file"
            echo "$safari_json" >> "$temp_file"
        else
            echo '    "com.apple.Safari": {}' >> "$temp_file"
        fi
    else
        echo "," >> "$temp_file"
        echo '    "com.apple.Safari": {}' >> "$temp_file"
    fi
    
    # Export other important app preferences that store shortcuts
    local app_prefs=("com.google.Chrome" "com.microsoft.VSCode" "com.iterm2" "com.jetbrains.intellij" "com.apple.Mail" "com.apple.finder")
    local first=false
    
    for app_domain in "${app_prefs[@]}"; do
        local app_plist="$HOME/Library/Preferences/${app_domain}.plist"
        if [ -f "$app_plist" ]; then
            log "Exporting preferences for: $app_domain"
            echo "," >> "$temp_file"
            echo -n "    \"$app_domain\": " >> "$temp_file"
            plutil -convert json "$app_plist" -o - 2>/dev/null | python3 -m json.tool 2>/dev/null || echo '{}' >> "$temp_file"
            first=true
        fi
    done
    
    # Also export system-wide defaults for any domain with keyboard settings
    log "Discovering all preference domains with keyboard settings..."
    local all_domains=$(defaults domains 2>/dev/null | tr ',' '\n' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    
    while IFS= read -r domain; do
        # Skip empty lines, already processed domains, and system domains
        if [[ -z "$domain" ]] || [[ "$domain" == "Apple Global Domain" ]] || [[ "$domain" == "com.apple.symbolichotkeys" ]] || [[ "$domain" == "com.apple.Safari" ]]; then
            continue
        fi
        
        # Read the domain
        local domain_data=$(defaults read "$domain" 2>/dev/null || echo '{}')
        
        # Check if domain contains keyboard-related keys
        if echo "$domain_data" | grep -qiE '(NSUserKeyEquivalents|key|shortcut|keybind|bind|command|cmd|hotkey|accelerator)'; then
            log "Exporting keyboard settings from domain: $domain"
            echo "," >> "$temp_file"
            echo -n "    \"$domain\": " >> "$temp_file"
            echo "$domain_data" | python3 -m json.tool 2>/dev/null || echo '{}' >> "$temp_file"
        fi
    done <<< "$all_domains"
    
    echo "" >> "$temp_file"
    echo "  }" >> "$temp_file"
    echo "}" >> "$temp_file"
    
    # Try to format with jq
    if command -v jq &> /dev/null; then
        jq . "$temp_file" > "$OUTPUT_FILE" 2>/dev/null || mv "$temp_file" "$OUTPUT_FILE"
    else
        mv "$temp_file" "$OUTPUT_FILE"
    fi
    
    # Cleanup
    rm -f /tmp/symbolic_hotkeys.plist
    
    success "Comprehensive shortcuts exported to $OUTPUT_FILE"
}

main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║      Keyboard Shortcuts Export Utility                 ║"
    echo "║      macOS System Preferences                          ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    
    export_defaults_comprehensive
    
    echo ""
    log "Next steps:"
    echo "1. Review the exported shortcuts: cat $OUTPUT_FILE"
    echo "2. Manually edit if needed"
    echo "3. Commit to git: git add system/keyboard-shortcuts.json"
    echo "4. On new machines, run: ./scripts/install.sh"
    echo ""
    success "Export complete!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
