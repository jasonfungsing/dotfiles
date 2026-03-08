#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Summarize Current Screen
# @raycast.mode fullOutput
# @raycast.packageName Screen Tools

# Optional parameters:
# @raycast.icon 📄
# @raycast.argument1 { "type": "text", "placeholder": "Focus area (optional)", "optional": true }

# Documentation:
# @raycast.description Takes a screenshot of the frontmost window, extracts text, and summarizes it
# @raycast.author Your Name
# @raycast.authorURL https://raycast.com

# Dependencies: tesseract (for OCR)

# Check if tesseract is installed
if ! command -v tesseract &> /dev/null; then
    echo "Error: tesseract is not installed"
    echo "Install it with: brew install tesseract"
    exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
SCREENSHOT="$TEMP_DIR/screenshot.png"
TEXT_FILE="$TEMP_DIR/text.txt"

# Take screenshot of frontmost window
screencapture -o -w "$SCREENSHOT" 2>/dev/null

# If window capture failed, capture entire screen
if [ ! -f "$SCREENSHOT" ]; then
    screencapture -o "$SCREENSHOT"
fi

# Extract text using OCR
tesseract "$SCREENSHOT" "$TEMP_DIR/text" 2>/dev/null

# Check if text was extracted
if [ ! -f "$TEXT_FILE" ]; then
    echo "Error: Could not extract text from screenshot"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Read extracted text
EXTRACTED_TEXT=$(cat "$TEXT_FILE")

# Check if text is empty
if [ -z "$EXTRACTED_TEXT" ]; then
    echo "No text found in the screenshot"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Display extracted text and summary prompt
echo "📸 Screenshot captured and text extracted"
echo ""
echo "Extracted text:"
echo "---"
echo "$EXTRACTED_TEXT"
echo "---"
echo ""
echo "💡 Now use Raycast AI to summarize this text"

# Clean up
rm -rf "$TEMP_DIR"
