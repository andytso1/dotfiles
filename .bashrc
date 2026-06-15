# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

# Hand off interactive bash sessions to zsh (e.g. Cursor, terminals using $SHELL).
if [[ -z "$ZSH_VERSION" ]]; then
  exec zsh
fi
