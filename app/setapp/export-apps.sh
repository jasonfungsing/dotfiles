#!/usr/bin/env bash
#
# export-apps.sh — regenerate apps.txt from the Setapp apps currently
# installed under /Applications/Setapp. Run after installing or removing
# Setapp apps, then commit the diff (same workflow as
# mac/export-shortcuts.sh for keyboard shortcuts).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/apps.txt"
SETAPP_DIR="/Applications/Setapp"

if [ ! -d "$SETAPP_DIR" ]; then
    echo "✗ $SETAPP_DIR not found — is Setapp installed and signed in?" >&2
    exit 1
fi

{
    cat <<'HEADER'
# Setapp apps installed on this machine — one name per line (the .app
# name under /Applications/Setapp, without the extension). Setapp ships
# no CLI or install API, so these can't be auto-installed: on a new
# machine install.sh prints which ones are missing and opens Setapp so
# the remaining clicks happen right away (sign in first). Regenerate
# this list after adding/removing Setapp apps: app/setapp/export-apps.sh
HEADER
    find "$SETAPP_DIR" -maxdepth 1 -name "*.app" -exec basename {} .app \; | sort
} > "$OUTPUT_FILE"

echo "✓ Exported $(grep -c -v '^#' "$OUTPUT_FILE") Setapp apps to $OUTPUT_FILE"
