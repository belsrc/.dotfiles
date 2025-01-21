#!/usr/bin/env bash

. sh/utils.sh
. sh/installs.sh
. sh/files.sh
. sh/macos.sh

# Might as well get it now.
sudo -v

install_brew

info "Updating existing packages..."
update_pkgs
success "Packages updated"

install_baseline

export PATH="$PATH:/usr/bin"
. ~/.bashrc

install_rust
install_python
install_nvm
install_tsls
success "Baseline applications/languages installed"

chsh -s $(which zsh)
rename_files
rename_folders
sym_stow
source_term
info "Symlinking dotfiles complete"

install_pnpm
install_omz
install_fd
install_rust_pkgs
install_delta
install_apps
success "Applications installed"

info "Build cache for bat..."
bat cache --build

info "Cloning nvim setup..."
git clone https://github.com/belsrc/belstart.nvim.git ~/.config/nvim

mac_only

clean_up

success "Complete!"
