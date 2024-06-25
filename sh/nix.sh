#!/usr/bin/env bash

. sh/utils.sh

install_apps() {
  for a in "${apps[@]}"; do
    if exists "$a"; then
      info "$a is already installed. Skipping."
    else
      info "Installing $a..."
      sudo apt install -y $a
      success "$a install complete."
    fi
  done
}

install_linux() {
  install_rust
  install_rust_pkgs
  install_apps

  sudo apt autoremove
}
