# VS Code Configuration

User-level VS Code settings, symlinked into place by `install.sh`.

## File Structure

- **`settings.json`** - editor/workbench settings: the greyscale UI chrome
  (`workbench.colorCustomizations`, matching the grey ramp in
  [neovim/theme/palette.lua](../../neovim/theme/palette.lua)), the terminal
  font (`FiraCode Nerd Font`, for file icons in nvim), Cmd+Enter-to-send
  for Claude Code chat, and Option-as-meta in the terminal (Option+Enter
  submits in the Claude Code CLI, matching iTerm2's Esc+ profile)

- **`keybindings.json`** - Cmd+Enter in the integrated terminal sends
  ESC+CR (meta+enter), submitting in the Claude Code CLI — same key as
  the chat panel (iTerm2 has the matching mapping in its profile)

## How It Works

`install.sh` symlinks both files into
`~/Library/Application Support/Code/User/`, so edits made in the
editor's settings UI write straight back into this repo — commit
them like any other change.

Extensions are tracked in **`extensions.txt`** — `install.sh` installs
the list (idempotent; already-installed ones are skipped, unavailable
ones warn and skip). GitHub Copilot is deliberately not listed: it
ships built into VS Code itself, no extension install needed. To
capture newly installed extensions: `code --list-extensions` and
update the file.
