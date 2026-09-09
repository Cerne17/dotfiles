# Enable Powerlevel10k instant prompt. Should stay close to the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages extract docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# cerne.pro brand palette: light/dark toggle for autosuggestions + syntax
# highlighting + prompt. Default is "auto": follows the macOS system
# appearance on every new shell. `cerne-theme [light|dark]` sets an
# explicit override that stays sticky across shells; `cerne-theme auto`
# resumes following the system. State persisted in ~/.cache/cerne-theme
# (contents: "auto", "light", or "dark"). Any explicit/auto switch also
# re-syncs tmux's status bar if run inside one. All fg values below are
# independently WCAG-AA verified (>=4.5:1) against their own background;
# see colors/cerne.lua / cerne-light.lua in Cerne-Nvim for the same audit
# applied to Neovim.
CERNE_THEME_STATE="$HOME/.cache/cerne-theme"

_cerne_system_is_dark() {
  [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]
}

_cerne_apply_dark() {
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#9A968C"
  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[default]='fg=#E8E4DB'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#9A968C'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#4E8F6B'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#4E8F6B'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#4E8F6B'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#4E8F6B'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#4E8F6B'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#4E8F6B,underline'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#4E8F6B'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#E89A3C'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#9A968C'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#E8E4DB,underline'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#9A968C'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F6B65A'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#F6B65A'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#9A968C'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#9A968C'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#E89A3C'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F6B65A'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F6B65A'
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#F6B65A'
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#F6B65A'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#9A968C'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#E89A3C'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#CC5837,bold' # WCAG-safe tint of oxblood; raw oxblood is only 2.56:1 as text on ink
  CERNE_P10K_CONFIG="$HOME/.p10k.zsh"
}

_cerne_apply_light() {
  # amber (heartwood) fails contrast on light per the brand guidelines, so
  # oxblood (#8C3B24) stands in for both heartwood and heartwood-glow, same
  # as the docs specify. `#526D89` is a darkened, light-safe tint of the
  # dark theme's info-blue, used here only so strings/quotes don't collide
  # with the oxblood-colored keywords — the brand doc doesn't allocate a
  # separate hue for that on light, this is the pragmatic minimal addition.
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5A5852"
  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[default]='fg=#1A1B1E'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#5A5852'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#3A6E52'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#3A6E52'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#3A6E52'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#3A6E52'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#3A6E52'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#3A6E52,underline'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#3A6E52'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8C3B24'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#5A5852'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#1A1B1E,underline'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#5A5852'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#526D89'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#526D89'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#5A5852'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#5A5852'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#8C3B24'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#526D89'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#526D89'
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#526D89'
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#526D89'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#5A5852'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#8C3B24'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#8C3B24,bold'
  CERNE_P10K_CONFIG="$HOME/.p10k-light.zsh"
}

cerne-theme() {
  local arg="$1"
  local want

  if [ "$arg" = "auto" ]; then
    want="auto"
  elif [ "$arg" = "light" ] || [ "$arg" = "dark" ]; then
    want="$arg"
  elif [ -z "$arg" ]; then
    # No arg: toggle the currently-*resolved* polarity explicitly
    # (regardless of whether we got here via auto or an explicit pick).
    [ "$CERNE_THEME_RESOLVED" = "dark" ] && want="light" || want="dark"
  else
    echo "usage: cerne-theme [light|dark|auto]" >&2
    return 1
  fi

  mkdir -p "$(dirname "$CERNE_THEME_STATE")"
  echo "$want" > "$CERNE_THEME_STATE"

  local resolved="$want"
  [ "$want" = "auto" ] && { _cerne_system_is_dark && resolved="dark" || resolved="light"; }
  CERNE_THEME_RESOLVED="$resolved"

  if [ "$resolved" = "light" ]; then
    _cerne_apply_light
  else
    _cerne_apply_dark
  fi
  [[ -f "$CERNE_P10K_CONFIG" ]] && source "$CERNE_P10K_CONFIG"
  command -v p10k >/dev/null 2>&1 && p10k reload

  if [ -n "$TMUX" ]; then
    if [ "$resolved" = "light" ]; then
      tmux source-file ~/.tmux-light.conf
    else
      tmux source-file ~/.tmux.conf
    fi
  fi
  if [ "$want" = "auto" ]; then
    echo "cerne: auto ($resolved, following system)"
  else
    echo "cerne: $resolved theme (explicit)"
  fi
}

# Apply the saved (or system-detected) theme on shell startup
CERNE_THEME_STARTUP="auto"
[ -f "$CERNE_THEME_STATE" ] && CERNE_THEME_STARTUP="$(cat "$CERNE_THEME_STATE")"
if [ "$CERNE_THEME_STARTUP" = "light" ] || { [ "$CERNE_THEME_STARTUP" = "auto" ] && ! _cerne_system_is_dark; }; then
  CERNE_THEME_RESOLVED="light"
  _cerne_apply_light
else
  CERNE_THEME_RESOLVED="dark"
  _cerne_apply_dark
fi

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias nvimrc="nvim ~/.config/nvim"
alias com="git commit -m"
alias gc="git commit -m"
alias push="git push"
alias zshrc="nvim ~/.zshrc"

# Added by Antigravity
export PATH="/Users/miguelcerne/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/miguelcerne/.antigravity-ide/antigravity-ide/bin:$PATH"

# fzf (fuzzy finder): Ctrl+R history, Ctrl+T files, Alt+C cd
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide (smart cd) - replaces `z` plugin, avoids alias collision
eval "$(zoxide init zsh)"

# eza/bat: modern ls/cat
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first"
alias la="eza -la --icons --group-directories-first"
alias lt="eza --tree --icons --group-directories-first"
alias cat="bat --paging=never"

# Powerlevel10k config (dark/light chosen above by cerne-theme's startup logic)
[[ -f "$CERNE_P10K_CONFIG" ]] && source "$CERNE_P10K_CONFIG"
