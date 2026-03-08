#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Summarize Screen with AI
# @raycast.mode fullOutput
# @raycast.packageName Screen Tools

# Optional parameters:
# @raycast.icon 🤖
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Captures screen, extracts text, and summarizes with AI
# @raycast.author Your Name

# Check dependencies
if ! command -v tesseract &> /dev/null; then
    echo "❌ Error: tesseract is not installed"
    echo "Install it with: brew install tesseract"
    exit 1
fi

echo "📸 Capturing screenshot..."

# Create temp files
TEMP_DIR=$(mktemp -d)
SCREENSHOT="$TEMP_DIR/screenshot.png"
TEXT_FILE="$TEMP_DIR/text.txt"

# Capture screenshot of frontmost window
screencapture -o -w "$SCREENSHOT" 2>/dev/null

# If window capture failed, try entire screen
if [ ! -f "$SCREENSHOT" ] || [ ! -s "$SCREENSHOT" ]; then
    echo "⚠️  Window capture failed, capturing entire screen..."
    screencapture -o "$SCREENSHOT"
fi

echo "🔍 Extracting text with OCR..."

# OCR
tesseract "$SCREENSHOT" "$TEMP_DIR/text" --psm 3 2>/dev/null

# Read text
if [ -f "$TEXT_FILE" ]; then
    EXTRACTED_TEXT=$(cat "$TEXT_FILE")
else
    echo "❌ Error: Could not extract text"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"

# Check if text is empty
if [ -z "$EXTRACTED_TEXT" ] || [ "${#EXTRACTED_TEXT}" -lt 10 ]; then
    echo "❌ No meaningful text found in the screenshot"
    echo "The window might contain mostly images or graphics."
    exit 1
fi

echo "✅ Text extracted successfully!"
echo ""
echo "📝 Extracted content:"
echo "---"
echo "$EXTRACTED_TEXT"
echo "---"
echo ""
echo "🤖 Generating summary with AI..."
echo ""

# Create a prompt for summarization
PROMPT="Please provide a concise summary of the following screen content:

$EXTRACTED_TEXT"

# Save to clipboard for easy access
echo "$PROMPT" | pbcopy

echo "✅ Content copied to clipboard!"
echo ""
echo "Now opening Raycast AI..."

# Open Raycast AI Chat
open "raycast://extensions/raycast/raycast-ai/ai-chat"

# Wait a moment then paste
sleep 1
osascript -e 'tell application "System Events" to keystroke "v" using command down'