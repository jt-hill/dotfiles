# dotfiles to make things the way I like them

## neovim + lazyvim

lazyvim has some requirements, of which the most important is tree-sitter

```bash
sudo pacman -S neovim
sudo pacman -S git rg fd fzf curl unzip tar
sudo pacman -S lazygit tree-sitter tree-sitter-cli
```

```bash
# launch neovim with minimal config 
nvim

# launch neovim with lazyvim config
lvim 
```

## sway + breeze

### Sway setup

```bash
# Core Sway
sudo pacman -S sway waybar swaybg swaylock swayidle kitty rofi

# System utilities
sudo pacman -S network-manager-applet blueman pavucontrol brightnessctl
sudo pacman -S pamixer playerctl grim slurp dunst

# Breeze theme + Qt bridge
sudo pacman -S breeze breeze-gtk breeze-icons
sudo pacman -S qt5ct qt6ct kvantum

# XDG portal for theme switching
sudo pacman -S xdg-desktop-portal-gtk xdg-desktop-portal-wlr

# Polkit agent (for password prompts)
sudo pacman -S polkit-gnome

# Optional but recommended
sudo pacman -S wl-clipboard noto-fonts noto-fonts-emoji
```

**Make theme-toggle executable:**

   ```bash
   chmod +x ~/.local/bin/theme-toggle
   ```

## joplin TUI

```bash
# requires npm
sudo pacman -S npm

#install through npm
NPM_CONFIG_PREFIX=~/.joplin-bin npm install --loglevel=error -g joplin
# symlink to bin dir
sudo ln -s ~/.joplin-bin/bin/joplin /usr/local/bin/joplin
```
