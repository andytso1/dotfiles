#!/usr/bin/env bash

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# Check if zsh is available in the system PATH
if ! command -v zsh &> /dev/null; then
    echo "Zsh not found. Proceeding with installation..."

    # OS detection and installation
    if [ -f /etc/debian_version ]; then
        $SUDO apt update && $SUDO apt install -y zsh
    elif [ -f /etc/redhat-release ]; then
        $SUDO dnf install -y zsh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh
    else
        echo "Unsupported OS. Please install Zsh manually."
        exit 1
    fi
else
    echo "Zsh is already installed: $(zsh --version)"
fi

# Check if tmux is available in the system PATH
if ! command -v tmux &> /dev/null; then
    echo "tmux not found. Proceeding with installation..."

    if [ -f /etc/debian_version ]; then
        $SUDO apt update && $SUDO apt install -y tmux
    elif [ -f /etc/redhat-release ]; then
        $SUDO dnf install -y tmux
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install tmux
    else
        echo "Unsupported OS. Please install tmux manually."
    fi
else
    echo "tmux is already installed: $(tmux -V)"
fi

# Check if GitHub CLI is available in the system PATH
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Proceeding with installation..."

    if [ -f /etc/debian_version ]; then
        $SUDO apt update && $SUDO apt install -y gh
    elif [ -f /etc/redhat-release ]; then
        $SUDO dnf install -y gh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    else
        echo "Unsupported OS. Please install GitHub CLI manually."
    fi
else
    echo "GitHub CLI is already installed: $(gh --version | head -n 1)"
fi

if command -v gh &> /dev/null; then
    if ! gh auth status &> /dev/null; then
        gh auth login
    fi

    gh auth setup-git
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

DIR=$HOME/.vim/bundle/Vundle.vim
if test -d "$DIR"; then
    echo "$DIR exists - skipping clone"
else
    mkdir -p "$HOME/.vim/bundle"
    git clone https://github.com/VundleVim/Vundle.vim.git "$DIR"
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

if command -v vim &> /dev/null; then
    vim +PluginInstall +qall
else
    echo "Vim not found. Skipping Vim plugin install."
fi


# Cursor user settings (desktop only; only meaningful on the GUI machine)
if [[ "$OSTYPE" == "darwin"* ]]; then
    CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
    if [ -d "$CURSOR_USER" ]; then
        mkdir -p "$CURSOR_USER"
        ln -sf "$HOME/dotfiles/cursor/keybindings.json" "$CURSOR_USER/keybindings.json"
        ln -sf "$HOME/dotfiles/cursor/settings.json"    "$CURSOR_USER/settings.json"
    fi
fi

# switch to zsh
exec zsh
