# dotfiles

zsh (oh-my-zsh + powerlevel10k), tmux, Ghostty, and their shared cerne.pro
brand palette (heartwood amber / oxblood / sapwood on an ink background).

## Setup on a new machine

```sh
git clone https://github.com/Cerne17/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

This symlinks the dotfiles into `$HOME` (backing up anything already there
as `*.bak`) and installs the brew packages in `Brewfile`.

Manual steps `install.sh` can't do for you:
- If Ghostty isn't already your terminal, launch it once via the Brewfile
  cask install, then do the rest of the setup inside it.
- Set your terminal app's font to **MesloLGS NF** (installed by the
  Brewfile, but font selection is a terminal-app preference, not scriptable) —
  not needed for Ghostty, its config sets the font directly.
- Restart your terminal / `exec zsh`.
- Optional: run `p10k configure` to hand-tune the prompt instead of the
  bundled `.p10k.zsh` (Lean two-line preset, brand-recolored).

## What's here

| File | Purpose |
|---|---|
| `.zshrc` | oh-my-zsh config, plugins, aliases, fzf/zoxide/eza/bat wiring |
| `.zprofile` | Python/pyenv PATH setup |
| `.zshenv` | cargo env, local bin PATH |
| `.tmux.conf` | tmux status bar/pane styling, cerne.pro palette, truecolor |
| `.p10k.zsh` | Powerlevel10k prompt config (Lean preset, brand-recolored) |
| `.config/ghostty/config` | Ghostty palette/cursor/selection/font, cerne.pro brand |
| `Brewfile` | packages this setup depends on |

## Related

Neovim config is a separate repo (its own history, LazyVim-based):
https://github.com/Cerne17/Cerne-Nvim
