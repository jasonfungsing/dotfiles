#!/bin/bash
# Claude Code status line.
#
# Recreates two segments from the cobalt2 zsh prompt (~/.zshrc:
# prompt_dir / prompt_git) in the same greyscale scheme, plus Claude
# session info the shell prompt has no equivalent for (model name,
# context-window usage). The shared grey ramp (dir bg 239, git bg 246,
# text 250/235) is documented in neovim/theme/palette.lua and used
# across zsh/tmux/git/fzf.
#
# Git commands use --no-optional-locks so the status line never blocks
# on, or interferes with, a concurrent git operation in the shell.

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(printf '%s' "$input" | jq -r '.model.display_name')
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

# --- Directory segment: last 3 path components, like the prompt's %3~ ---
display_path="$cwd"
case "$display_path" in
  "$HOME") display_path="~" ;;
  "$HOME"/*) display_path="~${display_path#"$HOME"}" ;;
esac
dir_display=$(printf '%s' "$display_path" | awk -F/ '{
  n = NF; count = (n < 3) ? n : 3
  out = ""
  for (i = n - count + 1; i <= n; i++) { out = out (out == "" ? "" : "/") $i }
  print out
}')
[ -z "$dir_display" ] && dir_display="$display_path"

# --- Git segment: branch (or short SHA) + branch glyph + ± dirty marker ---
git_text=""
if git --no-optional-locks -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ref=$(git --no-optional-locks -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
  [ -z "$ref" ] && ref="➦ $(git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)"
  dirty=""
  if ! git --no-optional-locks -C "$cwd" diff --quiet --ignore-submodules -- 2>/dev/null \
     || ! git --no-optional-locks -C "$cwd" diff --cached --quiet --ignore-submodules -- 2>/dev/null \
     || [ -n "$(git --no-optional-locks -C "$cwd" ls-files --others --exclude-standard 2>/dev/null)" ]; then
    dirty="±"
  fi
  git_text=" ${ref}${dirty}"
fi

# --- Colors (256-palette; matches ~/.zshrc's prompt_dir/prompt_git) ---
RESET=$'\033[0m'
DIR_BG=$'\033[48;5;239m'; DIR_FG=$'\033[38;5;250m'
GIT_BG=$'\033[48;5;246m'; GIT_FG=$'\033[38;5;235m'
ARROW=''

out="${DIR_BG}${DIR_FG} ${dir_display} "
if [ -n "$git_text" ]; then
  out="${out}"$'\033[38;5;239m'"${GIT_BG}${ARROW}${GIT_FG}${git_text} "
  out="${out}"$'\033[38;5;246m\033[49m'"${ARROW}${RESET}"
else
  out="${out}"$'\033[38;5;239m\033[49m'"${ARROW}${RESET}"
fi

# --- Claude session info: model + context usage (no shell-prompt equivalent) ---
info=$'\033[38;5;243m'" ${model}"
if [ -n "$used_pct" ]; then
  info="${info} · ctx $(printf '%.0f' "$used_pct")%"
fi
info="${info}${RESET}"

printf '%s%s\n' "$out" "$info"
