#!/usr/bin/env bash
#
# Idempotent installer for these dotfiles.
# Safe to run multiple times — existing files are backed up, never overwritten.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
CHANGED=0

info()  { printf '  \033[34m·\033[0m %s\n' "$1"; }
ok()    { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn()  { printf '  \033[33m!\033[0m %s\n' "$1"; }
head_() { printf '\n\033[1m%s\033[0m\n' "$1"; }

# ---------------------------------------------------------------- symlinks

link() {
  local src="$1" dest="$2"

  [ -e "$src" ] || { warn "missing in repo: ${src#$DOTFILES/}"; return 0; }

  # Already correct? Nothing to do.
  if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
    ok "${dest/#$HOME/~}"
    return 0
  fi

  # Something else is there — back it up.
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP/$(dirname "${dest#$HOME/}")"
    mv "$dest" "$BACKUP/${dest#$HOME/}"
    warn "backed up existing ${dest/#$HOME/~}"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  ok "${dest/#$HOME/~} -> ${src#$DOTFILES/}"
  CHANGED=1
}

# ---------------------------------------------------------------- packages

need_cmd() { command -v "$1" >/dev/null 2>&1; }

apt_install() {
  local missing=()
  for pkg in "$@"; do
    dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done

  if [ ${#missing[@]} -eq 0 ]; then
    ok "packages already installed"
    return 0
  fi

  info "installing: ${missing[*]}"
  sudo apt-get update -qq
  sudo apt-get install -y "${missing[@]}"
  CHANGED=1
}

# ---------------------------------------------------------------- steps

install_packages() {
  head_ "Packages"
  if ! need_cmd apt-get; then
    warn "not a Debian/Ubuntu system — install manually: zsh git curl unzip alacritty"
    return 0
  fi
  apt_install zsh git curl unzip fontconfig
  need_cmd alacritty && ok "alacritty present" || warn "alacritty not installed (see README)"
}

install_font() {
  head_ "JetBrainsMono Nerd Font"

  if [ -d "$HOME/.local/share/fonts/JetBrainsMono" ]; then
    ok "already installed"
    return 0
  fi

  local dir="$HOME/.local/share/fonts/JetBrainsMono"
  local tmp; tmp="$(mktemp -d)"

  info "downloading..."
  curl -fsSL -o "$tmp/font.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

  mkdir -p "$dir"
  unzip -qo "$tmp/font.zip" -d "$dir"
  rm -rf "$tmp"
  fc-cache -f >/dev/null
  ok "installed"
  CHANGED=1
}

install_zplug() {
  head_ "zplug"
  if [ -d "$HOME/.zplug" ]; then
    ok "already installed"
    return 0
  fi
  info "cloning..."
  git clone -q https://github.com/zplug/zplug "$HOME/.zplug"
  ok "installed"
  CHANGED=1
}

install_omz() {
  head_ "oh-my-zsh"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "already installed"
    return 0
  fi
  info "cloning..."
  git clone -q https://github.com/ohmyzsh/ohmyzsh "$HOME/.oh-my-zsh"
  ok "installed"
  CHANGED=1
}

link_configs() {
  head_ "Symlinks"
  link "$DOTFILES/.zshrc"                   "$HOME/.zshrc"
  link "$DOTFILES/.gitconfig"               "$HOME/.gitconfig"
  link "$DOTFILES/.gitignore_global"        "$HOME/.gitignore_global"
  link "$DOTFILES/.config/alacritty"        "$HOME/.config/alacritty"
  link "$DOTFILES/.vscode/settings.json"    "$HOME/.config/Code/User/settings.json"
}

set_shell() {
  head_ "Default shell"

  local zsh_path; zsh_path="$(command -v zsh || true)"
  [ -n "$zsh_path" ] || { warn "zsh not found, skipping"; return 0; }

  if [ "${SHELL:-}" = "$zsh_path" ]; then
    ok "already zsh"
    return 0
  fi

  info "run this to switch (asks for your password):"
  printf '      chsh -s %s\n' "$zsh_path"
}

load_gnome() {
  head_ "GNOME settings"

  if ! need_cmd dconf; then
    warn "dconf not found — skipping"
    return 0
  fi

  dconf load /org/gnome/desktop/interface/ < "$DOTFILES/gnome/interface.ini"
  dconf load /org/gnome/shell/extensions/  < "$DOTFILES/gnome/extensions.ini"
  ok "applied"

  if need_cmd gnome-extensions && [ -f "$DOTFILES/gnome/extensions-list.txt" ]; then
    local missing=()
    while read -r ext; do
      [ -n "$ext" ] || continue
      gnome-extensions info "$ext" >/dev/null 2>&1 || missing+=("$ext")
    done < "$DOTFILES/gnome/extensions-list.txt"

    if [ ${#missing[@]} -gt 0 ]; then
      warn "extensions not installed: ${missing[*]}"
      info "install them via the Extension Manager app"
    fi
  fi
}

# ---------------------------------------------------------------- main

main() {
  printf '\n\033[1mdotfiles\033[0m  %s\n' "$DOTFILES"

  install_packages
  install_font
  install_zplug
  install_omz
  link_configs
  set_shell

  if [ "${1:-}" = "--with-gnome" ]; then
    load_gnome
  else
    head_ "GNOME settings"
    info "skipped — run with --with-gnome to apply"
  fi

  head_ "Done"
  [ -d "$BACKUP" ] && info "backups in ${BACKUP/#$HOME/~}"
  if [ "$CHANGED" -eq 1 ]; then
    info "restart your terminal to pick up the changes"
  else
    ok "nothing to do, everything was already in place"
  fi
  printf '\n'
}

main "$@"
