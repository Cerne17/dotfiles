#!/usr/bin/env bash
# Symlinks these dotfiles into $HOME. Existing non-symlink files are backed
# up to *.bak before being replaced. Safe to re-run.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES=(.zshrc .zprofile .zshenv .tmux.conf .tmux-light.conf .p10k.zsh .p10k-light.zsh)

link() {
  local rel="$1" target="$HOME/$1" src="$DOTFILES_DIR/$1"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
    echo "ok      $rel (already linked)"
    return
  fi
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ]; then
    mv "$target" "$target.bak"
    echo "backup  $rel -> $rel.bak"
  fi
  ln -s "$src" "$target"
  echo "linked  $rel"
}

for f in "${FILES[@]}"; do
  link "$f"
done
link ".config/ghostty/config"
link ".config/ghostty/themes/cerne"
link ".config/ghostty/themes/cerne-light"

if command -v brew >/dev/null 2>&1; then
  echo
  echo "Installing Homebrew packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
else
  echo
  echo "Homebrew not found — install it first, then run: brew bundle --file=$DOTFILES_DIR/Brewfile"
fi

echo
echo "Done. nvim config lives in its own repo:"
echo "  git clone https://github.com/Cerne17/Cerne-Nvim.git ~/.config/nvim"
echo
echo "Then set your terminal font to 'MesloLGS NF' and restart your shell."
