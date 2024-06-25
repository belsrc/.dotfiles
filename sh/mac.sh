#!/usr/bin/env bash

. sh/utils.sh

install_brew() {
  if exists "brew"; then
    info "brew is already installed. Skipping."
  else
    info "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update
    brew upgrade
    success "brew install complete."
  fi
}

# Could also use brew list | grep $a
install_apps() {
  for a in "${apps[@]}"; do
    if exists "$a"; then
      info "$a is already installed. Skipping."
    else
      info "Installing $a..."
      brew install $a
      success "$a install complete."
    fi
  done
}

install_mac() {
  install_brew
  install_rust
  install_rust_pkgs
  install_pip_pkgs
  install_apps
}
