#!/usr/bin/env bash
# Install OMZ + Starship + vim-plug, backing up and replacing .zshrc/.vimrc.
# Installs missing tools only; reuses existing plugins.
# Usage: bash omz-starship-vim.sh [--skip-packages]
set -euo pipefail

log() { printf '\n%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

skip_packages=false
for arg in "$@"; do
  case "$arg" in
    --skip-packages) skip_packages=true ;;
    -h|--help)
      printf '%s\n' \
        'Usage: bash omz-starship-vim.sh [--skip-packages]' \
        'Backs up and replaces ~/.zshrc and ~/.vimrc; uses 6 OMZ and 5 Vim plugins.' \
        'Installs missing tools only; macOS uses Homebrew, Linux uses apt-get/dnf/pacman.' \
        'Does not change your login shell. Start Zsh with: exec zsh'
      exit 0 ;;
    *) die "Unknown argument: $arg" ;;
  esac
done

# SETUP_HOME permits isolated validation without changing the HOME variable.
setup_home="${SETUP_HOME:-$HOME}"
[[ "$setup_home" = /* && "$setup_home" != / ]] || die 'SETUP_HOME must be an absolute home-directory path.'
mkdir -p "$setup_home"
work_dir=$(mktemp -d "${TMPDIR:-/tmp}/omz-starship-vim.XXXXXXXX")
trap 'rm -r -- "$work_dir"' EXIT

download() {
  curl --fail --location --silent --show-error --retry 2 \
    --connect-timeout 15 --max-time 180 "$1" -o "$2"
}

run_privileged() {
  if [[ $(id -u) == 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

install_packages() {
  local missing=() tool
  for tool in zsh git curl vim fzf; do
    command -v "$tool" >/dev/null || missing+=("$tool")
  done
  case "$(uname -s)" in
    Darwin)
      if ! command -v starship >/dev/null && [[ ! -x "$setup_home/.local/bin/starship" ]]; then
        missing+=(starship)
      fi
      [[ ${#missing[@]} -gt 0 ]] || return 0
      command -v brew >/dev/null || die 'Homebrew is required: https://brew.sh'
      brew install "${missing[@]}"
      ;;
    Linux)
      for tool in tar gzip; do
        command -v "$tool" >/dev/null || missing+=("$tool")
      done
      if [[ ${#missing[@]} -gt 0 ]]; then
        if [[ $(id -u) != 0 ]]; then
          command -v sudo >/dev/null || die 'sudo is required to install system packages.'
        fi
        if command -v apt-get >/dev/null; then
          run_privileged apt-get update
          run_privileged apt-get install -y "${missing[@]}"
        elif command -v dnf >/dev/null; then
          run_privileged dnf install -y "${missing[@]/vim/vim-enhanced}"
        elif command -v pacman >/dev/null; then
          run_privileged pacman -S --needed --noconfirm "${missing[@]}"
        else
          die 'Unsupported package manager. Install the required tools, then use --skip-packages.'
        fi
      fi
      if ! command -v starship >/dev/null && [[ ! -x "$setup_home/.local/bin/starship" ]]; then
        mkdir -p "$setup_home/.local/bin"
        download https://starship.rs/install.sh "$work_dir/starship-install.sh"
        sh "$work_dir/starship-install.sh" --yes --bin-dir "$setup_home/.local/bin"
      fi
      ;;
    *) die 'Supported operating systems: macOS and Linux.' ;;
  esac
}

if ! $skip_packages; then
  log 'Installing required packages...'
  install_packages
fi
for tool in zsh git curl vim; do
  command -v "$tool" >/dev/null || die "Missing dependency: $tool"
done
if ! command -v starship >/dev/null && [[ ! -x "$setup_home/.local/bin/starship" ]]; then
  die 'Missing dependency: starship'
fi

log 'Preparing Oh My Zsh and vim-plug...'
omz_dir="$setup_home/.oh-my-zsh"
if [[ ! -e "$omz_dir" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$work_dir/oh-my-zsh"
  mv "$work_dir/oh-my-zsh" "$omz_dir"
fi
[[ -f "$omz_dir/oh-my-zsh.sh" ]] || die "Invalid Oh My Zsh installation: $omz_dir"

custom_plugins="$omz_dir/custom/plugins"
install_omz_plugin() {
  local name="$1" repository="$2"
  if [[ -f "$custom_plugins/$name/$name.plugin.zsh" || \
        -f "$omz_dir/plugins/$name/$name.plugin.zsh" ]]; then
    return
  fi
  [[ ! -e "$custom_plugins/$name" ]] || die "Incomplete plugin installation: $custom_plugins/$name"
  mkdir -p "$custom_plugins"
  git clone --depth=1 "$repository" "$work_dir/$name"
  [[ -f "$work_dir/$name/$name.plugin.zsh" ]] || die "Plugin entry point missing: $name"
  mv "$work_dir/$name" "$custom_plugins/$name"
}
install_omz_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
install_omz_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

# Plugin integrations do not themselves provide these command-line tools.
command -v fzf >/dev/null || log 'NOTE: fzf is not installed; its OMZ integration needs that tool.'
if [[ ! -f "$setup_home/.nvm/nvm.sh" && ! -f "${NVM_DIR:-$setup_home/.nvm}/nvm.sh" ]]; then
  log 'NOTE: nvm requires a separate installation if not already available through Homebrew or NVM_DIR: https://github.com/nvm-sh/nvm'
fi
if [[ -s "$setup_home/.vim/autoload/plug.vim" ]]; then
  cp "$setup_home/.vim/autoload/plug.vim" "$work_dir/plug.vim"
else
  download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim "$work_dir/plug.vim"
fi
[[ -s "$work_dir/plug.vim" ]] || die 'Downloaded plug.vim is empty.'

backup_root="$setup_home/.config/omz-starship-vim-backups"
mkdir -p "$backup_root"
backup_dir=$(mktemp -d "$backup_root/$(date +%Y%m%d-%H%M%S).XXXXXXXX")
for file in .zshrc .vimrc .vim/autoload/plug.vim; do
  if [[ -e "$setup_home/$file" || -L "$setup_home/$file" ]]; then
    mkdir -p "$backup_dir/$(dirname "$file")"
    cp -pL "$setup_home/$file" "$backup_dir/$file"
  fi
done

cat > "$work_dir/zshrc" <<'ZSHRC'
# Generated by omz-starship-vim.sh. Previous configuration is backed up.
export PATH="$HOME/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
  aliases
  env
  git
  nvm
  z
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
)
# Load Node immediately, as requested.
zstyle ':omz:plugins:nvm' lazy no
source "$ZSH/oh-my-zsh.sh"
if (( $+widgets[autosuggest-accept] )); then
  bindkey '^ ' autosuggest-accept
fi

export EDITOR=vim
export VISUAL=vim
[[ ! -f ~/.virtualenv/bin/activate ]] || source ~/.virtualenv/bin/activate
eval "$(starship init zsh)"
ZSHRC

cat > "$work_dir/vimrc" <<'VIMRC'
" Generated by omz-starship-vim.sh. Previous configuration is backed up.
set nocompatible

" Resolve paths from this vimrc so SETUP_HOME also isolates plugin installation.
let s:vim_home = expand('<sfile>:p:h') . '/.vim'
execute 'set runtimepath^=' . fnameescape(s:vim_home)
call plug#begin(s:vim_home . '/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'tomasr/molokai'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
call plug#end()

filetype plugin indent on
syntax enable
set background=dark
if has('termguicolors')
  set termguicolors
endif
set number
set hidden
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" First startup must also work before PlugInstall has fetched the theme.
if !empty(globpath(&runtimepath, 'colors/molokai.vim'))
  colorscheme molokai
endif
VIMRC

mkdir -p "$setup_home/.vim/autoload"
# Replacing symlinks here leaves their previous targets untouched.
mv "$work_dir/zshrc" "$setup_home/.zshrc"
mv "$work_dir/vimrc" "$setup_home/.vimrc"
mv "$work_dir/plug.vim" "$setup_home/.vim/autoload/plug.vim"

vim_plugins=(auto-pairs vim-easy-align molokai vim-repeat vim-surround)
vim_plugins_ready=true
for plugin in "${vim_plugins[@]}"; do
  [[ -d "$setup_home/.vim/plugged/$plugin/.git" ]] || vim_plugins_ready=false
done
if ! $vim_plugins_ready; then
  log 'Installing missing Vim plugins...'
  vim_log="$backup_dir/PlugInstall.log"
  if ! vim -Nu "$setup_home/.vimrc" -n -es -i NONE "-V1$vim_log" \
    '+PlugInstall --sync' '+qa!'; then
    die "Vim plugin installation failed. See $vim_log; backups: $backup_dir"
  fi
fi
for plugin in "${vim_plugins[@]}"; do
  [[ -d "$setup_home/.vim/plugged/$plugin/.git" ]] || \
    die "Plugin missing: $plugin; backups: $backup_dir"
done
zsh -n "$setup_home/.zshrc"

log "Setup complete. Previous configuration: $backup_dir"
printf '%s\n' \
  'Start the new prompt: exec zsh' \
  'Vim plugins: :PlugStatus | Update: :PlugUpdate | Remove unused: :PlugClean' \
  'Vim: surround + repeat, auto-pairs, easy-align, and Molokai; built-in filetype support.' \
  'Starship preserves an existing ~/.config/starship.toml; otherwise uses its default theme.'
