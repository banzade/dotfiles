# Arch Linux dotfiles

Personal configuration for a Niri-based, Wayland desktop on Arch Linux. The
repository keeps its Git data in `~/.dotfiles` while the files stay in their
normal locations under `$HOME`.

## Included

| Area | Configuration |
| --- | --- |
| Compositor | Niri |
| Bar | Waybar |
| Launcher | Wofi |
| Terminal and shell | Alacritty, Zsh, Powerlevel10k |
| Editor | Neovim |
| Lock screen | Swaylock |

## Use on this machine

The shell already defines this alias:

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Use it like normal Git:

```bash
dotfiles status
dotfiles diff
dotfiles add .config/waybar/config
dotfiles commit -m 'Update Waybar'
dotfiles push
```

`status.showUntrackedFiles` is disabled so normal files in `$HOME` do not
overwhelm `dotfiles status`. Add a new configuration explicitly when it is
worth keeping.

## Restore on a new machine

Install `git`, then clone the repository and check it out into `$HOME`:

```bash
git clone --bare git@github.com:banzade/dotfiles.git "$HOME/.dotfiles"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

If checkout reports conflicts, move only the listed files somewhere safe,
then run `dotfiles checkout` again. Do not overwrite an existing configuration
until you have inspected it.

## After restoring

Install the programs used by the tracked configuration, then sign out and back
in. At a minimum the desktop needs Niri, Waybar, Alacritty, Wofi, Swaylock,
Zsh, and the configured clipboard, audio, network, and brightness utilities.

Package lists are intentionally not tracked here: they are machine-specific.
To save one before rebuilding a machine:

```bash
pacman -Qqe > "$HOME/pkglist.txt"
```
