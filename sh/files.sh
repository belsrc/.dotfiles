
#!/usr/bin/env bash

. sh/utils.sh

files=(
  ~/.gitconfig
  ~/.p10k.zsh
  ~/.zshenv
  ~/.zshrc
)

folders=(
  ~/.config
)

mk_folders=(
  ~/.config
  ~/.config/alacritty
  ~/.config/bat
  ~/.config/bat/themes
  ~/.config/kitty
)

# Rename the old config files before we symlink the new ones.
rename_files() {
  for f in "${files[@]}"; do
    if file_exists "$f"; then
      info "$f exists. Renaming to $f.pre-setup"
      mv "$f" "$f.pre-setup"
    else
      info "$f doesn't exist. Skipping."
    fi
  done
}

# Rename the old .config folder before running stow.
# Also manually create the needed folders so there is
# no symlinked folders.
rename_folders() {
  for f in "${folders[@]}"; do
    if folder_exists "$f"; then
      info "$f exists. Renaming to $f.pre-setup"
      mv "$f" "$f.pre-setup"
    else
      info "$f doesn't exist. Skipping."
    fi
  done

  for m in "${mk_folders[@]}"; do
    info "Making new folder $m."
    mkdir "$m"
  done
}

# Run stow command.
sym_stow() {
  info "Symlinking dot files..."
  stow -d ~/.dotfiles/stow -t ~ .
  source_term
}
