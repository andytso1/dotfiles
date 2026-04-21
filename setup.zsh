#!/usr/bin/env zsh

# clone dependencies
DIR=$HOME/zsh-syntax-highlighting
if test -d "$DIR"; then
    echo "$DIR exists - skipping clone"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $DIR
fi

DIR=$HOME/powerlevel10k
if test -d "$DIR"; then
    echo "$DIR exists - skipping clone"
else
    git clone https://github.com/romkatv/powerlevel10k.git $DIR
fi


# do sym links
ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/.vimrc $HOME/.vimrc
ln -sf $HOME/dotfiles/.inputrc $HOME/.inputrc
ln -sf $HOME/dotfiles/.editrc $HOME/.editrc
ln -sf $HOME/dotfiles/.nonplugin_vimrc $HOME/.nonplugin_vimrc
ln -sf $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf

# do sourcing
source ~/.zshrc
