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

# Resolve the absolute plist file path for a domain
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

export_defaults_comprehensive() {
    log "Performing comprehensive defaults export..."
    
    local temp_file="/tmp/shortcuts_comprehensive.json"
    
    echo "{" > "$temp_file"
    echo '  "keyboard_shortcuts": {' >> "$temp_file"
    
    # 1. Discover all domains with custom app shortcuts (NSUserKeyEquivalents)
    log "Discovering domains with custom app shortcuts..."
    local domains
    domains=$(defaults find NSUserKeyEquivalents 2>/dev/null | grep "Found " | sed -E "s/.*domain '(.*)'.*/\1/" | sort -u)
    
    # Also explicitly add standard domains to check
    local domains_to_check=("com.apple.symbolichotkeys" "NSGlobalDomain")
    for d in $domains; do
        if [ "$d" != "com.apple.symbolichotkeys" ] && [ "$d" != "NSGlobalDomain" ]; then
            domains_to_check+=("$d")
        fi
    done
    
    local first=true
    for domain in "${domains_to_check[@]}"; do
        local plist_path
        plist_path=$(get_plist_path "$domain")
        
        if [ -z "$plist_path" ] || [ ! -f "$plist_path" ]; then
            continue
        fi
        
        local dict_json=""
        if [ "$domain" = "com.apple.symbolichotkeys" ]; then
            dict_json=$(plutil -convert json "$plist_path" -o - 2>/dev/null | jq '.AppleSymbolicHotKeys // empty')
        else
            dict_json=$(plutil -convert json "$plist_path" -o - 2>/dev/null | jq '.NSUserKeyEquivalents // empty')
        fi
        
        # Only output if we successfully extracted a non-empty, non-trivial object
        if [ -n "$dict_json" ] && [ "$dict_json" != "{}" ] && [ "$dict_json" != "null" ]; then
            log "Exporting shortcuts for: $domain"
            
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$temp_file"
            fi
            
            if [ "$domain" = "com.apple.symbolichotkeys" ]; then
                echo "    \"$domain\": {" >> "$temp_file"
                echo "      \"AppleSymbolicHotKeys\": $dict_json" >> "$temp_file"
                echo "    }" >> "$temp_file"
            else
                echo "    \"$domain\": {" >> "$temp_file"
                echo "      \"NSUserKeyEquivalents\": $dict_json" >> "$temp_file"
                echo "    }" >> "$temp_file"
            fi
        fi
    done
    
    echo "" >> "$temp_file"
    echo "  }" >> "$temp_file"
    echo "}" >> "$temp_file"
    
    # Format with jq
    if command -v jq &> /dev/null; then
        jq . "$temp_file" > "$OUTPUT_FILE" 2>/dev/null || mv "$temp_file" "$OUTPUT_FILE"
    else
        mv "$temp_file" "$OUTPUT_FILE"
    fi
    
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
    echo "4. On new machines, run: ./install.sh"
    echo ""
    success "Export complete!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
