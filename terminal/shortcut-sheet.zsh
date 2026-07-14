# shortcut-sheet.zsh — dynamic shortcut sheet on Ctrl+/ or F1
# Sourced by zshrc (section 7). Managed in the dotfiles repo
# (terminal/shortcut-sheet.zsh, symlinked to ~/.shortcut-sheet.zsh).
#
# A searchable fzf palette of the CURRENT shell's aliases, functions and
# key bindings — plus the tmux bindings when inside tmux — generated live,
# so it can never go stale. Enter runs a tmux/zsh line, or puts an
# alias/function on the prompt. Requires fzf; tmux sections appear only
# inside tmux.

shortcut-sheet() {
  local sel
  sel=$({
    if [ -n "$TMUX" ]; then
      echo "═══ tmux (C-f = prefix) ═══"
      # Raw bindings merged with their -N notes, shown as [description]
      {
        tmux list-keys -N -T prefix 2>/dev/null
        echo "@@ALLNOTES@@"
        tmux list-keys -N 2>/dev/null
        echo "@@PREFIX@@"
        tmux list-keys -T prefix 2>/dev/null
        echo "@@ROOT@@"
        tmux list-keys -T root 2>/dev/null | grep -viE "mouse|click|wheel|scrollbar"
        echo "@@COPY@@"
        tmux list-keys -T copy-mode-vi 2>/dev/null | grep -viE "mouse|click|wheel|scrollbar"
      } | awk '
        function lk(s) { gsub(/\\/, "", s); return s }
        /^@@ALLNOTES@@$/ { sec=1; next }
        /^@@PREFIX@@$/   { sec=2; next }
        /^@@ROOT@@$/     { sec=3; next }
        /^@@COPY@@$/     { sec=4; next }
        sec==0 { k=lk($2); $1=""; $2=""; sub(/^ +/, ""); pn[k]=$0; next }
        sec==1 {
          # combined view is the only place root-table notes appear (shown
          # with a bogus prefix column); keep those not already in pn
          k=lk($2); if (!(k in pn)) { $1=""; $2=""; sub(/^ +/, ""); rn[k]=$0 }
          next
        }
        sec==2 {
          sub(/^bind-key +(-r +)?-T prefix +/, "")
          k=$1; key=lk(k); sub(/^\\/, "", k)
          cmd=$0; sub(/^[^ ]+ +/, "", cmd)
          note=(key in pn ? "[" pn[key] "]" : "")
          printf "tmux   %-12s %-48s %s\n", "C-f " k, note, cmd
          next
        }
        sec==3 {
          sub(/^bind-key +(-n +)?-T root +/, "")
          k=$1; key=lk(k); sub(/^\\/, "", k)
          cmd=$0; sub(/^[^ ]+ +/, "", cmd)
          note=(key in rn ? "[" rn[key] "]" : "")
          printf "tmux   %-12s %-48s %s\n", k, note, cmd
          next
        }
        sec==4 {
          sub(/^bind-key +-T copy-mode-vi +/, "")
          k=$1; sub(/^\\/, "", k)
          cmd=$0; sub(/^[^ ]+ +/, "", cmd)
          printf "tmux   %-12s %-48s %s\n", "copy " k, "", cmd
          next
        }'
      echo ""
    fi
    echo "═══ Aliases (alias → what it runs) ═══"
    alias | sort | awk '{
      i = index($0, "=")
      name = substr($0, 1, i - 1); val = substr($0, i + 1)
      q = sprintf("%c", 39)  # single quote
      if (substr(val, 1, 1) == q && substr(val, length(val), 1) == q)
        val = substr(val, 2, length(val) - 2)
      printf "alias  %-16s %s\n", name, val
    }'
    echo ""
    echo "═══ Functions ═══"
    # Third column: curated description for our own functions, otherwise
    # the function's origin (whence -v) — live truth, no drift
    local f src fdesc
    for f in ${(ko)functions}; do
      [[ "$f" == _* ]] && continue
      fdesc=""
      case "$f" in
        shortcut-sheet)         fdesc="THIS sheet" ;;
        islidclosed)            fdesc="print Yes/No — is the MacBook lid closed" ;;
        sleepstatus)            fdesc="report whether sleep is currently disabled" ;;
        check-alias-and-accept) fdesc="Enter-key widget: suggests the alias if one exists" ;;
        fuck)                   fdesc="correct the previous command (thefuck)" ;;
        nvm)                    fdesc="Node version manager" ;;
        *)
          src=$(whence -v -- "$f" 2>/dev/null)
          case "$src" in
            *oh-my-zsh/plugins/*) fdesc="from omz plugin: ${${src##*oh-my-zsh/plugins/}%%/*}" ;;
            *oh-my-zsh/*)         fdesc="from oh-my-zsh core" ;;
            *cobalt2*)            fdesc="from the cobalt2 theme" ;;
            *autojump*)           fdesc="from autojump" ;;
            *fzf*)                fdesc="from fzf" ;;
            *nvm*)                fdesc="from nvm" ;;
            *iterm2*)             fdesc="from iTerm2 shell integration" ;;
            *"shell function from"*) fdesc="from ${${src##*shell function from }/#$HOME/~}" ;;
          esac
          ;;
      esac
      printf "func   %-24s %s\n" "$f" "$fdesc"
    done
    echo ""
    echo "═══ Key bindings (^=Ctrl, ^[=Option/Esc) ═══"
    bindkey | grep -v self-insert | awk '
      BEGIN {
        d["shortcut-sheet"]="THIS sheet"
        d["accept-line"]="run the command"
        d["check-alias-and-accept"]="run command, but suggest the alias if one exists"
        d["fzf-history-widget"]="fuzzy-search command history"
        d["fzf-file-widget"]="fuzzy-find file, insert path"
        d["fzf-cd-widget"]="fuzzy-pick directory and cd"
        d["fzf-completion"]="complete (fzf-aware)"
        d["beginning-of-line"]="go to start of line"
        d["end-of-line"]="go to end of line"
        d["backward-char"]="move left one char"
        d["forward-char"]="move right one char"
        d["backward-word"]="move back one word"
        d["forward-word"]="move forward one word"
        d["backward-delete-char"]="delete char before cursor"
        d["delete-char-or-list"]="delete char / list completions"
        d["backward-kill-word"]="delete word before cursor"
        d["kill-word"]="delete word after cursor"
        d["kill-line"]="delete to end of line"
        d["kill-whole-line"]="delete the whole line"
        d["kill-buffer"]="delete everything typed"
        d["yank"]="paste last deleted text"
        d["yank-pop"]="cycle older deleted text after paste"
        d["undo"]="undo last edit"
        d["transpose-chars"]="swap the two chars around cursor"
        d["transpose-words"]="swap the two words around cursor"
        d["up-case-word"]="UPPERCASE word"
        d["down-case-word"]="lowercase word"
        d["capitalize-word"]="Capitalise word"
        d["clear-screen"]="clear the screen"
        d["history-incremental-search-backward"]="search history as you type (older)"
        d["history-incremental-search-forward"]="search history as you type (newer)"
        d["up-line-or-beginning-search"]="previous history entry matching typed prefix"
        d["down-line-or-beginning-search"]="next history entry matching typed prefix"
        d["history-search-backward"]="previous command with same first word"
        d["history-search-forward"]="next command with same first word"
        d["insert-last-word"]="insert last argument of previous command"
        d["magic-space"]="space, expanding !! style history refs"
        d["expand-history"]="expand !! style history refs"
        d["push-line"]="stash line, restore after next command"
        d["accept-and-hold"]="run line but keep it on the prompt"
        d["accept-line-and-down-history"]="run line, queue next from history"
        d["run-help"]="open man page for current command"
        d["which-command"]="describe the command"
        d["quoted-insert"]="insert next keypress literally"
        d["exchange-point-and-mark"]="jump between cursor and mark"
        d["set-mark-command"]="set mark at cursor"
        d["copy-prev-shell-word"]="duplicate previous word"
        d["reverse-menu-complete"]="cycle completion menu backwards"
        d["bracketed-paste"]="paste"
        d["edit-command-line"]="edit the command line in nvim"
      }
      {
        key=$1; gsub(/^"|"$/, "", key)
        w=$2
        printf "zsh    %-16s %-44s %s\n", key, w, (w in d ? d[w] : "")
      }'
  } | fzf --exact --reverse --no-sort --prompt="shortcuts> " \
        --bind "tab:down,btab:up,ctrl-j:ignore,ctrl-k:ignore" \
        --header="Enter: tmux/zsh line → run | alias/func → to prompt | move: Tab / Shift + Tab")

  case "$sel" in
    alias*) LBUFFER="${${(z)sel}[2]}" ;;
    func*)  LBUFFER="${${(z)sel}[2]}" ;;
    "tmux   copy "*) ;;  # copy-mode commands need copy-mode context — view only
    tmux*)
      # Columns: tag | key | [description] | command — strip the first
      # three; the remainder is valid tmux command syntax by design
      local cmd
      cmd=$(print -r -- "$sel" | sed -E 's/^tmux +(C-f +)?[^ ]+ +(\[[^]]*\] +)?//')
      [ -n "$cmd" ] && eval "command tmux $cmd" > /dev/null 2>&1
      ;;
    zsh*)
      # ZLE widgets act on the prompt itself — invoke the selected one
      # right here (string macros, a quoted 3rd column, are skipped)
      local w="${${(z)sel}[3]}"
      if [[ -n "$w" && "$w" != \"* ]]; then
        zle reset-prompt
        zle "$w" 2> /dev/null
        return
      fi
      ;;
  esac
  zle reset-prompt
}
zle -N shortcut-sheet
bindkey "^_" shortcut-sheet      # Ctrl+/ (terminals send ^_ for it)
bindkey "^[OP" shortcut-sheet    # F1 (application mode)
bindkey "^[[11~" shortcut-sheet  # F1 (some terminals)
