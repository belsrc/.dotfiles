#!/usr/bin/env bash

apps=(
  python3
  zsh
  nvim
  fzf
  bat
  thefuck
)

cargo_pkgs=(
  fd-find
  eza
  git-delta
  zoxide
)

pip_pkgs=(tldr)

reset_color=$(tput sgr 0)

info() {
  printf "%s[*] %s%s\n" "$(tput setaf 4)" "$1" "$reset_color"
}

success() {
  printf "%s[*] %s%s\n" "$(tput setaf 2)" "$1" "$reset_color"
}

err() {
  printf "%s[*] %s%s\n" "$(tput setaf 1)" "$1" "$reset_color"
}

warn() {
  printf "%s[*] %s%s\n" "$(tput setaf 3)" "$1" "$reset_color"
}

exists() {
  hash "$@" &> /dev/null
}

install_rust() {
  if exists "rustc"; then
    info "rust is already installed. Skipping."
  else
    info "Installing rust..."
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
    success "rust install complete."
  fi

  info "Updating rust toolchain..."
  rustup update
}

install_rust_pkgs() {
  for p in "${cargo_pkgs[@]}"; do
    if cargo install --list | grep $p &> /dev/null; then
      info "$p is already installed. Skipping."
    else
      info "Installing $p..."
      cargo install $p
      success "$p install complete."
    fi
  done
}

install_pip_pkgs() {
  for p in "${pip_pkgs[@]}"; do
    if pip3 list | grep $p &> /dev/null; then
      info "$p is already installed. Skipping."
    else
      info "Installing $p..."
      cargo install $p
      success "$p install complete."
    fi
  done
}
