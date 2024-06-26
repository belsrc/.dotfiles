#!/usr/bin/env bash

baseline=(
  git
  zsh
  stow
  python3
)

apps=(
  fzf
  bat
)

cargo_pkgs=(
  fd-find
  eza
  git-delta
  zoxide
)

pip_pkgs=(thefuck tldr)

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

exists() {
  hash "$@" &> /dev/null
}

any_exists() {
  hash "$@" &> /dev/null || cargo install --list | grep "$@" &> /dev/null
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

install_brew() {
  OS="`uname`"

  if exists "brew"; then
    info "brew is already installed. Skipping."
  else
    if [ "$OS" = "Darwin" ]; then
      info "Installing brew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      brew update
      brew upgrade
      success "brew install complete."
    else
      warn "Not MacOS. Skipping brew"
    fi
  fi
}

install_baseline() {
  for b in "${baseline[@]}"; do
    if exists "$b"; then
      info "$b is already installed. Skipping."
    else
      info "Installing $b..."
      install_pkg $b
      success "$b install complete."
    fi
  done
}

install_omz() {
  if [ -d ~/.oh-my-zsh ]; then
    info "oh-my-zsh is already installed. Skipping."
  else
    info "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    success "oh-my-zsh install complete."
  fi
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

install_neovim() {
  if exists "nvim"; then
    info "nvim is already installed. Skipping."
  else
    info "Installing nvim..."
    install_pkg neovim
    success "nvim install complete."
  fi
}

install_ripgrep() {
  if exists "rg"; then
    info "ripgrep is already installed. Skipping."
  else
    info "Installing ripgrep..."
    install_pkg ripgrep
    success "ripgrep install complete."
  fi
}

sym_stow() {
  stow -d ~/.dotfiles/stow -t ~ .
  source_term
}

install_apps() {
  for a in "${apps[@]}"; do
    if any_exists "$a"; then
      info "$a is already installed. Skipping."
    else
      info "Installing $a..."
      install_pkg $a
      success "$a install complete."
    fi
  done
}

install_rust_pkgs() {
  for p in "${cargo_pkgs[@]}"; do
    if any_exists $p; then
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

install_nvm() {
  if exists "nvm"; then
    info "nvm is already installed. Skipping."
  else
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source_term
    success "nvm install complete."
  fi

  nvm use node
}
