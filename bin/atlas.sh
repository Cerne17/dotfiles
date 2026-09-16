#!/usr/bin/env bash
# Regenerates the Cerne Terminal Atlas: a single browsable HTML page listing
# every binding, alias and setting across Neovim, zsh, tmux and Ghostty.
#
# Everything is read from the running configuration rather than a hand-kept
# list, so adding a plugin is enough to make its keys show up here on the next
# run. Writes to ~/.cache/cerne-atlas/atlas.html unless given another path.
#
#   ./bin/atlas.sh              # regenerate and print the path
#   ./bin/atlas.sh --open       # regenerate and open it
#   ./bin/atlas.sh out.html     # regenerate to a specific file
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/atlas/template.html"
OUT="$HOME/.cache/cerne-atlas/atlas.html"
OPEN=0

for arg in "$@"; do
  case "$arg" in
    --open) OPEN=1 ;;
    -h|--help) sed -n '2,12p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) OUT="$arg" ;;
  esac
done

[ -f "$TEMPLATE" ] || { echo "atlas: template missing at $TEMPLATE" >&2; exit 1; }
command -v python3 >/dev/null || { echo "atlas: python3 required" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# ---- Neovim: the live keymap table, categorised by lua/config/keymap-explorer.lua ----
# VeryLazy has to be fired by hand: it normally waits on UIEnter, which never
# arrives in --headless, and config/keymaps.lua would otherwise never load.
if command -v nvim >/dev/null && [ -f "$HOME/.config/nvim/lua/config/keymap-explorer.lua" ]; then
  echo "atlas: reading Neovim keymaps..." >&2
  nvim --headless "$HOME/.config/nvim/init.lua" "+lua vim.defer_fn(function()
    pcall(vim.api.nvim_exec_autocmds, 'User', { pattern = 'VeryLazy', modeline = false })
    vim.defer_fn(function()
      local ok, err = pcall(function()
        local out = {}
        for _, e in ipairs(require('config.keymap-explorer').collect()) do
          out[#out+1] = { lhs = e.lhs, desc = e.desc, modes = e.modes, plugin = e.plugin, category = e.category }
        end
        vim.fn.writefile({ vim.json.encode(out) }, '$WORK/nvim.json')
      end)
      if not ok then vim.fn.writefile({ 'nvim dump failed: ' .. tostring(err) }, '$WORK/nvim.err') end
      vim.cmd('qa!')
    end, 2500)
  end, 7000)" >/dev/null 2>&1 || true
  [ -f "$WORK/nvim.err" ] && cat "$WORK/nvim.err" >&2
fi

# ---- tmux: needs a server to query, so start a throwaway one if none is up ----
if command -v tmux >/dev/null; then
  echo "atlas: reading tmux keys..." >&2
  TMP_SESSION=""
  if ! tmux has-session 2>/dev/null; then
    tmux new-session -d -s _atlas_probe 2>/dev/null && TMP_SESSION=_atlas_probe
  fi
  { tmux list-keys -T prefix; tmux list-keys -T root; tmux list-keys -T copy-mode-vi; } \
    2>/dev/null > "$WORK/tmux.raw" || true
  [ -n "$TMP_SESSION" ] && tmux kill-session -t "$TMP_SESSION" 2>/dev/null || true
fi

# ---- zsh: the alias table of a real interactive shell ----
echo "atlas: reading zsh aliases..." >&2
zsh -i -c 'alias' 2>/dev/null > "$WORK/zsh.raw" || true

# ---- Ghostty ----
GHOSTTY="$HOME/.config/ghostty/config"
[ -f "$GHOSTTY" ] && cp "$GHOSTTY" "$WORK/ghostty.conf"

WORK="$WORK" TEMPLATE="$TEMPLATE" OUT="$OUT" python3 <<'PYEOF'
import json, os, pathlib, re, collections

work = pathlib.Path(os.environ["WORK"])
items = []

# Neovim. Vim's own defaults and mini.pairs are dropped: they describe the
# editor, not this configuration.
nvim_file = work / "nvim.json"
if nvim_file.exists():
    for e in json.loads(nvim_file.read_text()):
        if e["category"] in ("Vim Built-ins", "Auto-pairs"):
            continue
        items.append({"tool": "Neovim", "key": e["lhs"], "desc": e["desc"],
                      "cat": e["category"], "modes": "".join(e["modes"]),
                      "src": e.get("plugin") or ""})

# tmux. The mouse display-menus are hundreds of characters of nested format
# strings and tell a reader nothing, so anything that long is skipped.
TCAT = [("Panes", r"select-pane|resize-pane|swap-pane|split-window|break-pane|join-pane"),
        ("Windows", r"select-window|new-window|next-window|previous-window|kill-window|rename-window|last-window"),
        ("Sessions", r"new-session|choose-tree|detach|switch-client|kill-session"),
        ("Copy mode", r"copy-mode|send-keys -X|paste-buffer|choose-buffer"),
        ("Theme", r"cerne|tmux-light|source-file"),
        ("Plugins/Tools", r"lazygit|display-popup|tpm|run-shell"),
        ("Misc", r".")]
seen = set()
tmux_file = work / "tmux.raw"
if tmux_file.exists():
    for line in tmux_file.read_text().splitlines():
        m = re.match(r'\s*bind-key\s+(?:-r\s+)?-T\s+(\S+)\s+(\S+)\s+(.*)', line)
        if not m:
            continue
        table, key, cmd = m.groups()
        cmd = cmd.strip()
        if len(cmd) > 110:
            continue
        # The root table is mostly mouse bindings; only the navigator keys matter.
        if table == "root" and not re.match(r'^C-[hjkl]$', key):
            continue
        disp = {"prefix": "prefix + ", "root": "", "copy-mode-vi": "copy-mode "}.get(table, "") + key.replace("\\", "")
        if disp in seen:
            continue
        seen.add(disp)
        items.append({"tool": "tmux", "key": disp, "desc": cmd,
                      "cat": next(n for n, p in TCAT if re.search(p, cmd)), "modes": "", "src": ""})

# zsh aliases.
ZCAT = [("Git", r"^g[a-z]*=|git "), ("Navigation", r"^\.+=|^cd |^[0-9]=|^-="),
        ("Docker", r"docker|^dc[a-z]*=|^dk"), ("Modern CLI", r"eza|bat |^cat=|^ls=|^ll=|^la=|^lt="),
        ("Config", r"nvim |zshrc"), ("Misc", r".")]
zsh_file = work / "zsh.raw"
if zsh_file.exists():
    for line in zsh_file.read_text().splitlines():
        if "=" not in line:
            continue
        name, val = line.split("=", 1)
        if not name or name.startswith("_"):
            continue
        items.append({"tool": "zsh", "key": name, "desc": val.strip().strip("'"),
                      "cat": next(n for n, p in ZCAT if re.search(p, line)), "modes": "", "src": "alias"})

# Widgets and functions have no table to enumerate, so the notable ones are
# listed by hand. Keep this in step with .zshrc.
for name, desc, cat in [
    ("cerne-theme [light|dark|auto]", "Switch the cerne.pro palette across zsh, tmux and nvim", "Theme"),
    ("Ctrl+R", "fzf: fuzzy search shell history", "fzf"),
    ("Ctrl+T", "fzf: fuzzy-find a file and insert its path", "fzf"),
    ("Alt+C", "fzf: fuzzy-find a directory and cd into it", "fzf"),
    ("Tab", "fzf-tab: completion menu as an fzf picker", "fzf"),
    ("Ctrl+G", "navi: interactive cheatsheet, expands into the prompt", "navi"),
    ("z <dir>", "zoxide: jump to a frecently-used directory", "Navigation"),
    ("nvm", "Lazy-loaded; sources nvm.sh on first use", "Node"),
]:
    items.append({"tool": "zsh", "key": name, "desc": desc, "cat": cat, "modes": "", "src": "function"})

# Ghostty.
g = work / "ghostty.conf"
if g.exists():
    appearance = {"theme", "cursor-style", "font-family", "font-size",
                  "window-padding-x", "window-padding-y"}
    for line in g.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = [x.strip() for x in line.split("=", 1)]
        cat = "Keybinds" if k == "keybind" else ("Appearance" if k in appearance else "Behaviour")
        items.append({"tool": "Ghostty", "key": k, "desc": v, "cat": cat, "modes": "", "src": ""})

slim = [{k: v for k, v in i.items() if v} for i in items]
payload = json.dumps(slim, ensure_ascii=False, separators=(",", ":"))

out = pathlib.Path(os.environ["OUT"])
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(pathlib.Path(os.environ["TEMPLATE"]).read_text().replace("__DATA__", payload))

counts = collections.Counter(i["tool"] for i in items)
print("atlas: {} entries ({})".format(
    len(items), ", ".join(f"{t} {n}" for t, n in counts.most_common())))
PYEOF

echo "atlas: wrote $OUT"
[ "$OPEN" -eq 1 ] && open "$OUT"
exit 0
