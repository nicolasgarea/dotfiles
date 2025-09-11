# Dotfiles

This repository contains my configuration files for shell, terminal, and editor.

---

### Setup

Clone the repository:

```bash
git clone git@github.com:nicolasgarea/dotfiles.git ~/dotfiles
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
