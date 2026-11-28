#!/usr/bin/env bash
# Install OMZ + Starship + Vim/Neovim + vim-plug, backing up and replacing their configuration.
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
        'Backs up and replaces Zsh/Vim/Neovim/Starship configuration; uses 9 OMZ plugins (+ brew on macOS when available) and 14 shared editor plugins.' \
        'Starship: Pastel Powerline preset with transparent second-line input (ANSI 256-color optimized + Powerline escape sequences).' \
        'Vim: Molokai colorscheme with robust termguicolors handling.' \
        'All components are optional; failures skip affected integrations. --skip-packages skips installation.' \
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

# 下载文件并显示进度条。
download() {
  local url="$1" out="$2"
  curl --fail --location --progress-bar --show-error --retry 2 \
    --connect-timeout 15 --speed-limit 1024 --speed-time 60 "$url" -o "$out"
}

# git clone 并显示进度。
git_clone() {
  local repo_url="$1" dest="$2"
  rm -rf -- "$dest"
  git clone --depth=1 --progress "$repo_url" "$dest"
}

run_privileged() {
  if [[ $(id -u) == 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

# Make Homebrew available even when a new shell has not loaded its shellenv.
activate_brew() {
  local brew_path brew_env
  if command -v brew >/dev/null && brew --version >/dev/null 2>&1; then
    return 0
  fi
  for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_path" ]]; then
      brew_env=$("$brew_path" shellenv) || continue
      eval "$brew_env"
      if brew --version >/dev/null 2>&1; then
        return 0
      fi
    fi
  done
  return 1
}

install_brew() {
  download https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh "$work_dir/homebrew-install.sh" || return 1
  NONINTERACTIVE=1 bash "$work_dir/homebrew-install.sh" || return 1
  activate_brew
}

install_packages() {
  local missing=() tool package arch starship_tarball starship_url
  for tool in zsh git curl vim nvim fzf tmux; do
    command -v "$tool" >/dev/null || missing+=("${tool/nvim/neovim}")
  done
  case "$(uname -s)" in
    Darwin)
      if ! command -v starship >/dev/null && [[ ! -x "$setup_home/.local/bin/starship" ]]; then
        missing+=(starship)
      fi
      [[ ${#missing[@]} -gt 0 ]] || return 0
      if ! $brew_ready; then
        log 'NOTE: Homebrew unavailable; skipping macOS package installation.'
        return 0
      fi
      for package in "${missing[@]}"; do
          if ! brew install "$package"; then
            log "NOTE: $package installation failed; continuing."
          fi
        done
      ;;
    Linux)
      for tool in tar gzip; do
        command -v "$tool" >/dev/null || missing+=("$tool")
      done
      if [[ ${#missing[@]} -gt 0 ]]; then
        if [[ $(id -u) != 0 ]]; then
          command -v sudo >/dev/null || return 1
        fi
        if command -v apt-get >/dev/null; then
          run_privileged apt-get update || return 1
          for package in "${missing[@]}"; do
          if ! run_privileged apt-get install -y "$package"; then
            log "NOTE: $package installation failed; continuing."
          fi
        done
        elif command -v dnf >/dev/null; then
          for package in "${missing[@]}"; do
          [[ "$package" != vim ]] || package=vim-enhanced
          if ! run_privileged dnf install -y "$package"; then
            log "NOTE: $package installation failed; continuing."
          fi
        done
        elif command -v pacman >/dev/null; then
          for package in "${missing[@]}"; do
          if ! run_privileged pacman -S --needed --noconfirm "$package"; then
            log "NOTE: $package installation failed; continuing."
          fi
        done
        else
          return 1
        fi
      fi
      if ! command -v starship >/dev/null && [[ ! -x "$setup_home/.local/bin/starship" ]]; then
        mkdir -p "$setup_home/.local/bin"
        case "$(uname -m)" in
          x86_64|amd64) arch=x86_64 ;;
          aarch64|arm64) arch=aarch64 ;;
          *) log "NOTE: Unsupported architecture for Starship: $(uname -m)."; return 1 ;;
        esac
        starship_tarball="starship-${arch}-unknown-linux-musl.tar.gz"
        starship_url="https://github.com/starship/starship/releases/latest/download/${starship_tarball}"
        if download "$starship_url" "$work_dir/$starship_tarball"; then
          if tar -xzf "$work_dir/$starship_tarball" -C "$work_dir" && [[ -f "$work_dir/starship" ]]; then
            mv "$work_dir/starship" "$setup_home/.local/bin/starship" || return 1
            chmod +x "$setup_home/.local/bin/starship" || return 1
          else
            log 'NOTE: Failed to extract Starship tarball.'
            return 1
          fi
        else
          log 'NOTE: Failed to download Starship tarball.'
          return 1
        fi
      fi
      ;;
    *) return 1 ;;
  esac
}

# Pastel Powerline icons/separators require a Nerd Font in the terminal.
install_font() {
  local font_dir face file changed=false
  # 优先检查本地可能存在的 Mono 版本或通用版本
  local local_font_mono="./nerd-fonts/Hack Regular Nerd Font Complete Mono.ttf"
  local local_font="./nerd-fonts/Hack Regular Nerd Font Complete.ttf"

  case "$(uname -s)" in
    Darwin)
      if [[ -s "$local_font_mono" ]]; then
        log "Found local font: $local_font_mono. Installing without downloading..."
        mkdir -p "$setup_home/Library/Fonts" || return 1
        cp "$local_font_mono" "$setup_home/Library/Fonts/" || return 1
        return 0
      elif [[ -s "$local_font" ]]; then
        log "Found local font: $local_font. Installing without downloading..."
        mkdir -p "$setup_home/Library/Fonts" || return 1
        cp "$local_font" "$setup_home/Library/Fonts/" || return 1
        return 0
      fi

      command -v brew >/dev/null || return 1
      if ! brew list --cask font-hack-nerd-font >/dev/null 2>&1; then
        brew install --cask font-hack-nerd-font || return 1
      fi
      ;;
    Linux)
      font_dir="$setup_home/.local/share/fonts/HackNerdFont"
      
      if [[ -s "$local_font_mono" ]]; then
        log "Found local font: $local_font_mono. Installing without downloading..."
        mkdir -p "$font_dir" || return 1
        cp "$local_font_mono" "$font_dir/HackNerdFontMono-Regular.ttf" || return 1
        if command -v fc-cache >/dev/null; then
          fc-cache -f "$font_dir" || return 1
        fi
        return 0
      elif [[ -s "$local_font" ]]; then
        log "Found local font: $local_font. Installing without downloading..."
        mkdir -p "$font_dir" || return 1
        cp "$local_font" "$font_dir/HackNerdFont-Regular.ttf" || return 1
        if command -v fc-cache >/dev/null; then
          fc-cache -f "$font_dir" || return 1
        fi
        return 0
      fi

      # 如果本地没找到，走线上下载逻辑
      mkdir -p "$font_dir" || return 1
      for face in Regular Bold Italic BoldItalic; do
        file="HackNerdFont-$face.ttf"
        if [[ ! -s "$font_dir/$file" ]]; then
          download "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.5.1/patched-fonts/Hack/$face/$file" "$work_dir/$file" || return 1
          mv "$work_dir/$file" "$font_dir/$file" || return 1
          changed=true
        fi
      done
      if [[ ! -s "$font_dir/OFL.txt" ]]; then
        download 'https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.5.1/patched-fonts/Hack/OFL.txt' "$work_dir/OFL.txt" || return 1
        mv "$work_dir/OFL.txt" "$font_dir/OFL.txt" || return 1
      fi
      if $changed && command -v fc-cache >/dev/null; then
        fc-cache -f "$font_dir" || return 1
      fi
      ;;
  esac
}

# Installed fonts can be detected; the terminal's selected font cannot.
nerd_font_available() {
  local file family
  for file in "$setup_home"/Library/Fonts/*Nerd*.[to]tf \
              /Library/Fonts/*Nerd*.[to]tf \
              "$setup_home"/.local/share/fonts/*Nerd*/*.[to]tf \
              "$setup_home"/.local/share/fonts/*Nerd*.[to]tf; do
    [[ ! -s "$file" ]] || return 0
  done
  if command -v fc-list >/dev/null; then
    while IFS= read -r family; do
      [[ "$family" != *Nerd* ]] || return 0
    done < <(fc-list --format '%{family}\n' 2>/dev/null)
  fi
  return 1
}

unicode_fallback() {
  # Replace private-use font glyphs, keeping the preset's colors and layout.
  sed -i.bak -e 's/\\ue0b0/▶/g' \
      -e 's/󰈙/Docs/g' -e 's//Downloads/g' -e 's//Music/g' -e 's//Pictures/g' \
      -e 's//C/g' -e 's//C++/g' -e 's//Docker/g' -e 's//Elixir/g' \
      -e 's//Elm/g' -e 's//Git/g' -e 's//Go/g' -e 's//Haskell/g' \
      -e 's//Java/g' -e 's//Julia/g' -e 's//Node/g' -e 's/󰆥/Nim/g' \
      -e 's//Rust/g' -e 's//Scala/g' -e 's//Shell/g' -e 's///g' "$1"
  rm -f "$1.bak"
}

brew_ready=false
if [[ $(uname -s) == Darwin ]]; then
  if activate_brew; then
    brew_ready=true
  elif ! $skip_packages; then
    log 'Installing Homebrew...'
    if install_brew; then
      brew_ready=true
    else
      log 'NOTE: Homebrew installation failed; continuing without the OMZ brew plugin.'
    fi
  fi
fi

if ! $skip_packages; then
  log 'Installing missing optional tools...'
  if ! install_packages; then
    log 'NOTE: Package installation failed; configuring available components.'
  fi
fi
for tool in zsh git curl vim nvim fzf tmux starship; do
  command -v "$tool" >/dev/null || log "NOTE: $tool unavailable; skipping its integration."
done
editor_ready=false
if command -v vim >/dev/null || command -v nvim >/dev/null; then
  editor_ready=true
fi
starship_ready=false
if command -v starship >/dev/null || [[ -x "$setup_home/.local/bin/starship" ]]; then
  starship_ready=true
fi

if ! $skip_packages; then
  log 'Installing the Nerd Font for Pastel Powerline...'
  if [[ $(uname -s) == Darwin ]] && ! $brew_ready && [[ ! -s "./nerd-fonts/Hack Regular Nerd Font Complete Mono.ttf" ]] && [[ ! -s "./nerd-fonts/Hack Regular Nerd Font Complete.ttf" ]]; then
    log 'NOTE: Homebrew unavailable; skipping Nerd Font installation.'
  elif ! install_font; then
    log 'NOTE: Nerd Font installation failed; continuing setup.'
  fi
fi
nerd_font=false
if nerd_font_available; then
  nerd_font=true
else
  log 'No Nerd Font found; using Unicode separators and text icons.'
fi

log 'Preparing available shell and editor components...'
omz_dir="$setup_home/.oh-my-zsh"
custom_plugins="$omz_dir/custom/plugins"
omz_ready=false
if command -v zsh >/dev/null; then
  if [[ ! -e "$omz_dir" ]] && command -v git >/dev/null; then
    if git_clone https://github.com/ohmyzsh/ohmyzsh.git "$work_dir/oh-my-zsh"; then
      mv "$work_dir/oh-my-zsh" "$omz_dir"
    else
      log 'NOTE: Oh My Zsh installation failed; using plain Zsh.'
    fi
  fi
  if [[ -f "$omz_dir/oh-my-zsh.sh" ]]; then
    omz_ready=true
  else
    log 'NOTE: Oh My Zsh unavailable; using plain Zsh.'
  fi
fi

install_omz_plugin() {
  local name="$1" repository="$2"
  if [[ -f "$custom_plugins/$name/$name.plugin.zsh" || \
        -f "$omz_dir/plugins/$name/$name.plugin.zsh" ]]; then
    return 0
  fi
  command -v git >/dev/null || return 1
  [[ ! -e "$custom_plugins/$name" ]] || return 1
  mkdir -p "$custom_plugins" || return 1
  git_clone "$repository" "$work_dir/$name" || return 1
  [[ -f "$work_dir/$name/$name.plugin.zsh" ]] || return 1
  mv "$work_dir/$name" "$custom_plugins/$name"
}
if $omz_ready; then
  for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if ! install_omz_plugin "$plugin" "https://github.com/zsh-users/$plugin.git"; then
      log "NOTE: $plugin unavailable; skipping plugin."
    fi
  done
  if [[ ! -f "$custom_plugins/env/env.plugin.zsh" && ! -f "$omz_dir/plugins/env/env.plugin.zsh" ]]; then
    mkdir -p "$custom_plugins/env"
    cat > "$custom_plugins/env/env.plugin.zsh" <<'ENV_PLUGIN'
# Optional user environment settings, loaded before the remaining OMZ plugins.
typeset -U path
path=("$HOME/.local/bin" $path)
[[ ! -r "$HOME/.config/zsh/env.zsh" ]] || source "$HOME/.config/zsh/env.zsh"
ENV_PLUGIN
  fi
fi

if $editor_ready; then
  if [[ -s "$setup_home/.vim/autoload/plug.vim" ]]; then
    cp "$setup_home/.vim/autoload/plug.vim" "$work_dir/plug.vim"
  elif ! download https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim "$work_dir/plug.vim"; then
    rm -f -- "$work_dir/plug.vim"
    log 'NOTE: vim-plug unavailable; editors will use built-in functionality.'
  fi
fi

backup_root="$setup_home/.config/omz-starship-vim-backups"
mkdir -p "$backup_root"
backup_dir=$(mktemp -d "$backup_root/$(date +%Y%m%d-%H%M%S).XXXXXXXX")
for file in .zshrc .vimrc .vim/autoload/plug.vim .config/starship.toml .config/nvim/init.vim .config/nvim/init.lua; do
  if [[ -e "$setup_home/$file" || -L "$setup_home/$file" ]]; then
    mkdir -p "$backup_dir/$(dirname "$file")"
    cp -pL "$setup_home/$file" "$backup_dir/$file"
  fi
done

cat > "$work_dir/zshrc" <<'ZSHRC'
# Generated by omz-starship-vim.sh. Previous configuration is backed up.
export PATH="$HOME/.local/bin:$PATH"
if [[ "$OSTYPE" == darwin* ]] && ! command -v brew >/dev/null; then
  for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_path" ]]; then
      eval "$("$brew_path" shellenv)"
      break
    fi
  done
  unset brew_path
fi
# Preserve the active nvm Node ahead of Homebrew when restarting Zsh.
if [[ -n "$NVM_BIN" && -x "$NVM_BIN/node" ]]; then
  typeset -U path
  path=("$NVM_BIN" $path)
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
  aliases
  env
  git
  nvm
  z
  fzf
  tmux
  zsh-autosuggestions
  zsh-syntax-highlighting
)
# Load Node immediately, as requested.
zstyle ':omz:plugins:nvm' lazy no
[[ ! -r "$ZSH/oh-my-zsh.sh" ]] || source "$ZSH/oh-my-zsh.sh"
if (( ${plugins[(Ie)aliases]} && ${plugins[(Ie)z]} )); then
  alias j=z
fi
if (( $+widgets[autosuggest-accept] )); then
  bindkey '^ ' autosuggest-accept
fi

if command -v vim >/dev/null; then
  export EDITOR=vim VISUAL=vim
elif command -v nvim >/dev/null; then
  export EDITOR=nvim VISUAL=nvim
fi
[[ ! -f ~/.virtualenv/bin/activate ]] || source ~/.virtualenv/bin/activate
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else
  PROMPT=$'%~\n❯ '
fi
ZSHRC

if $brew_ready; then
  awk '{ print; if ($0 == "  aliases") print "  brew" }' "$work_dir/zshrc" > "$work_dir/zshrc-brew"
  mv "$work_dir/zshrc-brew" "$work_dir/zshrc"
fi

for plugin in aliases brew env git nvm z fzf tmux zsh-autosuggestions zsh-syntax-highlighting; do
  plugin_ready=false
  if $omz_ready && [[ -f "$custom_plugins/$plugin/$plugin.plugin.zsh" || -f "$omz_dir/plugins/$plugin/$plugin.plugin.zsh" ]]; then
    plugin_ready=true
  fi
  case "$plugin" in
    git|fzf|tmux) command -v "$plugin" >/dev/null || plugin_ready=false ;;
    brew) $brew_ready || plugin_ready=false ;;
  esac
  if ! $plugin_ready; then
    awk -v plugin="$plugin" '$0 != "  " plugin' "$work_dir/zshrc" > "$work_dir/zshrc-filtered"
    mv "$work_dir/zshrc-filtered" "$work_dir/zshrc"
  fi
done

cat > "$work_dir/starship.toml" <<'STARSHIP'
"$schema" = 'https://starship.rs/config-schema.json'

format = """
$os\
$username\
[\ue0b0](bg:204 fg:164)\
$directory\
[\ue0b0](fg:204 bg:216)\
$git_branch\
$git_status\
[\ue0b0](fg:216 bg:110)\
$c\
$elixir\
$elm\
$golang\
$gradle\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
$scala\
[\ue0b0](fg:110 bg:30)\
$docker_context\
[\ue0b0 ](fg:30)\
$line_break\
$character\
"""

[username]
show_always = true
style_user = "bg:164"
style_root = "bg:164"
format = '[$user ]($style)'
disabled = false

[os]
style = "bg:164"
disabled = true

[directory]
style = "bg:204"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[c]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[cpp]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[docker_context]
symbol = " "
style = "bg:30"
format = '[ $symbol $context ]($style)'

[elixir]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[elm]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[git_branch]
symbol = ""
style = "fg:22 bg:216"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "fg:22 bg:216"
format = '[$all_status$ahead_behind ]($style)'

[golang]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[gradle]
style = "fg:226 bg:110"
format = '[ $symbol ($version) ]($style)'

[haskell]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[java]
symbol = " "
style = "fg:226 bg:110"
format = '[ $symbol ($version) ]($style)'

[julia]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[nodejs]
symbol = ""
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[nim]
symbol = "󰆥 "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[rust]
symbol = ""
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[scala]
symbol = " "
style = "bg:110"
format = '[ $symbol ($version) ]($style)'

[line_break]
disabled = false

[character]
format = '$symbol '
success_symbol = '[❯](bold green)'
error_symbol = '[❯](bold red)'
vimcmd_symbol = '[❯](bold green)'
vimcmd_replace_one_symbol = '[❯](bold purple)'
vimcmd_replace_symbol = '[❯](bold purple)'
vimcmd_visual_symbol = '[❯](bold yellow)'
STARSHIP

if ! $nerd_font; then
  unicode_fallback "$work_dir/starship.toml"
fi

cat > "$work_dir/vimrc" <<'VIMRC'
" Generated by omz-starship-vim.sh. Previous configuration is backed up.
set nocompatible

" Resolve paths from this vimrc so SETUP_HOME also isolates plugin installation.
let s:vim_home = expand('<sfile>:p:h') . '/.vim'
execute 'set runtimepath^=' . fnameescape(s:vim_home)

if getfsize(s:vim_home . '/autoload/plug.vim') > 0
  call plug#begin(s:vim_home . '/plugged')
  Plug 'jiangmiao/auto-pairs'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'junegunn/vim-easy-align'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'mileszs/ack.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree'
  Plug 'tomasr/molokai'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-markdown'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'yuweijun/vim-monokai'
  call plug#end()
endif

filetype plugin indent on
syntax enable
set background=dark

" 某些老旧终端（如 Mac Terminal.app）开启 termguicolors 可能导致主题全黑。
" 如果颜色异常，可以取消下面这行的注释。
" set termguicolors

set number
set hidden
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" 使用 silent! 防止未安装主题时启动报错中断
silent! colorscheme molokai
VIMRC

cat > "$work_dir/nvim-init.vim" <<'NVIM'
" Generated by omz-starship-vim.sh. Vim and Neovim share plugins and settings.
execute 'source ' . fnameescape(fnamemodify(expand('<sfile>:p'), ':h:h:h') . '/.vimrc')
NVIM

# Replace only configurations for available components; symlink targets stay untouched.
if command -v zsh >/dev/null; then
  mv "$work_dir/zshrc" "$setup_home/.zshrc"
  if ! zsh -n "$setup_home/.zshrc"; then
    log 'NOTE: Zsh verification failed; other components are configured.'
  fi
fi
if $starship_ready; then
  mkdir -p "$setup_home/.config"
  mv "$work_dir/starship.toml" "$setup_home/.config/starship.toml"
fi
if $editor_ready; then
  mkdir -p "$setup_home/.vim/autoload"
  mv "$work_dir/vimrc" "$setup_home/.vimrc"
  if [[ -s "$work_dir/plug.vim" ]]; then
    mv "$work_dir/plug.vim" "$setup_home/.vim/autoload/plug.vim"
  fi
fi
if command -v nvim >/dev/null; then
  mkdir -p "$setup_home/.config/nvim"
  # init.lua conflicts with init.vim; its previous contents are already backed up.
  if [[ -e "$setup_home/.config/nvim/init.lua" || -L "$setup_home/.config/nvim/init.lua" ]]; then
    rm -- "$setup_home/.config/nvim/init.lua"
  fi
  mv "$work_dir/nvim-init.vim" "$setup_home/.config/nvim/init.vim"
fi

vim_plugins=(
  auto-pairs
  vim-easymotion
  vim-easy-align
  ctrlp.vim
  ack.vim
  nerdcommenter
  nerdtree
  molokai
  vim-endwise
  vim-markdown
  vim-repeat
  vim-surround
  vim-unimpaired
  vim-monokai
)
vim_plugins_ready=true
for plugin in "${vim_plugins[@]}"; do
  [[ -d "$setup_home/.vim/plugged/$plugin/.git" ]] || vim_plugins_ready=false
done
if $editor_ready && ! $vim_plugins_ready && [[ -s "$setup_home/.vim/autoload/plug.vim" ]]; then
  if command -v git >/dev/null; then
    log 'Installing missing shared Vim/Neovim plugins...'
    vim_log="$backup_dir/PlugInstall.log"
    if command -v vim >/dev/null; then
      editor=(vim -Nu "$setup_home/.vimrc" -n -es -i NONE "-V1$vim_log")
    else
      editor=(nvim --headless -u "$setup_home/.config/nvim/init.vim" -i NONE "-V1$vim_log")
    fi
    if ! "${editor[@]}" '+PlugInstall --sync' '+qa!'; then
      log "NOTE: Editor plugin installation failed; see $vim_log."
    fi
    for plugin in "${vim_plugins[@]}"; do
      [[ -d "$setup_home/.vim/plugged/$plugin/.git" ]] || log "NOTE: $plugin unavailable; continuing."
    done
  else
    log 'NOTE: Git unavailable; skipping editor plugin downloads.'
  fi
fi
if command -v nvim >/dev/null; then
  if ! nvim --headless -u "$setup_home/.config/nvim/init.vim" -i NONE '+qa!'; then
    log 'NOTE: Neovim verification failed; other components are configured.'
  fi
fi

log "Setup finished for available components. Previous configuration: $backup_dir"
if $nerd_font; then
  printf '%s\n' \
    'Unavailable tools/plugins were skipped; rerun later to install them.' \
    'Vim/Neovim share 14 plugins. Manage with :PlugStatus / :PlugUpdate when vim-plug is available.' \
    'Starship is configured with the Pastel Powerline preset (ANSI 256-color optimized).' \
    'Terminal font: select Hack Nerd Font in your terminal settings.'
else
  printf '%s\n' \
    'Unavailable tools/plugins were skipped; rerun later to install them.' \
    'Vim/Neovim share 14 plugins. Manage with :PlugStatus / :PlugUpdate when vim-plug is available.' \
    'Starship uses a transparent second-line ❯; missing Nerd Font uses Unicode fallback.'
fi
