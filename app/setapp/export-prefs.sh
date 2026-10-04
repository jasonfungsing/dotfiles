#!/usr/bin/env bash
#
# export-prefs.sh — export each Setapp app's preference domain to
# prefs/<domain>.plist (XML, so diffs are readable). Run after changing
# an app's settings, review the git diff, commit. install.sh imports
# these on a machine where the domain doesn't exist yet (fresh install),
# and never overwrites a machine's existing settings.
#
# Adding an app: find its domain with `defaults domains | tr ',' '\n' |
# grep -i <app>` and append it to DOMAINS. Keep secrets out: check new
# domains for token/password keys before committing (app logins live in
# the macOS Keychain, not here, so these plists are normally safe).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFS_DIR="$SCRIPT_DIR/prefs"
mkdir -p "$PREFS_DIR"

DOMAINS=(
    "com.getcleanshot.app-setapp"           # CleanShot X (hotkeys, save location, formats)
    "com.macpaw.CleanMyMac-setapp"          # CleanMyMac
    "com.macpaw.CleanMyMac-setapp.Menu"     # CleanMyMac menu-bar widget
)

# Keys stripped from every export: app STATE, not settings — they churn
# on every use, and CleanShot's mediaHistory embeds capture filenames
# and window titles (personal data that must never land in this repo).
STRIP_KEYS=(
    "mediaHistory"
    "lastOneOverlayArea"
)

for domain in "${DOMAINS[@]}"; do
    out="$PREFS_DIR/$domain.plist"
    if ! defaults export "$domain" "$out" 2>/dev/null; then
        echo "⚠ Skipped $domain (domain not found — app never launched here?)" >&2
        continue
    fi
    plutil -convert xml1 "$out"
    for key in "${STRIP_KEYS[@]}"; do
        plutil -remove "$key" "$out" > /dev/null 2>&1 || true
    done
    echo "✓ Exported $domain"
done
