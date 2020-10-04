# Load private config files
if [ -f ~/.zshrc.private ]; then
  source ~/.zshrc.private
fi

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cobalt2"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

ZSH_DISABLE_COMPFIX=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux brew npm osx aws github gitignore golang mvn python scala sublime xcode z tmuxinator vi-mode kubectl zsh-syntax-highlighting zsh-autosuggestions autojump)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

fpath=(/usr/local/share/zsh-completions $fpath)

eval "$(direnv hook zsh)"
eval "$(thefuck --alias)"

alias t='tmux'
alias mux="tmuxinator"
alias ekc="osascript -l JavaScript -e 'Application(\"KeyCast\").enabled = true;'"
alias dkc="osascript -l JavaScript -e 'Application(\"KeyCast\").enabled = false;'"
alias gpa="find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;"
alias update="brew update && brew upgrade && brew cleanup && brew upgrade --cask && omz update"
alias n="npm"
alias y="yarn"
alias v="vim"
alias weather='f() { curl wttr.in/$1. };f'

prompt_context() {
  prompt_segment white black "%(!.%{%F{yellow}%}.)$DEFAULT_USER"
}

export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Python 3 as default
alias python=python3

export EDITOR='vim'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jasonfungsing/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/jasonfungsing/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jasonfungsing/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/jasonfungsing/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Auto complete for kubernetes
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

export PATH="/usr/local/opt/texinfo/bin:$PATH"
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# SDKMAN - THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/jasonfeng/.sdkman"
[[ -s "/Users/jasonfeng/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jasonfeng/.sdkman/bin/sdkman-init.sh"

[ -s "/Users/jasonfungsing/.jabba/jabba.sh" ] && source "/Users/jasonfungsing/.jabba/jabba.sh"
export PATH="/usr/local/opt/helm@2/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias k=kubectl
complete -F __start_kubectl k
alias awsdigiosandboxadmin='saml2aws login --skip-prompt --profile digio-sandbox-admin --role arn:aws:iam::864141050364:role/Okta-Administrator --session-duration 28800 --password $(security find-generic-password -D "application password" -s "okta-mantel-password" -a "${USER}" -w && export AWS_PROFILE=digio-sandbox-admin'
