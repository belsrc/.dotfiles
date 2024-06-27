#!/usr/bin/env bash

. sh/utils.sh
. sh/installs.sh
. sh/files.sh
. sh/macos.sh

# Might as well get it now.
sudo -v

install_brew
update_pkgs
install_baseline

export PATH="$PATH:/usr/bin"
. ~/.bashrc

install_rust
install_python
install_nvm
install_lua
install_omz

chsh -s $(which zsh)
rename_files
rename_folders
sym_stow

source_term

install_apps
install_ripgrep
install_fd
install_rust_pkgs
install_delta
install_tldr
install_neovim

# Need to make it public first
# git clone https://github.com/belsrc/chadstart.nvim.git ~/.config/nvim
git clone git@github.com:belsrc/chadstart.nvim.git ~/.config/nvim

mac_only

clean_up
