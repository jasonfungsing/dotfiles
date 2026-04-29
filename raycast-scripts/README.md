# Raycast Scripts

Custom automation scripts for Raycast productivity launcher.

## File Structure

- **`summarize-screen.sh`** - Summarise visible screen content
- **`summarize-screen-ai.sh`** - AI-powered screen summarisation

## Quick Start

### Installation
```bash
# Raycast automatically discovers scripts in ~/.dotfiles/raycast-scripts/

# Open Raycast preferences:
# Raycast → Settings → Extensions → Script Commands

# Or manually add scripts:
# Settings → Extensions → Script Commands → Add Script Directory
# Point to: ~/.dotfiles/raycast-scripts/
```

### Run Scripts
```bash
# Open Raycast
Cmd + Space

# Type script name
summarize screen

# Select and run
Enter
```

## Scripts Reference

### summarize-screen.sh
**Purpose:** Quick summarisation of visible screen content

**What it does:**
1. Takes screenshot of current screen
2. Extracts visible text
3. Returns summary of content

**Usage:**
```bash
# Open Raycast and search: "summarize screen"
```

**Output:**
- Text summary of visible screen content
- Copyable to clipboard
- Quick reference without manual reading

**Use cases:**
- Quick document overview
- Meeting notes summarisation
- Content verification

---

### summarize-screen-ai.sh
**Purpose:** AI-powered intelligent screen summarisation

**What it does:**
1. Takes screenshot of current screen
2. Sends to AI service (Claude/GPT)
3. Returns intelligent summary with insights

**Usage:**
```bash
# Open Raycast and search: "summarize screen ai"
```

**Requirements:**
- API key configured (Claude/OpenAI)
- Internet connection
- Valid API credits

**Output:**
- Intelligent summary
- Key insights extracted
- Actionable takeaways

**Use cases:**
- Complex document analysis
- Meeting transcription summarisation
- Code review automation
- Email thread summarisation

---

## Configuration

### Set API Keys

For AI summarisation, set environment variables:

```bash
# In ~/.zshrc or ~/.bash_profile
export CLAUDE_API_KEY="your-key-here"
# or
export OPENAI_API_KEY="your-key-here"
```

### Script Parameters

Edit scripts to customise:

```bash
# summarize-screen-ai.sh
MODEL="claude-opus"              # AI model to use
MAX_TOKENS=1000                  # Response length limit
TEMPERATURE=0.7                  # Response creativity
```

## Adding New Scripts

### Create Script
```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title My Custom Script
# @raycast.description Custom automation
# @raycast.author jasonfungsing
# @raycast.authorURL https://github.com/jasonfungsing
# @raycast.mode fullOutput

echo "Script output here"
```

### Script Metadata
```bash
# @raycast.schemaVersion        Version number
# @raycast.title                Display name in Raycast
# @raycast.description          Short description
# @raycast.author               Your name
# @raycast.authorURL            Your GitHub profile
# @raycast.mode                 fullOutput, silent, or compact
# @raycast.icon                 Icon name (SF Symbols)
# @raycast.packages             Dependencies (npm, pip, etc)
# @raycast.needsConfirmation    true/false - confirm before running
# @raycast.argDescription1      Argument 1 description
# @raycast.argDescription2      Argument 2 description
```

### Example: List Top Processes
```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Top Processes
# @raycast.description Show top 5 processes by CPU
# @raycast.author jasonfungsing
# @raycast.mode fullOutput

ps aux | sort -rnk 3,3 | head -6
```

## Troubleshooting

### Scripts not appearing in Raycast
```bash
# Verify directory is set
# Raycast → Settings → Extensions → Script Commands

# Check script permissions
chmod +x raycast-scripts/*.sh

# Verify shebang line exists
head -1 summarize-screen.sh
# Should output: #!/bin/bash

# Restart Raycast
killall Raycast
open -a Raycast
```

### Script execution fails
```bash
# Check script syntax
bash -n summarize-screen.sh

# Run manually to test
bash summarize-screen.sh

# Check for permission errors
ls -la raycast-scripts/

# View Raycast logs
# Raycast → Help → View Logs
```

### AI summarisation not working
```bash
# Verify API key is set
echo $CLAUDE_API_KEY
echo $OPENAI_API_KEY

# Test API connectivity
curl -H "Authorization: Bearer $CLAUDE_API_KEY" \
  https://api.anthropic.com/v1/messages

# Check API credentials
# Visit: https://console.anthropic.com/
# Visit: https://platform.openai.com/account/api-keys
```

### Script runs slowly
```bash
# Profile script execution
time bash summarize-screen.sh

# Check for blocking operations
# Reduce image quality for faster processing
# Reduce token count for faster API response
```

## Advanced Usage

### Chaining Scripts
```bash
# Combine multiple scripts in one
# Script 1: Take screenshot
# Script 2: Summarise
# Script 3: Post to workspace
```

### Parameterised Scripts
```bash
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.argDescription1 Text to process

INPUT="$1"
echo "Processing: $INPUT"
```

### Error Handling
```bash
#!/bin/bash
# @raycast.schemaVersion 1

if ! command -v jq &> /dev/null; then
  echo "Error: jq not installed"
  exit 1
fi
```

### Output Formatting
```bash
#!/bin/bash
# Use markdown for better formatting
echo "# Summary"
echo "- Point 1"
echo "- Point 2"
echo "- Point 3"
```

## Performance Tips

### Optimize Screenshot Processing
```bash
# Use lower resolution
screencapture -x /tmp/screen.png

# Use grayscale for faster processing
# Reduce to specific region only
```

### Cache Results
```bash
# Store summaries for quick access
# Avoid re-processing identical screens
CACHE_DIR="~/.cache/raycast-summaries"
```

### Async Operations
```bash
# For long-running scripts, use background processing
# Return result asynchronously
# Provide progress indication
```

## API Integration

### Using Claude API
```bash
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $CLAUDE_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{...}'
```

### Using OpenAI API
```bash
curl https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{...}'
```

## Documentation

For more information, see:
- **[RAYCAST_SCRIPTS.md](../docs/RAYCAST_SCRIPTS.md)** - Detailed script guide
- **[INSTALLATION.md](../docs/INSTALLATION.md)** - Full dotfiles installation

## See Also

- [Raycast Documentation](https://manual.raycast.com/)
- [Raycast Script Commands](https://manual.raycast.com/script-commands)
- [Raycast Community Scripts](https://github.com/raycast/script-commands)
- [Claude API](https://docs.anthropic.com/)
- [OpenAI API](https://platform.openai.com/docs)
