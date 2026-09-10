#!/usr/bin/env bash

baseline=(
  git
  lua
  zig
  go
  cmake
  zsh
  stow
  xclip
  unzip
)

# ripgrep and neovim have different package names and commands
# so they only work since we grep the package manager list
# if that changes then need to be seperate installs.

apps=(
  fzf
  bat
  ripgrep
  thefuck
  lazygit
  tokei
  neovim
  tmux
)

cargo_pkgs=(
  just
  fnm
  tree-sitter-cli
  stylua
  bottom
  sd
  procs
  tealdeer
  eza
  git-delta
  zoxide
  hyperfine
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

detect_platform() {
  local uname_s
  uname_s=$(uname -s)

  if [[ "$uname_s" == "Darwin" ]]; then
    echo "macos"
    return 0
  fi

  if [[ "$uname_s" != "Linux" ]]; then
    err "Unsupported platform: $uname_s"
    return 1
  fi

  if [[ ! -f /etc/os-release ]]; then
    err "Unable to determine Linux distribution (missing /etc/os-release)"
    return 1
  fi

  local os_id
  os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

  case "$os_id" in
    arch)
      echo "arch"
      ;;
    ubuntu | debian)
      echo "debian"
      ;;
    *)
      err "Unsupported Linux distribution: $os_id"
      return 1
      ;;
  esac
}

resolve_pkg_names() {
  local platform request
  local packages=()

  platform="${DETECTED_PLATFORM:-$(detect_platform)}" || return 1

  for request in "$@"; do
    case "$request" in
      python)
        case "$platform" in
          arch)
            packages+=(python python-pip)
            ;;
          debian)
            packages+=(python3 python3-pip)
            ;;
          macos)
            packages+=(python)
            ;;
        esac
        ;;
      ghcli | github-cli | gh)
        case "$platform" in
          arch)
            packages+=(github-cli)
            ;;
          debian | macos)
            packages+=(gh)
            ;;
        esac
        ;;
      todotxt | todo-txt | todo.sh)
        case "$platform" in
          arch)
            packages+=(todotxt)
            ;;
          debian)
            packages+=(todotxt-cli)
            ;;
          macos)
            packages+=(todo-txt)
            ;;
        esac
        ;;
      *)
        packages+=("$request")
        ;;
    esac
  done

  printf '%s\n' "${packages[@]}"
}

# Does it exist in the package manager?
in_manager() {
  local platform pkg
  local packages=()

  platform="${DETECTED_PLATFORM:-$(detect_platform)}" || return 1
  packages=($(resolve_pkg_names "$@"))

  case "$platform" in
    arch)
      for pkg in "${packages[@]}"; do
        pacman -Qe | grep " $pkg " &> /dev/null && return 0
      done
      ;;
    debian)
      for pkg in "${packages[@]}"; do
        dpkg -s "$pkg" &> /dev/null && return 0
      done
      ;;
    macos)
      for pkg in "${packages[@]}"; do
        brew list --versions "$pkg" &> /dev/null && return 0
      done
      ;;
  esac

  return 1
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

file_exists() {
  test -f "$@"
}

folder_exists() {
  test -d "$@"
}

install_pkg() {
  local platform
  local packages=()

  platform="${DETECTED_PLATFORM:-$(detect_platform)}" || return 1
  packages=($(resolve_pkg_names "$@"))

  case "$platform" in
    arch)
      sudo pacman -S --noconfirm "${packages[@]}" || echo "$* failed to install"
      ;;
    debian)
      sudo apt-get install -y "${packages[@]}" || echo "$* failed to install"
      ;;
    macos)
      brew install "${packages[@]}" || echo "$* failed to install"
      ;;
  esac
}

# Update current packages.
update_pkgs() {
  local platform
  platform="${DETECTED_PLATFORM:-$(detect_platform)}" || return 1

  case "$platform" in
    arch)
      sudo pacman -Syu
      ;;
    debian)
      sudo apt-get update
      sudo apt-get upgrade -y
      ;;
    macos)
      brew update
      brew upgrade
      ;;
  esac
}

# Cleanup after ourselves.
clean_up() {
  local platform
  platform="${DETECTED_PLATFORM:-$(detect_platform)}" || return 1

  info "Cleaning up..."

  case "$platform" in
    arch)
      sudo pacman -Qdtq | pacman -Rns - || echo "None"
      ;;
    debian)
      sudo apt-get autoremove -y
      sudo apt-get autoclean -y
      ;;
    macos)
      brew cleanup
      ;;
  esac
}

