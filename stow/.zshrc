############################
############## SETUP
############################

# ---- GENERAL ----
set -o vi # Add vim motions to terminal

# ---- ZSH ----
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# ---- Homebrew ----
if [[ $OSTYPE == darwin* ]]; then
  export PATH="$PATH:/opt/homebrew/bin"
fi

# ---- Go ----
export PATH="$PATH:$HOME/go/bin"

# ---- Rust Cargo ----
. "$HOME/.cargo/env"

# ---- Node ----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$PATH:/usr/local/bin"

# ---- Bun ----
export BUN_INSTALL="$HOME/.bun"

[ -s "$BUN_INSTALL/.bun/_bun" ] && source "$BUN_INSTALL/_bun"

export PATH="$PATH:$BUN_INSTALL/bin"

# ---- PNPM ----
if [[ $OSTYPE != darwin* ]]; then
  # Only set in *nix
  export PNPM_HOME="$HOME/.local/share/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

# ---- Powerlevel10k ----
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---- FZF ----
# CTRL-t - Look for files and directories
# CTRL-r - Look through command history
# Enter  - Select the item
# Ctrl-j | Ctrl-n | Down arrow - Go down one result
# Ctrl-k | Ctrl-p | Up arrow - Go up one result
# Tab - Mark a result
# Shift-Tab - Unmark a result
# cd **Tab - Open up fzf to find directory
# export **Tab - Look for env variable to export
# unset **Tab - Look for env variable to unset
# unalias **Tab - Look for alias to unalias
# ssh **Tab - Look for recently visited host names
# kill -9 **Tab - Look for process name to kill to get pid
# any command (like nvim or code) + **Tab - Look for files & directories to complete command Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# One Dark fzf theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#5c6370,fg+:#ffffff,bg:#1e2127,bg+:#5c6370
  --color=hl:#56b6c2,hl+:#61afef,info:#afaf87,marker:#98c379
  --color=prompt:#e06c75,spinner:#c678dd,pointer:#c678dd,header:#87afaf
  --color=border:#abb2bf,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt=">"
  --marker=">" --pointer="" --separator="─" --scrollbar="│"'

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path (** completion) candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory (** tab) completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ---- BAT ----
# One Dark bat theme
export BAT_THEME="One Dark"

# ---- Zoxide ----
eval "$(zoxide init zsh)"

############################
############## ALIASES
############################

# ---- NVIM ----
alias vim="nvim"
alias vi="nvim"

# ---- Rust/Cargo ----
alias rsn="cargo new"
alias rsi="cargo init"
alias rst="cargo test"
alias rsr="cargo run"
alias rsb="cargo build"
alias rsc="cargo check"
alias rsf="cargo fmt"
alias rsa="cargo install"

# ---- Golang ----
alias gob="go build"
alias gor="go run"
alias goc="go clean -i"
alias got="go test ./..."

# ---- Bun ----
alias bnr="bun run"
alias bnt="bun test"
alias bnint="bun init"
alias bnc="bun create"
alias bnx="bunx"
alias bni="bun install"
alias bna="bun add"
alias bnre="bun remove"
alias bnu="bun update"
alias bno="bun outdated"

# ---- Python ----
alias pip='pip3'
alias python='python3'

# ---- PNPM ----
alias pn=pnpm

# ---- Eza (better ls) -----
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# ---- Pipe ripgrep into fzf ----
rgfzf() { rg "$1" | fzf }
alias rgf="rgfzf"

# ---- Zoxide (better cd) ----
alias cd="z"

# ---- Bottom (better top) ----
alias cat="bat"
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# ---- Bottom (better top) ----
alias top="btm"

# ---- SD (better sed) ----
alias sed="sd"

# ---- Procs (better ps) ----
alias ps="procs"

# ---- Lazygit (better git interface) ----
alias lg="lazygit"

# ---- Tokei (Count lines of code) ----
alias loc="tokei"

# ---- thefuck alias ----
eval $(thefuck --alias)

# ---- Yazi (better file manager) ----
export EDITOR="nvim"

# ---- General ----
count() { rg "$@" | wc -l }
todos() { rgf "(TODO:)|(FIXME:)|(HACK:)|(REVIEW:)" }

# ---- Upgrade crates easily ----
cupgrade() { cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ') }

# ---- Mac only ----
if [[ $OSTYPE == darwin* ]]; then
  alias flush="dscacheutil -flushcache"
  # Mac doesn't have lscpu, close as you can get
  alias lscpu="sysctl -a | grep machdep.cpu"
fi

