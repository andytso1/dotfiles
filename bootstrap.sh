#!/usr/bin/env bash
# bootstrap.sh - one-shot setup for a fresh GPU box.
#
# Usage (on a brand-new machine):
#   curl -LsSf https://raw.githubusercontent.com/andytso1/dotfiles/master/bootstrap.sh | bash
# or, if you've already cloned the dotfiles repo:
#   ~/dotfiles/bootstrap.sh
#
# Idempotent: safe to re-run.

set -euo pipefail

DOTFILES_REPO="https://github.com/andytso1/dotfiles.git"
PROJECT_REPO="https://github.com/andytso1/a5.git"
DOTFILES_DIR="$HOME/dotfiles"
PROJECT_DIR="$HOME/a5"

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# 1. dotfiles ---------------------------------------------------------------
log "Setting up dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    # Prefer git over gh here so this also works before gh is installed.
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo "$DOTFILES_DIR already exists - skipping clone"
fi

# Run the existing setup script (zsh, p10k, gh, symlinks).
# setup.sh ends with `exec zsh`, which would prevent the rest of bootstrap
# from running. Strip that final line for this invocation.
log "Running dotfiles/setup.sh"
SETUP_SH="$DOTFILES_DIR/setup.sh"
tmp_setup="$(mktemp)"
trap 'rm -f "$tmp_setup"' EXIT
grep -v '^[[:space:]]*exec[[:space:]]\+zsh[[:space:]]*$' "$SETUP_SH" > "$tmp_setup"
bash "$tmp_setup"

# 2. project repo -----------------------------------------------------------
log "Cloning project repo ($PROJECT_REPO)"
if [ ! -d "$PROJECT_DIR" ]; then
    if command -v gh >/dev/null 2>&1; then
        gh repo clone "$PROJECT_REPO" "$PROJECT_DIR"
    else
        git clone "$PROJECT_REPO" "$PROJECT_DIR"
    fi
else
    echo "$PROJECT_DIR already exists - skipping clone"
fi

# 3. uv ---------------------------------------------------------------------
log "Installing uv"
if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
# Make uv visible in this shell.
if [ -f "$HOME/.local/bin/env" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.local/bin/env"
fi
export PATH="$HOME/.local/bin:$PATH"

# 4. nvitop -----------------------------------------------------------------
log "Installing nvitop"
if ! command -v nvitop >/dev/null 2>&1; then
    pip install --quiet nvitop 2>/dev/null \
        || uv tool install nvitop
fi

# 5. switch to zsh ----------------------------------------------------------
log "Bootstrap complete - launching zsh"
if command -v zsh >/dev/null 2>&1 && [ -t 1 ]; then
    exec zsh
fi
