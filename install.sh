#!/usr/bin/env bash

. sh/mac.sh
. sh/nix.sh

OS="`uname`"

if [ "$OS" = "Linux" ]; then
  sudo -v
  install_linux
elif [ "$OS" = "Darwin" ]; then
  install_mac
else
  echo "Unknown OS. Exiting."
  exit 1
fi

# Setup oh-my-zsh? (should be done in stow)
# Set zsh as default
# Symlink stow
