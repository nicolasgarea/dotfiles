# Dotfiles

This repository contains my configuration files for **shell**, **terminal**, and **editor**.

---

### Setup

Clone the repository:

```bash
git clone git@github.com:nicolasgarea/dotfiles.git ~/dotfiles
```

### Install Zsh

> Only run this step if Zsh is not already installed

```bash
if ! command -v zsh >/dev/null; then
  echo "Installing Zsh..."
  sudo apt update && sudo apt install -y zsh
fi
```

### Set Zsh as default shell

```bash
chsh -s "$(command -v zsh)"
```

### Link the Zsh configuration:

```bash
ln -sf ~/dotfiles/.zshrc ~/.zshrc
source ~/.zshrc
```

### Set up Alacritty configuration:

```bash
mkdir -p ~/.config/alacritty
cp -f ~/dotfiles/.config/colors.yaml ~/.config/alacritty/colors.yaml
cp -f ~/dotfiles/.config/fonts.yaml ~/.config/alacritty/fonts.yaml
cp -f ~/dotfiles/.config/alacritty.yaml ~/.config/alacritty/alacritty.yaml
```

### Set up VS Code settings:

```bash
mkdir -p ~/.config/Code/User
cp -f ~/dotfiles/.vscode/settings.json ~/.config/Code/User/settings.json
```
