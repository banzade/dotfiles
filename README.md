# 🐧 Arch Linux Dotfiles

My personal configuration files for a minimal and productive Arch Linux environment. Managed using the **Bare Git Repository** method to keep `$HOME` clean and symlink-free.

## 🛠 System Components
- **WM:** [Hyprland](https://hyprland.org/) (Wayland Compositor)
- **Bar:** [Waybar](https://github.com/Alexays/Waybar)
- **Terminal:** [Alacritty](https://alacritty.org/)
- **Shell:** Zsh (with custom alias management)

## 🚀 Quick Start (Restore on New System)

If you are setting this up on a fresh machine, follow these steps:

1. **Set the temporary alias:**
   ```bash
   alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

## 📦 Package Management
To keep track of installed software, I export my package list:
- **Export:** `pacman -Qqe > pkglist.txt`
- **Reinstall:** `sudo pacman -S --needed - < pkglist.txt`
