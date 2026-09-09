# dotfiles

zsh (oh-my-zsh + powerlevel10k), tmux, Ghostty, and their shared cerne.pro
brand palette (heartwood amber / oxblood / sapwood on an ink background) —
dark by default, with a full light ("sapwood") counterpart. Every color
pair here has been checked against WCAG AA (4.5:1 for text); see the
header comments in `.p10k.zsh`/`.p10k-light.zsh` and the config files
themselves for what was fixed and why (short version: a couple of spots
had the *light*-theme's muted-text token pasted into the dark config by
mistake, and oxblood — a brand background/depth color — was used as
foreground text in a few places, which fails contrast and contradicts the
brand guidelines' own "not for body text" rule).

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

## Light/dark: follows the system by default

Everything here defaults to matching macOS's Appearance setting (System
Settings → Appearance), no action needed:

- **Ghostty** auto-switches live (`theme = dark:cerne,light:cerne-light`
  in `.config/ghostty/config`) — it's a native app capability, no restart.
- **tmux** checks system appearance once at server start (`if-shell` at
  the end of `.tmux.conf`) and layers `.tmux-light.conf` on top if light.
- **zsh** (prompt + syntax highlighting) checks on every new shell
  (`_cerne_system_is_dark` in `.zshrc`).

An explicit choice overrides this and stays sticky until you switch back
to auto:

```sh
cerne-theme        # toggle explicit light/dark
cerne-theme light  # explicit
cerne-theme dark   # explicit
cerne-theme auto   # resume following the system
```

This re-sources the right `.p10k*.zsh`, swaps `ZSH_HIGHLIGHT_STYLES`, and
(if run inside tmux) re-syncs the matching `.tmux*.conf` immediately too.
The choice (`auto`/`light`/`dark`) persists in `~/.cache/cerne-theme` and
is re-applied on every new shell. `prefix + T` in tmux is a quick manual
toggle scoped to the current server session only (doesn't persist, and
doesn't touch the zsh/nvim side) — `cerne-theme` is the one that keeps
everything in sync.

## What's here

| File | Purpose |
|---|---|
| `.zshrc` | oh-my-zsh config, plugins, aliases, fzf/zoxide/eza/bat wiring, `cerne-theme` toggle |
| `.zprofile` | Python/pyenv PATH setup |
| `.zshenv` | cargo env, local bin PATH |
| `.tmux.conf` | tmux status bar/pane styling, cerne.pro palette (dark), truecolor |
| `.tmux-light.conf` | tmux styling, light counterpart |
| `.p10k.zsh` | Powerlevel10k prompt config (Lean preset, brand-recolored, dark) |
| `.p10k-light.zsh` | Powerlevel10k prompt config, light counterpart |
| `.config/ghostty/config` | Ghostty font/cursor-style/padding + `theme` directive |
| `.config/ghostty/themes/cerne` | Ghostty color theme (dark) |
| `.config/ghostty/themes/cerne-light` | Ghostty color theme (light) |
| `Brewfile` | packages this setup depends on |

## Related

Neovim config is a separate repo (its own history, LazyVim-based):
https://github.com/Cerne17/Cerne-Nvim — includes the matching `cerne` /
`cerne-light` colorschemes, same WCAG pass applied.
