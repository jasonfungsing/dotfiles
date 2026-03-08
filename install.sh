#!/usr/bin/env bash

command_exists() {
    type "$1" > /dev/null 2>&1
}

echo "Installing dotfiles..."

ln -s $PWD/shell/vimrc $HOME/.vimrc
ln -s $PWD/shell/zshrc $HOME/.zshrc
ln -s $PWD/terminal/tmux.conf $HOME/.tmux.conf
ln -s $PWD/git/gitconfig $HOME/.gitconfig
ln -s $PWD/system/hushlogin $HOME/.hushlogin
ln -s $PWD/shell/alias_prompt.sh $HOME/.alias_prompt.sh

if test ! "$( command -v brew )"; then
    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Change the default shell to zsh
    zsh_path="$( command -v zsh )"
    if ! grep "$zsh_path" /etc/shells; then
        echo "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        echo "default shell changed to $zsh_path"
    fi

    source macos.sh

    echo "creating vim directories"
    mkdir -p ~/.vim-tmp

    if ! command_exists zsh; then
        echo "zsh not found. Please install and then re-run installation scripts"
        exit 1
    elif ! [[ $SHELL =~ .*zsh.* ]]; then
        echo "Configuring zsh as default shell"
        chsh -s "$(command -v zsh)"
    fi

    echo "Done. Reload your terminal."
