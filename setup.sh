#!/usr/bin/env bash

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

bash "$DOTFILES_DIR/install_packages.sh" || exit 1

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
ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/.inputrc" "$HOME/.inputrc"
ln -sf "$DOTFILES_DIR/.editrc" "$HOME/.editrc"

ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.nonplugin_vimrc" "$HOME/.nonplugin_vimrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

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
        ln -sf "$DOTFILES_DIR/cursor/keybindings.json" "$CURSOR_USER/keybindings.json"
        ln -sf "$DOTFILES_DIR/cursor/settings.json"    "$CURSOR_USER/settings.json"
    fi
fi

# switch to zsh
exec zsh
