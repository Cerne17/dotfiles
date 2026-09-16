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

chmod +x "$DOTFILES_DIR/bin/cerne-theme-watch.sh"

# navi cheatsheets. navi reads whatever is in its cheats directory, so the
# repo's sheets are symlinked in rather than copied.
if command -v navi >/dev/null 2>&1; then
  NAVI_CHEATS="$(navi info cheats-path 2>/dev/null || echo "$HOME/.local/share/navi/cheats")"
  mkdir -p "$NAVI_CHEATS"
  for sheet in "$DOTFILES_DIR"/cheats/*.cheat; do
    [ -e "$sheet" ] || continue
    ln -sfn "$sheet" "$NAVI_CHEATS/$(basename "$sheet")"
    echo "linked  cheats/$(basename "$sheet")"
  done
fi

# tmux plugin manager, required by the @plugin lines in .tmux.conf.
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
  echo "ok      tpm (already cloned)"
else
  echo
  echo "Cloning tmux plugin manager..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "Open tmux and press prefix + I to install the plugins."
fi

if [ "$(uname)" = "Darwin" ]; then
  echo
  echo "Installing cerne-theme-watch LaunchAgent (instant tmux/nvim theme"
  echo "sync on macOS Dark Mode toggle, no manual command needed)..."
  mkdir -p "$HOME/Library/LaunchAgents"
  plist="$HOME/Library/LaunchAgents/pro.cerne.theme-watch.plist"
  sed "s|__HOME__|$HOME|g" "$DOTFILES_DIR/launchagents/pro.cerne.theme-watch.plist.template" > "$plist"
  launchctl unload "$plist" >/dev/null 2>&1 || true
  launchctl load "$plist"
  echo "installed $plist"
fi

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
