#!/usr/bin/env bash

. sh/utils.sh
. sh/installs.sh
. sh/macos.sh

# Might as well get it now.
sudo -v

cd ~

install_brew
update_pkgs
install_baseline

export PATH="$PATH:/usr/bin"
. ~/.bashrc

install_rust
install_python
install_lua
install_omz

# chsh -s $(which zsh)
# remove current stowed folders/files
# mkdir for all folders needed (so no sym folder)
# symlink stow
source_term

install_nvm
install_apps
install_ripgrep
install_fd
install_rust_pkgs
install_delta
install_tldr
install_neovim

# install nvim repo

mac_only

clean_up
