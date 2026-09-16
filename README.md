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
as `*.bak`), clones tpm, and installs the brew packages in `Brewfile`.

The symlinks are the point: editing `~/.zshrc` has to be the same thing as
editing this repo. If they are ever replaced by plain copies the two drift
apart silently, so it is worth checking:

```sh
ls -l ~/.zshrc ~/.tmux.conf ~/.config/ghostty/config   # each should be a symlink
```

Re-run `install.sh` if any of them is a regular file.

Manual steps `install.sh` can't do for you:
- If Ghostty isn't already your terminal, launch it once via the Brewfile
  cask install, then do the rest of the setup inside it.
- Set your terminal app's font to **MesloLGS NF** (installed by the
  Brewfile, but font selection is a terminal-app preference, not scriptable) —
  not needed for Ghostty, its config sets the font directly.
- Restart your terminal / `exec zsh`.
- Optional: run `p10k configure` to hand-tune the prompt instead of the
  bundled `.p10k.zsh` (Lean two-line preset, brand-recolored).

## Light/dark: follows the system by default, live

Everything here defaults to matching macOS's Appearance setting (System
Settings → Appearance), no action needed:

- **Ghostty** auto-switches live — a native app capability, no restart.
- **tmux** and **nvim** (open instances too, not just new ones) switch
  live via `bin/cerne-theme-watch.sh`, a `launchd` LaunchAgent
  (`launchagents/pro.cerne.theme-watch.plist.template`, installed by
  `install.sh`) that watches `~/Library/Preferences/.GlobalPreferences.plist`
  — the file macOS writes to the instant Dark Mode toggles — and reacts
  within ~1s. No polling. Neovim's built-in RPC server (`v:servername`,
  auto-started per instance) is how it reaches an already-open nvim;
  tmux gets `source-file`d directly on its socket. Only touches sessions
  currently in "auto" mode (see below) — an explicit pick is left alone.
  `.GlobalPreferences.plist` holds far more than just the Dark Mode flag
  (recent items, input sources, etc.), so most triggers have nothing to
  do with appearance — the script caches the last-applied polarity in
  `/tmp/cerne-theme-watch.last` and exits immediately (~17ms, no tmux/nvim
  work at all) unless it actually changed. Logs to
  `/tmp/cerne-theme-watch.log`; check it's running with
  `launchctl list pro.cerne.theme-watch`.
- **zsh** (prompt + syntax highlighting) checks on every new shell
  (`_cerne_system_is_dark` in `.zshrc`) — not live within an already-open
  shell, since there's no live-reactive way to restyle an in-progress
  prompt without disrupting it.

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
everything in sync. It sets the `@cerne_explicit` tmux option, which
suppresses the appearance probe at the bottom of `.tmux.conf`; without
that the toggle could never reach dark while macOS was in light mode,
since sourcing the dark config would re-detect light and bounce straight
back. `cerne-theme auto` clears the flag.

## tmux keys

`prefix` is still `C-b`.

| Key | Action |
|---|---|
| `C-h` / `C-j` / `C-k` / `C-l` | Move across panes *and* Neovim splits (vim-tmux-navigator, no prefix) |
| `prefix + \|` / `prefix + -` | Split vertically / horizontally, keeping the current directory |
| `prefix + h/j/k/l` | Select pane left/down/up/right |
| `prefix + H/J/K/L` | Resize pane (repeatable) |
| `prefix + g` | lazygit in a popup |
| `prefix + r` | Reload the config |
| `prefix + T` | Toggle light/dark for this server |
| `prefix + I` / `prefix + U` | tpm: install / update plugins |

`Ctrl+G` in the shell opens the navi cheatsheet picker (see below).

Copy mode uses vi keys: `v` selects, `y` copies to the macOS clipboard.
Sessions are saved and restored automatically by resurrect + continuum,
Neovim sessions included.

## Terminal Atlas

`bin/atlas.sh` builds a single browsable HTML page listing every binding, alias
and setting across all four tools, read out of the *running* configuration:
Neovim's live keymap table (via `lua/config/keymap-explorer.lua` in the nvim
repo), `tmux list-keys`, an interactive shell's alias table, and the Ghostty
config. Adding a plugin is enough for its keys to appear on the next run —
there is no list to maintain.

```sh
./bin/atlas.sh --open           # regenerate and open it
./bin/atlas.sh ~/atlas.html     # regenerate to a specific path
```

Output defaults to `~/.cache/cerne-atlas/atlas.html`. Vim's own built-in
mappings and mini.pairs are excluded — they describe the editor, not this
setup.

## Cheatsheets (navi)

`Ctrl+G` opens [navi](https://github.com/denisidoro/navi): a fuzzy picker over
the sheets in `cheats/`, which expands the chosen command into the prompt and
prompts for any `<placeholder>` first. Placeholders backed by a `$ name:` line
offer real values — `git checkout <lost_sha>` picks from your actual reflog
rather than asking you to type a hash.

`cheats/cerne.cheat` covers this setup itself: regenerating the Atlas, the
theme toggle and its watcher, re-linking the dotfiles, the Brewfile, tmux
sessions and tpm, Neovim maintenance, and the git operations that are easy to
get wrong. `install.sh` symlinks the sheets into navi's cheats directory, so
editing them here is editing them live.

This is the one part of the setup that does *not* derive itself from anything —
sheets are written by hand and go stale if the commands change.

## Shell startup

Around 180ms. `nvm` is the reason it is not 500ms: sourcing `nvm.sh`
eagerly cost 340ms, so the default node version goes straight on `PATH`
and only the `nvm` command itself is a lazy stub. `node`, `npm` and `npx`
stay real binaries and never pay for it; `nvm` loads on first use, or on
entering a directory with a `.nvmrc`.

## What's here

| File | Purpose |
|---|---|
| `.zshrc` | oh-my-zsh config, plugins, aliases, fzf/fzf-tab/zoxide/eza/bat wiring, lazy nvm, `cerne-theme` toggle |
| `.zprofile` | Python/pyenv PATH setup |
| `.zshenv` | cargo env, local bin PATH |
| `.tmux.conf` | tmux keybindings, plugins (tpm), status bar/pane styling, cerne.pro palette (dark), truecolor |
| `.tmux-light.conf` | tmux styling, light counterpart |
| `.p10k.zsh` | Powerlevel10k prompt config (Lean preset, brand-recolored, dark) |
| `.p10k-light.zsh` | Powerlevel10k prompt config, light counterpart |
| `.config/ghostty/config` | Ghostty font/cursor-style/padding + `theme` directive |
| `.config/ghostty/themes/cerne` | Ghostty color theme (dark) |
| `.config/ghostty/themes/cerne-light` | Ghostty color theme (light) |
| `bin/atlas.sh` | Regenerates the Terminal Atlas from the running config |
| `bin/atlas/template.html` | The Atlas page; the generator injects the dataset into it |
| `cheats/cerne.cheat` | navi cheatsheet for this setup (`Ctrl+G`) |
| `bin/cerne-theme-watch.sh` | Pushes system-appearance changes into "auto" tmux/nvim instances |
| `launchagents/pro.cerne.theme-watch.plist.template` | LaunchAgent for the above (installed to `~/Library/LaunchAgents`) |
| `Brewfile` | packages this setup depends on |

## Related

Neovim config is a separate repo (its own history, LazyVim-based):
https://github.com/Cerne17/Cerne-Nvim — includes the matching `cerne` /
`cerne-light` colorschemes, same WCAG pass applied.
