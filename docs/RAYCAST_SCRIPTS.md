# Raycast Scripts Documentation

Guide to custom Raycast scripts included in the dotfiles repository.

## Overview

Raycast is a macOS productivity tool that lets you control your Mac with a few keystrokes. The dotfiles repository includes custom scripts that extend Raycast's functionality for specific tasks.

## Available Scripts

### 1. Summarize Screen

**File:** `raycast-scripts/summarize-screen.sh`

**Purpose:** Capture and summarise the current screen content

**Features:**
- Captures screenshot of current screen
- Processes image (if needed)
- Displays summary of visible content
- Useful for quick notes or documentation

**Usage:**
1. Open Raycast: `Cmd+Space`
2. Type: `Summarize Screen`
3. Select the script
4. View summary output

### 2. Summarize Screen with AI

**File:** `raycast-scripts/summarize-screen-ai.sh`

**Purpose:** Use AI to intelligently summarise screen content

**Features:**
- Captures screenshot
- Sends to AI service for intelligent summarisation
- Provides detailed analysis of screen content
- Better for complex information extraction

**Requirements:**
- API key configured (see setup below)
- Internet connection
- API service access

**Usage:**
1. Open Raycast: `Cmd+Space`
2. Type: `Summarize Screen AI`
3. Select the script
4. Wait for AI processing
5. View AI-generated summary

## Installation

### Automatic Installation

Scripts are installed during dotfiles setup:

```bash
./scripts/install.sh
```

### Manual Installation

1. Copy scripts to Raycast directory:
```bash
mkdir -p ~/Library/Application\ Support/Raycast/Extensions/scripts
cp raycast-scripts/*.sh ~/Library/Application\ Support/Raycast/Extensions/scripts/
```

2. Make executable:
```bash
chmod +x ~/Library/Application\ Support/Raycast/Extensions/scripts/*.sh
```

3. Restart Raycast

## Configuration

### API Key Setup (for AI features)

To enable AI summarisation:

1. Get API key from your AI provider:
   - OpenAI (ChatGPT): https://platform.openai.com/api-keys
   - Anthropic (Claude): https://console.anthropic.com/
   - Other providers as configured

2. Add to shell configuration:
```bash
# ~/.zshrc.private (private file, not tracked by git)
export OPENAI_API_KEY="sk-..."
# or
export ANTHROPIC_API_KEY="sk-ant-..."
```

3. Reload shell:
```bash
source ~/.zshrc
```

## Customisation

### Modifying Scripts

Scripts are plain shell scripts that can be customised:

1. Edit script: `raycast-scripts/summarize-screen.sh`
2. Test locally: `bash raycast-scripts/summarize-screen.sh`
3. Commit changes: `git add raycast-scripts/summarize-screen.sh`

### Adding New Scripts

1. Create new script:
```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title My Custom Script
# @raycast.description Does something useful
# @raycast.author Your Name

# Your script code here
echo "Script output"
```

2. Make executable:
```bash
chmod +x raycast-scripts/my-script.sh
```

3. Copy to Raycast:
```bash
cp raycast-scripts/my-script.sh ~/Library/Application\ Support/Raycast/Extensions/scripts/
```

4. Restart Raycast and test

## Script Metadata

Raycast scripts use special metadata comments:

```bash
#!/bin/bash
# @raycast.schemaVersion 1           # Script format version
# @raycast.title Title               # Display name
# @raycast.description Description   # Short description
# @raycast.author Author Name        # Script author
# @raycast.authorURL URL             # Author website
# @raycast.packageName package-name  # Package identifier
# @raycast.mode silent               # Display mode
# @raycast.argument string           # Command arguments
```

### Display Modes

- `silent` - No output window shown
- `compact` - Compact results format
- `fullOutput` - Full text output
- `inline` - Inline results in search

## Usage Examples

### Screenshot Analysis

```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Analyze Screenshot
# @raycast.description Analyze the current screen

# Take screenshot
screencapture -i ~/tmp/screenshot.png

# Display result
echo "Screenshot saved to ~/tmp/screenshot.png"
```

### System Information

```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title System Stats
# @raycast.description Show system information

# Display system info
system_profiler SPSoftwareDataType
```

### Development Commands

```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Git Status
# @raycast.description Show git status of projects

# Show git status
git status --short
```

## Troubleshooting

### Script Not Appearing

1. Check script location:
```bash
ls -la ~/Library/Application\ Support/Raycast/Extensions/scripts/
```

2. Verify executable:
```bash
chmod +x ~/Library/Application\ Support/Raycast/Extensions/scripts/script-name.sh
```

3. Restart Raycast: `Cmd+Q` and reopen

### Script Errors

Check script output:

```bash
# Run directly
bash ~/Library/Application\ Support/Raycast/Extensions/scripts/script-name.sh
```

Look for error messages and fix issues.

### API Issues

For AI-powered scripts:

1. Verify API key is set:
```bash
echo $OPENAI_API_KEY
```

2. Check API service status
3. Verify API quota/credits
4. Test API directly:
```bash
curl -H "Authorization: Bearer $OPENAI_API_KEY" \
     https://api.openai.com/v1/models
```

## Advanced Features

### Arguments & Parameters

```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Calculator
# @raycast.argument1 { "type": "text", "placeholder": "Enter expression" }

result=$(echo "scale=2; $1" | bc)
echo "Result: $result"
```

### Environment Variables

Access within scripts:

```bash
# Shell environment
echo $HOME      # Home directory
echo $USER      # Current user
echo $PWD       # Current directory

# Raycast-provided
echo $RAYCAST_ROOT   # Raycast root directory
```

### Error Handling

```bash
#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable

# Your code
if ! command -v jq &> /dev/null; then
    echo "Error: jq not installed"
    exit 1
fi
```

## Performance Tips

1. **Cache results** - Store results to avoid recomputation
2. **Async operations** - Use background processes for long tasks
3. **Minimal output** - Keep output concise
4. **Error messages** - Provide clear error feedback

## Resources

- [Raycast Documentation](https://manual.raycast.com/)
- [Script Commands](https://manual.raycast.com/script-commands)
- [Script Examples](https://github.com/raycast/script-commands)
- [API Documentation](https://manual.raycast.com/data-api)

## Sharing Scripts

To share scripts with others:

1. Publish to GitHub
2. Follow Raycast naming conventions
3. Include metadata comments
4. Add README with examples
5. Submit to [Raycast Scripts](https://github.com/raycast/script-commands)

## Example: Weather Script

```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Weather
# @raycast.description Show current weather
# @raycast.argument1 { "type": "text", "placeholder": "City name" }

curl -s "https://wttr.in/$1?format=3"
```

Usage: `Weather London`

Output: `London: 🌤️  +12°C`

## Tips & Best Practices

1. **Use comments** - Document script purpose and usage
2. **Test thoroughly** - Run scripts manually before using
3. **Handle errors** - Add error checking and user feedback
4. **Keep it simple** - Single responsibility per script
5. **Version control** - Track all scripts in dotfiles

## Updating Scripts

Update your local scripts:

```bash
# Pull latest from repository
cd ~/.dotfiles
git pull origin main

# Copy to Raycast
cp raycast-scripts/*.sh ~/Library/Application\ Support/Raycast/Extensions/scripts/

# Restart Raycast
killall Raycast
open -a Raycast
```

## Backup & Recovery

Backup your custom scripts:

```bash
# Backup to dotfiles
cp -r ~/Library/Application\ Support/Raycast/Extensions/scripts ~/.dotfiles/raycast-scripts-backup

# Commit to git
git add raycast-scripts-backup/
git commit -m "chore: backup raycast scripts"
```

Restore from backup:

```bash
cp ~/.dotfiles/raycast-scripts-backup/* ~/Library/Application\ Support/Raycast/Extensions/scripts/
```
