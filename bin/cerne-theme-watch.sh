#!/usr/bin/env bash
# Pushes the current macOS appearance into every tmux server and nvim
# instance currently in "auto" mode. Triggered by a launchd LaunchAgent
# watching ~/Library/Preferences/.GlobalPreferences.plist (which macOS
# writes to the instant Dark Mode toggles) — see
# ~/Library/LaunchAgents/pro.cerne.theme-watch.plist. Safe to run by hand
# too; every action here is idempotent.
#
# Respects the same explicit-override model as `cerne-theme` / <leader>uC:
# a sticky explicit pick is left alone, only "auto" (or no state file yet)
# gets updated.
set -uo pipefail

is_dark() {
  [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]
}

# ---- tmux: re-source the matching config for every "auto" server ----
sync_tmux() {
  local state="auto"
  [ -f "$HOME/.cache/cerne-theme" ] && state="$(cat "$HOME/.cache/cerne-theme")"
  [ "$state" = "auto" ] || return 0

  local conf="$HOME/.tmux.conf"
  is_dark || conf="$HOME/.tmux-light.conf"

  local sockdir="/tmp/tmux-$(id -u)"
  [ -d "$sockdir" ] || return 0
  local sock
  for sock in "$sockdir"/*; do
    [ -S "$sock" ] || continue
    tmux -S "$sock" source-file "$conf" >/dev/null 2>&1
  done
}

# ---- nvim: push :CerneThemeAuto into every "auto" instance ----
sync_nvim() {
  local state_file="$HOME/.local/state/nvim/cerne_colorscheme"
  local state="auto"
  [ -f "$state_file" ] && state="$(cat "$state_file")"
  [ "$state" = "auto" ] || return 0

  local tmpdir
  tmpdir="$(getconf DARWIN_USER_TEMP_DIR 2>/dev/null || echo "$TMPDIR")"
  local pattern="${tmpdir%/}/nvim.$(whoami)/*/nvim.*.0"
  local sock
  for sock in $pattern; do
    [ -S "$sock" ] || continue
    nvim --headless --server "$sock" --remote-send '<Cmd>CerneThemeAuto<CR>' >/dev/null 2>&1
  done
}

sync_tmux
sync_nvim
