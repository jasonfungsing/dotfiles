echo "Symlinking dotfiles..."
#Symlink .zshrc and .vimrc
ln -s $PWD/vimrc $HOME/.vimrc
ln -s $PWD/zshrc $HOME/.zshrc
ln -s $PWD/tmux.conf $HOME/.tmux.conf
ln -s $PWD/gitconfig $HOME/.gitconfig
