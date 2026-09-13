# Guarded: a machine without Rust would otherwise print an error on every
# single zsh invocation, interactive or not.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"
