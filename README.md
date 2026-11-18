# Arch Linux dotfiles

Personal configuration for a **Niri + DankMaterialShell** Wayland desktop on
Arch Linux. The repository is a normal Git checkout in `~/dotfiles`, split into
[GNU Stow](https://www.gnu.org/software/stow/) packages that are symlinked into
`$HOME`.

## Layout

Every top-level directory is a package whose contents mirror `$HOME`:

```text
~/dotfiles/
├── alacritty/.config/alacritty/     # Alacritty (developer-oriented config)
├── dms/.config/dms/                 # DankMaterialShell settings + theme
├── git/.gitconfig                   # Git identity and defaults
├── niri/.config/niri/               # Niri config and generated DMS fragments
├── nvim/.config/nvim/               # Neovim (lazy.nvim, pinned lazy-lock.json)
├── swaylock/.config/swaylock/
├── zsh/.zshrc
├── zsh/.p10k.zsh
├── examples/zshenv                  # template for the untracked ~/.zshenv
├── install.sh                       # stow all packages into $HOME
└── README.md
```

The real files live in the repository. `$HOME` only holds symlinks, for example:

```text
~/.config/niri            -> ../dotfiles/niri/.config/niri
~/.config/nvim            -> ../dotfiles/nvim/.config/nvim
~/.zshrc                  -> dotfiles/zsh/.zshrc
~/.gitconfig              -> dotfiles/git/.gitconfig
~/.config/DankMaterialShell -> dms   # compatibility alias kept by DMS
```

Editing any of those paths edits the tracked file directly. Hyprland support was
removed; Niri is the only compositor configured here.

## Included

| Area | Configuration |
| --- | --- |
| Compositor | Niri (scrollable tiling) |
| Desktop shell | DankMaterialShell (DMS) on Quickshell — bar, control center, notifications, spotlight, dock, clipboard, lock screen, screenshots |
| Login manager | greetd + tuigreet |
| Terminal | Alacritty with developer defaults (see below) |
| Shell | Zsh, Oh My Zsh, Powerlevel10k |
| Launcher | DMS Spotlight (`Mod+Space`, also `Mod+D`) |
| File manager | Dolphin (dark via the XDG portal color scheme) |
| Editor | Neovim |
| Clipboard | `wl-clipboard` + `cliphist` (DMS UI) |
| Lock screen | DMS lockscreen (`Mod+Esc` / `Mod+Alt+L`) |
| Theming | matugen dynamic colors from the DMS-managed wallpaper, Adwaita-dark GTK, Papirus icons |
| Fonts | `adwaita-fonts`, `ttf-jetbrains-mono-nerd` |

## Daily workflow

The shell defines `dotfiles` as a shortcut:

```bash
alias dotfiles='git -C "$HOME/dotfiles"'
```

Edit files at their normal paths, then work in the repository:

```bash
dotfiles status
dotfiles diff
dotfiles add niri/.config/niri/config.kdl
dotfiles commit -m "niri: adjust workspace binds"
dotfiles push
```

Because the repository is a regular checkout, `git -C ~/dotfiles …` works too.

### Add or change a package

```bash
mkdir -p ~/dotfiles/<package>/.config/<app>
mv ~/.config/<app> ~/dotfiles/<package>/.config/<app>
cd ~/dotfiles && stow -t "$HOME" <package>
```

Add the package name to `PACKAGES` in `install.sh` so a fresh machine links it
too. Removing a package: `cd ~/dotfiles && stow -D -t "$HOME" <package>`.

### Secrets

`~/.zshenv` is intentionally **not** tracked — it is sourced by every zsh
process and holds machine-specific paths and API keys. Start from the template:

```bash
cp ~/dotfiles/examples/zshenv ~/.zshenv
$EDITOR ~/.zshenv
```

`.env`, `.env.*`, `*.env`, key material, and other secrets are ignored by
`.gitignore`. Never commit them.

## Restore on a new machine

1. Install `git`, `stow`, and `zsh`:

```bash
sudo pacman -S --needed git stow zsh
```

2. Clone and link:

```bash
git clone git@github.com:banzade/dotfiles.git "$HOME/dotfiles"
"$HOME/dotfiles/install.sh"
cp "$HOME/dotfiles/examples/zshenv" "$HOME/.zshenv"   # then add secrets
```

If a target already exists, Stow refuses to overwrite it. Move the existing file
aside, re-run `install.sh`, then merge anything worth keeping.

3. Install the desktop packages (some pull their own dependencies):

```bash
sudo pacman -S --needed \
  niri dms-shell quickshell accountsservice matugen qt6-multimedia \
  alacritty zsh nvim \
  dolphin breeze network-manager-applet \
  pipewire pipewire-pulse pipewire-alsa pipewire-audio wireplumber \
  networkmanager bluez brightnessctl playerctl pamixer pavucontrol \
  cliphist wl-clipboard upower grim slurp \
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
  adwaita-fonts ttf-jetbrains-mono-nerd papirus-icon-theme \
  git stow greetd tuigreet qt6-wayland \
  ffmpeg btop htop curl wget gnupg unzip
```

4. Oh My Zsh + Powerlevel10k (the config is already tracked):

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
chsh -s /usr/bin/zsh
```

5. Post-restore tweaks:

```bash
# unified dark mode for GTK and (via portals) Qt apps like Dolphin
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
xdg-mime default org.kde.dolphin.desktop inode/directory

# make DMS own the wallpaper (it also drives matugen theming)
dms ipc call wallpaper set ~/Pictures/wallpaper/guts-bw.jpg
```

6. greetd (`/etc/greetd/config.toml`) starts the session with:

```toml
[default_session]
user = "greeter"
command = "tuigreet --time --greeting 'Welcome back' --remember --remember-user-session --user-menu --asterisks --cmd niri"
```

Or run `niri` from a plain tty; `spawn-at-startup` launches DMS, cliphist, and
the wallpaper watcher.

## Alacritty developer defaults

Beyond the baseline, `alacritty.toml` adds:

- login Zsh (`/bin/zsh -l`) so profile/PATH changes apply
- OSC 52 clipboard for SSH sessions
- `Ctrl+Shift+C/V`, `Shift+Insert`, and middle-click paste
- `Ctrl+Shift+N` new instance (inherits the current directory)
- `Ctrl+Shift+F` scrollback search, `Ctrl+Shift+Space` vi mode
- `Ctrl+Backspace` word erase (zsh/readline/vim friendly)
- semantic double-click selection for paths, URLs, and hashes
- `Alt+click` on URLs and `Ctrl+Shift+O` hint mode to open links
- `Ctrl+Shift+P` hint mode to open file paths from compiler/test output
- 100k line scrollback and live config reload

## Keybind cheat sheet

| Key | Action |
| --- | --- |
| `Mod+Return` | terminal (Alacritty) |
| `Mod+Space` / `Mod+D` | DMS Spotlight (app search) |
| `Mod+E` | file manager (Dolphin) |
| `Mod+N` | notification center |
| `Mod+V` | clipboard manager |
| `Mod+M` / `Ctrl+Alt+Del` | task manager |
| `Mod+Q` | close window |
| `Mod+F` / `Mod+Shift+F` | maximize / fullscreen |
| `Mod+Shift+T` | toggle floating |
| `Mod+1..9` | workspaces |
| `Mod+P` | display profile |
| `Print` / `Ctrl+Print` / `Alt+Print` | screenshot region / full / window |
| `XF86Audio*` / `XF86MonBrightness*` | volume / media / brightness |
| `Mod+Esc` | lock screen |
| `Mod+Shift+X` / `Mod+X` | DMS power menu |

The authoritative list is `niri/.config/niri/dms/binds.kdl` (generated by DMS)
plus the personal `binds` block in `niri/.config/niri/config.kdl`.

## Maintenance notes

- DMS regenerates `niri/.config/niri/dms/{layout,alttab,binds,...}.kdl` at
  runtime; review diffs before committing them.
- `alacritty/.config/alacritty/dank-theme.toml` is generated by matugen/DMS and
  ignored.
- Package lists are mostly machine-specific. Save a rebuild list when needed:

```bash
pacman -Qqe > "$HOME/pkglist.txt"
```
