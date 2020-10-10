#!/usr/bin/env bash

command_exists() {
    type "$1" > /dev/null 2>&1
}

echo "Installing dotfiles..."

ln -s $PWD/vimrc $HOME/.vimrc
ln -s $PWD/zshrc $HOME/.zshrc
ln -s $PWD/tmux.conf $HOME/.tmux.conf
ln -s $PWD/gitconfig $HOME/.gitconfig
ln -s $PWD/hushlogin $HOME/.hushlogin
ln -s $PWD/alias_prompt.sh $HOME/.alias_prompt.sh

if test ! "$( command -v brew )"; then
    echo "Installing homebrew"
    ruby -e "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install )"
fi

    # install brew dependencies from Brewfile
    brew bundle

    # After the install, setup fzf
    echo -e "\\n\\nRunning fzf install script..."
    echo "=============================="
    /usr/local/opt/fzf/install --all --no-bash --no-fish

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

    source install/macos.sh

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
