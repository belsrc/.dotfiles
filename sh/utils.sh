#!/usr/bin/env bash

baseline=(
  git
  zsh
  stow
  python3
  lua
)

apps=(
  fzf
  bat
)

cargo_pkgs=(
  eza
  git-delta
  zoxide
)

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

source_term() {
  source ~/.zshrc
}

in_cmd() {
  hash "$@" &> /dev/null
}

# Does it exist in the package manager?
in_manager() {
  OS="`uname`"

  case $OS in
    'Linux')
      apt list --installed | grep "$@" &> /dev/null
      ;;
    'Darwin')
      brew list | grep "$@" &> /dev/null
      ;;
    *) ;;
  esac
}

# Does it exist in cargo?
in_cargo() {
  cargo install --list | grep "$@" &> /dev/null
}

# Does it exist in pip?
in_pip() {
  pip3 list | grep "$@" &> /dev/null
}

# Does it exist in any of them?
in_any() {
  in_cmd "$@" || in_manager "$@" || in_cargo "$@" || in_pip "$@"
}

install_pkg() {
  OS="`uname`"

  case $OS in
    'Linux')
      sudo apt install -y "$@" || echo "$p failed to install"
      ;;
    'Darwin')
      brew install "$@" || echo "$p failed to install"
      ;;
    *) ;;
  esac
}

# Update current packages.
update_pkgs() {
  OS="`uname`"

  case $OS in
    'Linux')
      sudo apt update
      sudo apt upgrade
      ;;
    'Darwin')
      brew update
      brew upgrade
      ;;
    *) ;;
  esac
}

# Cleanup after ourselves.
clean_up() {
  OS="`uname`"

  info "Cleaning up..."

  case $OS in
    'Linux')
      sudo apt autoremove
      ;;
    'Darwin')
      brew cleanup
      ;;
    *) ;;
  esac
}

