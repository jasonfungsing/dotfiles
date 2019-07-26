DEFAULT_USER="Jason"

# Load private config files
if [ -f ~/.siteminderrc ]; then
    source ~/.siteminderrc
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
export UPDATE_ZSH_DAYS=1

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-z tmux brew npm osx aws github gitignore golang mvn python scala sublime xcode z tmuxinator)

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

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(direnv hook zsh)"
eval "$(thefuck --alias)"

alias t='tmux'
alias gt='gittower'
alias mux="tmuxinator"
alias ekc="osascript -l JavaScript -e 'Application(\"KeyCast\").enabled = true;'"
alias dkc="osascript -l JavaScript -e 'Application(\"KeyCast\").enabled = false;'"
alias gpa="find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;"

prompt_context() {
  prompt_segment white black "%(!.%{%F{yellow}%}.)$DEFAULT_USER"
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"

export GOPATH=$HOME/Code/Go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

export NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh

# Java Versions
alias jdk11="export JAVA_HOME=`/usr/libexec/java_home -v 11` && export PATH=$JAVA_HOME/bin:$PATH; java -version"
alias jdk8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8` && export PATH=$JAVA_HOME/bin:$PATH; java -version"
alias jdk7="export JAVA_HOME=`/usr/libexec/java_home -v 1.7` && export PATH=$JAVA_HOME/bin:$PATH; java -version"

export EDITOR='vim'
source ~/.bin/tmuxinator.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

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
eval "$(rbenv init -)"
