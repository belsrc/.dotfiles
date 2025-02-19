#!/usr/bin/env bash

. sh/utils.sh

# Make sure Brew is installed if on a Mac
# so we can install the other apps.
install_brew() {
  OS="`uname`"

  if in_cmd "brew"; then
    info "brew is already installed. Skipping."
  else
    if [ "$OS" = "Darwin" ]; then
      info "Installing brew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      brew update
      brew upgrade
      success "Brew installed"
    else
      warn "Not MacOS. Skipping brew"
    fi
  fi
}

# Install the baseline things.
# Under the assumption that this is a freshie.
install_baseline() {
  for b in "${baseline[@]}"; do
    if in_cmd "$b"; then
      info "$b is already installed. Skipping."
    else
      info "Installing $b..."
      install_pkg $b
    fi
  done
}

# OMZ has a slightly different check and install.
# So it gets it's own.
install_omz() {
  if [ -d ~/.oh-my-zsh ]; then
    info "oh-my-zsh is already installed. Skipping."
  else
    info "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi
}

# Install Rust. This could™ be done via package managers.
# But the name is still different between the two and using
# the curl command is the recommended way.
install_rust() {
  if in_cmd "rustc"; then
    info "rust is already installed. Skipping."
  else
    info "Installing rust..."
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
  fi

  info "Updating rust toolchain..."
  rustup update
}

# Install Python. The package names are different.
install_python() {
  if in_any "pip"; then
    info "python is already installed. Skipping."
  else
    info "Installing python..."

    OS="`uname`"
    case $OS in
      'Linux')
        sudo pacman -S --noconfirm python python-pip || echo "python failed to install"
        ;;
      'Darwin')
        brew install python || echo "python failed to install"
        ;;
      *) ;;
    esac
  fi
}

# Install all of items in apps list.
install_apps() {
  for a in "${apps[@]}"; do
    if in_any "$a"; then
      info "$a is already installed. Skipping."
    else
      info "Installing $a..."
      install_pkg $a
    fi
  done
}

# Install all of items in cargo list.
install_rust_pkgs() {
  for p in "${cargo_pkgs[@]}"; do
    if in_any $p; then
      info "$p is already installed. Skipping."
    else
      info "Installing $p..."
      cargo install $p
    fi
  done
}

# Install FD. The command and the package name are different
# so just yank it out of the app list for ease.
install_fd() {
  if in_any "fd-find" || in_any "fd"; then
    info "fd is already installed. Skipping."
  else
    info "Installing fd..."
    cargo install fd-find
  fi
}

# Install Delta. The command and the package name are different
# so just yank it out of the app list for ease.
install_delta() {
  if in_any "git-delta" || in_any "delta"; then
    info "git-delta is already installed. Skipping."
  else
    info "Installing git-delta..."
    cargo install git-delta
  fi
}

# Install nvm and set node to latest.
install_nvm() {
  if in_cmd "node"; then
    info "node is already installed. Skipping."
  else
    info "Installing node..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source_term
    nvm install node
    nvm use node
  fi
}

install_tsls() {
  npm i -g typescript-language-server
}

install_pnpm() {
  if in_any "pnpm"; then
    info "pnpm is already installed. Skipping."
  else
    info "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
  fi
}

install_bun() {
  if in_any "bun"; then
    info "bun is already installed. Skipping."
  else
    info "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
  fi
}

install_rustowl() {
  if in_any "rustowl"; then
    info "rustowl is already installed. Skipping."
  else
    info "Installing rustowl..."
    curl -L "https://github.com/cordx56/rustowl/releases/download/v0.1.1/install.sh" | s
  fi
}
