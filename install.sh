#!/usr/bin/env bash
# Link every package in this repository into $HOME with GNU Stow.
# Safe to re-run: Stow adopts existing, correct symlinks.
set -euo pipefail

cd "$(dirname "$0")"

PACKAGES=(
  alacritty
  dms
  git
  niri
  nvim
  swaylock
  zsh
)

if ! command -v stow >/dev/null 2>&1; then
  printf 'GNU Stow is required. On Arch Linux:\n\n  sudo pacman -S stow\n\n' >&2
  exit 1
fi

stow --verbose=1 --target="$HOME" "${PACKAGES[@]}"
