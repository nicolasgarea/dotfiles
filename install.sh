#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y zsh curl git fonts-powerline

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

if ! command -v alacritty &> /dev/null; then
  sudo add-apt-repository -y ppa:aslatter/ppa
  sudo apt update
  sudo apt install -y alacritty
fi


FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

if [ ! -f "$FONTS_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
  wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip | bsdtar -xvf- -C "$FONTS_DIR"
  fc-cache -fv
fi

cp ./zsh/.zshrc $HOME/.zshrc

echo "Instalación completada. Cambia a zsh con 'chsh -s $(which zsh)' si aún no lo hiciste."
