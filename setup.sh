#!/usr/bin/env bash

# Check if zsh is available in the system PATH
if ! command -v zsh &> /dev/null; then
    echo "Zsh not found. Proceeding with installation..."

    # OS detection and installation
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install -y zsh
    elif [ -f /etc/redhat-release ]; then
        sudo dnf install -y zsh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh
    else
        echo "Unsupported OS. Please install Zsh manually."
        exit 1
    fi
else
    echo "Zsh is already installed: $(zsh --version)"
fi

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
ln -sf $HOME/dotfiles/.p10k.zsh $HOME/.p10k.zsh

ln -sf $HOME/dotfiles/.vimrc $HOME/.vimrc
ln -sf $HOME/dotfiles/.inputrc $HOME/.inputrc
ln -sf $HOME/dotfiles/.editrc $HOME/.editrc

ln -sf $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
ln -sf $HOME/dotfiles/.nonplugin_vimrc $HOME/.nonplugin_vimrc
ln -sf $HOME/dotfiles/.gitconfig $HOME/.gitconfig

# switch to zsh
exec zsh