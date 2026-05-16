#!/usr/bin/env bash

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

install_with_package_manager() {
    local package_name="$1"
    local display_name="$2"

    if [ -f /etc/debian_version ]; then
        $SUDO apt update && $SUDO apt install -y "$package_name"
    elif [ -f /etc/redhat-release ]; then
        $SUDO dnf install -y "$package_name"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install "$package_name"
    else
        echo "Unsupported OS. Please install $display_name manually."
        return 1
    fi
}

install_if_missing() {
    local command_name="$1"
    local package_name="$2"
    local display_name="$3"
    shift 3

    if command -v "$command_name" &> /dev/null; then
        echo "$display_name is already installed: $("$@" | head -n 1)"
        return 0
    fi

    echo "$display_name not found. Proceeding with installation..."
    install_with_package_manager "$package_name" "$display_name"
}

install_if_missing zsh zsh Zsh zsh --version || exit 1
install_if_missing vim vim vim vim --version

# Debian/Ubuntu installs bat as batcat, so either executable means we are set.
if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
    echo "bat not found. Proceeding with installation..."
    install_with_package_manager bat bat
elif command -v bat &> /dev/null; then
    echo "bat is already installed: $(bat --version)"
else
    echo "bat is already installed: $(batcat --version)"
fi

install_if_missing less less less less --version
install_if_missing tree tree tree tree --version
install_if_missing tmux tmux tmux tmux -V
install_if_missing gh gh "GitHub CLI" gh --version
