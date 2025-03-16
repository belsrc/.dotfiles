#!/usr/bin/env bash

if [[ $1 == "--help" ]]; then
  echo ""
  echo "setup.sh [--macos]"
  echo "  --macos: Run the MacOS configuration script"
  echo ""
  exit 0
fi

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
install_bun
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
install_rustowl
install_apps
success "Applications installed"

info "Build cache for bat..."
bat cache --build

info "Cloning nvim setup..."
git clone https://github.com/belsrc/belstart.nvim.git ~/.config/nvim

if [[ $1 == "--macos" ]]; then
  mac_only
fi

clean_up

success "Complete!"
